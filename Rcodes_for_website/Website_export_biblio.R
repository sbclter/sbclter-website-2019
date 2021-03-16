
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(reshape2)
library(dplyr)
library(stringr)
library(tidyr)
library(RPostgreSQL)
library(yaml)

if(Sys.info()[['sysname']]=="Darwin") {sys="/Volumes/sbclter/"}else {sys="X:/"}

source(paste0(sys,"internal/research/Metadata/EML_post_2017/00_batch/user_info.r"))


 # loads the PostgreSQL driver
  
 drv <- dbDriver("PostgreSQL")
 # creates a connection to the postgres database
 # note that "con" will be used later in each connection to the database

  
 con <- dbConnect(drv, dbname = "mini_sbclter",
                 host = host, port = 5432,
                 user = user, password = password)

 # check for the tables
 
pub<-dbReadTable(con, c("biblio","publication_bibtex")) 
pubcro<-dbReadTable(con, c("biblio","pub_people_crossref")) 
presentation<-dbReadTable(con, c("biblio","publication_presentation")) 
people<-dbReadTable(con, c("lter_metabase","People")) 
projectpersonnel<-dbReadTable(con, c("research_project","ResearchProjectPersonnel")) 
 
dbDisconnect(con)

#############################################################

#combine all publications, including presentation. 
presentation1<-presentation %>% mutate(category="Presentation")

pub_all<-bind_rows(pub,presentation1)


#################
#get all the author names in corrected format
data1 <- pub_all %>%
  select(sbc_id,author) %>%
  mutate(author=trimws(author),
         indiname=strsplit(as.character(author),split = ";"))%>%
  unnest(indiname) %>%
  select(-author) %>%
  mutate(ID=1:n(),
         indiname=if_else(str_detect(indiname,","),indiname,paste0(indiname,",")), #add the comma in the last name to make the extraction easier
         indiname=gsub("\\.([A-Z])",". \\1",indiname,perl=T))

data2 <-data1 %>%
  dplyr::select(ID,indiname) %>%
  mutate(namesplit=strsplit(as.character(indiname),split = " ")) %>%
  unnest(namesplit) %>%
  filter(!namesplit=="") %>%
  mutate(namesplit=gsub("([A-Z])([A-Z])", "\\1 \\2", namesplit)) #some names have two capital letter together

data3<-data2 %>%
  mutate(last=if_else(str_detect(namesplit,","),namesplit,as.character(NA)),
         first=if_else(!str_detect(namesplit,","),paste0(str_extract(namesplit, "[A-Z]"),"."),as.character(NA)))

data_last<-data3%>%
  filter(!is.na(last))%>%
  select(ID,last)
  
data_first<-data3 %>%
  filter(!is.na(first))%>%
  group_by(ID) %>%
  summarise(first = paste(first, collapse=" ")) %>%
  ungroup()

name_all <- data_first %>%
  left_join(data_last,by="ID") %>%
  mutate(name=paste0(last," ",first)) %>%
  select(ID,name) %>%
  left_join(data1,by="ID")
  
name_select<-name_all %>% #select the top 10 authors only  
  group_by(sbc_id) %>%
  mutate(freq=n()) %>%
  group_by(sbc_id,freq) %>%  
  slice(1:10) %>%
  summarise(name_all= paste(name, collapse=", "),.groups="drop") %>%
  mutate(name_all=if_else(freq>=10,paste0(name_all,", et al."),name_all)) %>%
  select(-freq)

pub_all1<-name_select%>%
  left_join(pub_all,by="sbc_id")

###################################
#create citation


pub2<-data.frame(pub_all1) %>%
  filter(year!="In press") %>%
  mutate(citation=case_when(
    category=="Article"~paste0(name_all," (",year,"). ",title,". ",journal,". ",volume,":",pages,". ",if_else(doi=="","",paste("DOI:",doi))),
    category=="Techreport"~paste0(name_all," (",year,"). ",title,". ",publisher, ". ",if_else(number=="","",paste(". Report number:",number))),
    category=="Inproceedings"~paste0(name_all," (",year,"). ",title,". In: ",booktitle,". ",publisher, ". "),
    category=="Incollection"~paste0(name_all," (",year,"). ",title," ed.",editor,". In: ",booktitle,". ",publisher),
    category=="Book"~paste0(name_all,". ",title,", (",year,"). ",publisher,". ",if_else(doi=="",as.character(isbn),as.character(doi))),
    category=="Mastersthesis"|category=="phdthesis"~paste0(name_all,". ",title,". (",year,"). ",school,". "),
    category=="Presentation"~paste0(name_all," (",year,"). ",title,". Presented at the meeting of ", conferencename,", ", conferencelocation),
    TRUE~as.character(" ")
  ))  %>%
  mutate(citation=gsub(" :","",citation, fixed = TRUE),
        citation=gsub(" . ","",citation, fixed = TRUE),
        citation=gsub(".. ",". ",citation, fixed = TRUE),
        hyperlink=url) %>%
  select(sbc_id,year,category,hyperlink,citation) %>%
  filter(!citation==" ")


##cross ref to people

project<-projectpersonnel%>%
  filter(ProjectID==99904) %>%
  select(NameID) 

cros<-pubcro %>%
  rename(NameID=nameid) %>%
  filter(NameID %in% project$NameID) %>%
  left_join(people,by="NameID") %>%
  mutate(name=paste0(SurName,", ",GivenName)) %>%
  group_by(sbc_id) %>%
  summarise(author=paste(name, collapse="; ")) %>%
  ungroup()
  
# merge the people info and the citation together

pub3<-pub2 %>%
  left_join(cros,by="sbc_id") %>%
  mutate(citation=paste0(trimws(citation),"\n"))

pub3[is.na(pub3)]<-""

citation.out <- as.yaml(pub3, column.major=F)

write_yaml(citation.out,"Website_citation_export.yml",fileEncoding = "UTF-8",unicode = TRUE) 


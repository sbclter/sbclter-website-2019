
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(dplyr)
library(stringr)
library(tidyr)
library(RPostgreSQL)
library(yaml)
library(reshape2)
source("X:/internal/research/Metadata/EML_post_2017/00_batch/user_info.r")
#source("/Volumes/sbcbon/internal/research/Metadata/EML_post_2017/00_batch/user_info.r")

 # loads the PostgreSQL driver
  
 drv <- dbDriver("PostgreSQL")
 # creates a connection to the postgres database
 # note that "con" will be used later in each connection to the database

  
 con <- dbConnect(drv, dbname = "mini_sbclter",
                 host = host, port = 5432,
                 user = user, password = password)

 # check for the tables
collection<-dbReadTable(con, c("website_data_catalog","vw_pkg_collections")) 
collectionpkgs<-dbReadTable(con, c("website_data_catalog","vw_xref_datapackage")) 
habitat<-dbReadTable(con, c("website_data_catalog","vw_xref_habitat")) 
maplayer<-dbReadTable(con, c("website_data_catalog","vw_xref_maplayer")) 
site<-dbReadTable(con, c("website_data_catalog","vw_sampling_site")) 

dbDisconnect(con)

#############################################################

collectionpkgs1<-collectionpkgs %>%
  arrange(collection_id,sortorder) %>%
  rename(dataset_sortorder=sortorder) %>%
  select(-datasetid)

for (j in 1:nrow(collectionpkgs1)){
  
  collectionpkgs1$package[[j]]=list(docid=collectionpkgs1$dataset_archive_id[j],
                                    shortTitle=collectionpkgs1$nickname[j])
}

collection1 <- collection %>%
  select(id,collectionname)%>%
  rename(collection_id=id)

collectionpkgs2<-as_tibble(select(collectionpkgs1,collection_id,package))%>%
  nest(package=package)

geodata1 <- collectionpkgs %>%
  left_join(site, by="datasetid") %>%
  distinct(collection_id,title,description,southbound,northbound,eastbound,westbound)


for (i in 1:nrow(geodata1)){
  
  geodata1$geodata_location[[i]]=list(title=geodata1$title[i],
                              description=geodata1$description[i],
                              southbound=geodata1$southbound[i],
                              northbound=geodata1$northbound[i],
                              westbound=geodata1$westbound[i],
                              eastbound=geodata1$eastbound[i])
}  
 
geodata2<-as_tibble(select(geodata1,collection_id,geodata_location))%>%
  nest(geodata_location=geodata_location)%>%
  left_join(collection1,by="collection_id")

maplayer1<- maplayer %>%
  left_join(collectionpkgs2, by="collection_id") %>%
  left_join(geodata2,by="collection_id") %>%
  left_join(habitat, by="collection_id") 

df4 <- list()
for (i in 1:nrow(maplayer1)){
  df3<-list(id=maplayer1$maplayer[[i]],
            label=maplayer1$definition[[i]],
            collectionName=maplayer1$collectionname[[i]],
            frequency=maplayer1$frequency[[i]],
            initiated=maplayer1$initiated[[i]],
            habitatName=maplayer1$habitat[[i]],
            habitatLabel=maplayer1$habitat_label[[i]],
            geodata=maplayer1$geodata_location[[i]]$geodata_location,
            packages=maplayer1$package[[i]]
           )
  
  df4<-c(df4,list(df3))
  
  
}

write_yaml(df4,"sbcMapLayer.yaml",fileEncoding = "UTF-8",unicode = TRUE) 



rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(reshape2)
library(dplyr)
library(stringr)
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
 
 people<-dbReadTable(con, c("Reporting","vw_website_personnel")) 
 
 
 dbDisconnect(con)

people[is.na(people)]<-""

people1<-people %>%
  mutate(profileText=paste0(trimws(profileText),"\n"))


people.out <- as.yaml(people1, column.major=F)

write_yaml(people.out,paste0("Website_people_export_",Sys.Date(),".yml")) 

           
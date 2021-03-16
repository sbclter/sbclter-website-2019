
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


library(dplyr)
library(stringr)
library(tidyr)
library(RPostgreSQL)
library(yaml)
library(reshape2)

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
collection<-dbReadTable(con, c("website_data_catalog","vw_pkg_collections")) 
collectionpkgs<-dbReadTable(con, c("website_data_catalog","vw_xref_datapackage")) 
habitat<-dbReadTable(con, c("website_data_catalog","vw_xref_habitat")) 
maplayer<-dbReadTable(con, c("website_data_catalog","vw_xref_maplayer")) 
measurement<-dbReadTable(con, c("website_data_catalog","vw_xref_measurement")) 
ltercore<-dbReadTable(con, c("website_data_catalog","vw_xref_ltercra")) 


dbDisconnect(con)

#############################################################
#df<- read_yaml("dataCollections_trial.yaml", fileEncoding = "UTF-8")

collectionpkgs1<-collectionpkgs %>%
  arrange(collection_id,sortorder) %>%
  rename(dataset_sortorder=sortorder) %>%
  select(-datasetid)

for (j in 1:nrow(collectionpkgs1)){
    
  collectionpkgs1$package[[j]]=list(docid=collectionpkgs1$dataset_archive_id[j],
                                    shortTitle=collectionpkgs1$nickname[j])
}

collectionpkgs2<-as_tibble(select(collectionpkgs1,collection_id,package))%>%
 nest(package=package)
  
habitat1<- habitat %>%
  dplyr::select(collection_id,habitat) %>%
  nest(habitats = habitat)

maplayer1<- maplayer %>%
  dplyr::select(collection_id,maplayer) %>%
  dplyr::rename(mapLayer=maplayer) %>%
  nest(mapLayers = mapLayer)

measurement1<- measurement %>%
  dplyr::rename(measurementType=measurementtype) %>%
  nest(measurementTypes = measurementType)

ltercore1<- as_tibble(ltercore) %>%
  dplyr::rename(lterCoreResearchArea=ltercra) %>%
  nest(lterCoreResearchAreas = lterCoreResearchArea)

df1 <- collection %>%
  dplyr::rename(collection_id=id) %>%
  dplyr::left_join(habitat1,by="collection_id") %>%
  dplyr::left_join(measurement1,by="collection_id") %>%
  dplyr::left_join(ltercore1,by="collection_id") %>%
  dplyr::left_join(maplayer1,by="collection_id") %>%
  dplyr::left_join(collectionpkgs2,by="collection_id") %>%
  arrange(sortorder) %>%
  dplyr::rename(`_id`=collection_id,
                collectionName=collectionname) %>%
  select(collectionName,abstract,package,habitats,measurementTypes,lterCoreResearchAreas,mapLayers,`_id`)


#df2<-split(df1, seq(nrow(df1)))

df4 <- list()
for (i in 1:nrow(df1)){
   df3<-list(collectionName=df1[i,"collectionName"],
             abstract=df1[i,"abstract"],
             dataPackages=df1$package[[i]],
             habitats=df1$habitats[[i]],
             measurementTypes=df1$measurementTypes[[i]],
             lterCoreResearchAreas=df1$lterCoreResearchAreas[[i]],
             mapLayers=df1$mapLayers[[i]])

  df4<-c(df4,list(df3))
  
}

write_yaml(df4,"dataCollections.yaml",fileEncoding = "UTF-8",unicode = TRUE) 





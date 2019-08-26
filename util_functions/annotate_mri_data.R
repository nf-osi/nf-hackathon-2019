library(synapser)
library(tidyverse)
library(fmri)
synLogin()

fv <- synTableQuery("select * from syn20686637")$asDataFrame()

parent_id_names <- sapply(unique(fv$parentId)[1:5], function(x){
  ptofpt <- synGet(x)$properties$parentId
  synGet(ptofpt)$properties$name
})

fv_update <- mutate(fv, assay = "MRI") %>% 
  mutate(resourceType = "experimentalData") %>% 
  mutate(fileFormat = str_extract(name, "\\..+") %>% str_remove('\\.')) %>% 
  mutate(dataType = case_when(name == "if.txt" ~ "metadata", 
                   name != "if.txt" ~ "raw"),
         experimentalCondition = case_when(name == ""))

df <- dicomTable(list(tmp$hdr))
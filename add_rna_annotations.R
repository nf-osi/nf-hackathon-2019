library(synapser)
synLogin()
library(tidyverse)

tab <- synTableQuery('select distinct specimenID, tumorType from syn20449214')$asDataFrame() %>% 
  select(-tumorType)



map <- feather::read_feather('filt_nf_cogaps.feather') %>% 
  select(specimenID, tumorType, modelOf) %>% 
  mutate(tumorType = case_when(tumorType != "non-tumor" ~ tumorType,
                               tumorType %in%$ 'non-tumor' ~ "")) %>% 
  distinct()

tab_update <- left_join(tab,map)

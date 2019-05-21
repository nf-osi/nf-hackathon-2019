## Start from this Docker image
FROM rocker/tidyverse
## use rocker as a base image

## install synapser reqs
RUN apt-get update -y
RUN apt-get install -y dpkg-dev zlib1g-dev libssl-dev libffi-dev
RUN apt-get install -y curl libcurl4-openssl-dev

## install synapser
RUN R -e "install.packages('synapser', repos=c('http://ran.synapse.org', 'http://cran.fhcrc.org'))"

## install bioconductor
RUN R -e "install.packages('BiocManager')"
RUN R -e "BiocManager::install('GSVA', version = "3.8")"
RUN R -e "BiocManager::install('GSEABase', version = "3.8")"
RUN R -e "BiocManager::install('org.Hs.eg.db', version = "3.8")"
RUN R -e "BiocManager::install('limma', version = "3.8")"

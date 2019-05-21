# 2019 San Francisco NF Hackathon

The Children’s Tumor Foundation (CTF), the Neurofibromatosis Therapeutic Acceleration Program (NTAP), Sage Bionetworks, and the Silicon Valley AI group (SVAI) are excited to announce the second Neurofibromatosis (NF) hackathon that will be held in San Francisco in concomitance with the 2019 CTF Patient Forum and NF Conference.  The first-ever NF2 hackathon, held in SF in June 2017 (https://sv.ai/hackathon), focused on a single set of genetic data (donated by Onno Faber, entrepreneur, and NF2 patient). Following in the footsteps of this successful event, the 2019 Hackathon will focus on analyzing diverse datasets including genomic, drug screening, drug-target association, imaging, and other data for all the three conditions of NF (NF1, NF2, Schwannomatosis).
 
We believe that open science, collaboration, and talented people are three main ingredients we need to bake a cure for NF. The event plans to attract experts in AI, Genomics, Bioinformatics, Computer Science, and Life Science to glean new insights into these rare diseases.  Gathering these experts to find new associations, new perspectives, and revolutionizing the way we think about NF will create the right turf where great discoveries could happen! 
 
The goals of the NF Hackathon are: 1) to make use of the data that our researchers and scientists have already produced, 2) to incentivize data sharing as a powerful practice that will allow researchers to move at a faster pace and create new insights, and 3) to create innovative collaborations between diverse disciplines.

## How to use this repository

We've prepared Docker containers that contain all of the necessary dependencies to retrieve data from Synapse and perform some basic analyses of these data. The goal of this is to help you orient yourself to the data prior to the event in September.
We've created containers for both R and Python users. You can find instructions on running these containers and following the data demos below. 
If you like, you can also use these containers as a basis for creating your own Docker containers during the hackathon so that others can reproduce your analyses.

### Prerequisites 

These instructions assume that you:
-have registered for a (Synapse account)[https://www.synapse.org/#!RegisterAccount:0] 
-are a member of the [2019 Hackathon Participants Team](https://www.synapse.org/#!Team:3389360) on Synapse. 
-have [installed Docker Community Edition](https://docs.docker.com/v17.12/install/) and that the docker service is running on your machine
-are running a Unix-based OS, such as Ubuntu or Mac. These instructions have not been tested on Windows-based platforms.

### RStudio Docker Image

1. Open your command line interface, such as Terminal. 
2. Do `docker login docker.synapse.org` and enter your Synapse credentials to log into the Synapse Docker repository.
3. Do `docker pull docker.synapse.org/syn18666641/nf_hackathon:R_demos` to get the Docker image. 
4. Do `docker run -e PASSWORD=<mypassword> --rm -p 8787:8787 docker.synapse.org/syn18666641/nf_hackathon:R_demos` to start the container. Make sure to replace `<mypassword>` with a unique password. It cannot be "rstudio"!
5. Open your preferred browser and navigate to `localhost:8787`. 
6. In the Files pane, click on "0-setup.Rmd" to get started, and to learn how to make your Synapse credentials available to `synapser`. 

### jupyter Docker Image

TBA


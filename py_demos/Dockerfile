##Start from base jupyter notebook docker container
FROM jupyter/datascience-notebook

##jupyter does not have root user as default, so switch to root to use apt-get and pip3
USER root 

#upgrade pip and get synapseclient
RUN pip install --upgrade pip
RUN pip install synapseclient

COPY 0-setup.ipynb /home/jovyan/work/0-setup.ipynb

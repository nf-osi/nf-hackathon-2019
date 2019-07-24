##Start from base jupyter notebook docker container
FROM jupyter/base-notebook

##jupyter does not have root user as default, so switch to root to use apt-get and pip3
USER root 

#upgrade pip and get synapseclient
RUN pip install --upgrade pip
RUN pip install synapseclient numpy pandas seaborn umap-learn matplotlib rpy2 adjustText hdbscan sklearn 
RUN mkdir /home/jovyan/work/output

COPY 0-setup.ipynb /home/jovyan/work/0-setup.ipynb

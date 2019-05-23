FROM jupyter/datascience-notebook

RUN apt-get update && apt-get install -y \
	python3 \
	python3-pip \
	python3-pandas

RUN pip3 install --upgrade pip
RUN pip3 install synapseclient

COPY 0-setup.ipynb ~/0-setup.ipynb


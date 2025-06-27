# Dumpster-Archiver

This container image collects dumpster diving spots from https://www.dumpstermap.org/page/about and to uploads them to https://huggingface.co/datasets/Hitchwiki/dumpster-diving-spots.

# Deployment

Currently this archiver is deployed by @tillwenke on Azure like this:

Get an Azure account with a Subscription and create the resource group `dumpstermap`. Then run the following from terminal:

az login       

az acr create --name dumpstermap --resource-group dumpstermap --sku Basic

az acr login --name dumpstermap  

docker build -t dumpstermap-huggingface-uploader:v3 .  

docker tag dumpstermap-huggingface-uploader:v3 dumpstermap.azurecr.io/dumpstermap-huggingface-uploader:v3

docker push dumpstermap.azurecr.io/dumpstermap-huggingface-uploader:v3

create a Azure Container App Jobs

- set env var HF_TOKEN with write permissions

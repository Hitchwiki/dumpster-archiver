az login

az group create --name dumpster --location germanywestcentral

az acr create \
  --name crdumpster \
  --resource-group dumpster \
  --sku Basic \
  --admin-enabled true

az acr login --name crdumpster

docker build -t crdumpster.azurecr.io/dumpster-huggingface-uploader:v1 ./image/

docker push crdumpster.azurecr.io/dumpster-huggingface-uploader:v1




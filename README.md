# Dumpster-Archiver

This container image collects dumpster diving spots from https://www.dumpstermap.org/page/about and to uploads them to https://huggingface.co/datasets/Hitchwiki/dumpster-diving-spots.

# Deployment

Currently this archiver is deployed by @tillwenke on Azure like this:

Get an Azure account with a Subscription. Then run the following from terminal:

# select the subscription

```
chomd 777 azure.sh
./azure_setup.sh
```

create a scheduled Azure Container App Job to run on the first of every month:


In `.env` set the variables:
- HF_TOKEN with write permissions in huggingface

```
chomd 777 azure.sh
./azure_deploy.sh
```
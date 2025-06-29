#!/bin/bash
set -a
source .env
set +a

az monitor log-analytics workspace create \
    --resource-group dumpster \
    --workspace-name dumpster-logs

WORKSPACE_ID=$(az monitor log-analytics workspace show \
    --resource-group dumpster \
    --workspace-name dumpster-logs \
    --query customerId --output tsv)

WORKSPACE_KEY=$(az monitor log-analytics workspace get-shared-keys \
    --resource-group dumpster \
    --workspace-name dumpster-logs \
    --query primarySharedKey --output tsv)

az containerapp env create \
    --name dumpster-env \
    --resource-group dumpster \
    --location germanywestcentral \
    --logs-workspace-id $WORKSPACE_ID \
    --logs-workspace-key $WORKSPACE_KEY

REGISTRY_PASSWORD=$(az acr credential show \
  --name crdumpster \
  --query "passwords[0].value" \
  --output tsv)


az containerapp job create \
    --name huggingface-upload-job \
    --resource-group dumpster \
    --environment dumpster-env \
    --replica-timeout 3600 \
    --replica-retry-limit 0 \
    --replica-completion-count 1 \
    --parallelism 1 \
    --trigger-type Schedule \
    --cron-expression "0 0 1 * *" \
    --image crdumpster.azurecr.io/dumpster-huggingface-uploader:v1 \
    --cpu 2.0 \
    --memory 4.0Gi \
    --registry-server crdumpster.azurecr.io \
    --registry-username crdumpster \
    --registry-password "$REGISTRY_PASSWORD" \
    --env-vars HF_TOKEN="$HF_TOKEN"
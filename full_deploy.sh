#!/bin/bash
project="tilellia-test4"
domain="example2.tilelli.me"
CLIENT_ID="<redacted>"
SECRET="<redacted>"

pushd example_1_items/
pushd default
yes | gcloud app deploy app.yaml  --project="$project"
popd
pushd paid
yes | gcloud app deploy app.yaml  --project="$project"
popd
yes | gcloud app deploy dispatch.yaml --project="$project"

# Can used set project?
gcloud domains list-user-verified --project="$project"

# Is already set?
gcloud app domain-mappings list --project="$project"

# Map Domain
gcloud app domain-mappings create "$domain" --certificate-management='AUTOMATIC'  --project="$project"

# Pause for cert to generate

# IAP 
# GENERATE OUTH CLIENT ID + Secret

# Enable IAP
# https://cloud.google.com/sdk/gcloud/reference/iap/web/enable
gcloud iap web enable --resource-type=app-engine --oauth2-client-id="$CLIENT_ID" --oauth2-client-secret="$SECRET" --project="$project"

# Set IAP access policy 
yes | gcloud iap web set-iam-policy global_iap_policy.yaml  --resource-type=app-engine --project=$project
yes | gcloud iap web set-iam-policy front_page_policy.yaml  --resource-type=app-engine --project=$project --service=default
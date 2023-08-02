#!/bin/sh

export project_id="proj-newsshield-com-ops-392712"
export workload_identity_pool="github-action-sachai-pool"
export workload_identity_pool_provider="github-action-sachai-provider"
export repo_owner="wohlig"

export service_account=$(gcloud iam service-accounts create github-action-svc \
  --display-name "Service account for GitHub Actions workflow" \
  --format "value(email)")

gcloud projects add-iam-policy-binding $(gcloud config get-value core/project) \
  --member serviceAccount:$service_account \
  --role roles/artifactregistry.writer

gcloud projects add-iam-policy-binding $(gcloud config get-value core/project) \
  --member serviceAccount:$service_account \
  --role roles/container.developer

gcloud services enable iamcredentials.googleapis.com \
  --project "${project_id}"

gcloud iam workload-identity-pools create "${workload_identity_pool}" \
  --project="${project_id}" \
  --location="global" \
  --display-name="${workload_identity_pool}"

export workload_identity_pool_id=$(gcloud iam workload-identity-pools describe "${workload_identity_pool}" \
  --project="${project_id}" \
  --location="global" \
  --format="value(name)")

gcloud iam workload-identity-pools providers create-oidc "${workload_identity_pool_provider}" \
  --project="${project_id}" \
  --location="global" \
  --workload-identity-pool="${workload_identity_pool}" \
  --display-name="${workload_identity_pool_provider}" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
  --issuer-uri="https://token.actions.githubusercontent.com"

gcloud iam service-accounts add-iam-policy-binding "${service_account}" \
  --project="${project_id}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${workload_identity_pool_id}/attribute.repository_owner/${repo_owner}"


echo workload_identity_provider=$(gcloud iam workload-identity-pools providers describe "${workload_identity_pool_provider}" \
  --project="${project_id}" \
  --location="global" \
  --workload-identity-pool="${workload_identity_pool}" \
  --format="value(name)")


#!/bin/bash

function _gke_select_cluster() {
  IFS=';' read -ra clusters <<< "$(gcloud container clusters list --uri $@ | sort -k9 -t/ | tr '\n' ';')"
  local count=1
  for i in ${clusters[@]}; do
    IFS="/" read -ra TOKS <<< "${i}"
    echo "  $count) ${TOKS[-1]} (${TOKS[-3]})" >&2
    ((count=count+1))
  done
  local sel=0
  while [[ $sel -lt 1 || $sel -ge $count ]]; do
    read -p "Select a GKE cluster: " sel >&2
  done
  echo "${clusters[(sel-1)]}"
}

function _prompt_project_id() {
  local default=$(gcloud config get-value project 2>/dev/null)
  [[ -z "${default}" ]] && default="none"
  read -p "Enter Project ID ($default)): " project_id >&2
  if [[ -z "${project_id}" ]]; then
    echo "$default"
  else
    echo "$project_id"
  fi
}

function gke-credentials() {
  [[ $@ =~ -p ]] && project_id=$(_prompt_project_id)
  [[ -z "${project_id}" ]] && project_id=$(gcloud config get-value project 2>/dev/null)
  echo "Project ID: $project_id" >&2
  cluster=$(_gke_select_cluster --project $project_id)
  IFS="/" read -ra TOKS <<< "${cluster}"
  LOCATION=${TOKS[-3]}
  CLUSTER_NAME=${TOKS[-1]}
  if [[ "${cluster}" =~ zones ]]; then
    gcloud --project ${project_id} container clusters get-credentials ${cluster} --zone ${LOCATION} ${gcloud_args}
  else
    export CLOUDSDK_CONTAINER_USE_V1_API_CLIENT=false
    gcloud --project ${project_id} beta container clusters get-credentials ${CLUSTER_NAME} --region ${LOCATION} ${gcloud_args}
  fi
}

gke-credentials $@

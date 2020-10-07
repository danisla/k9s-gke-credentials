# k9s-gke-credentials

K9s plugin to fetch gke cluster credentials.

## Install

1. Copy `k9s-gke-creds.sh` script to your PATH.
2. Copy/merge the `plugin.yml` file to ~/.k9s/plugin.yml.

## Usage

1. From the contexts view (`:ctx`) press `Ctrl-L` to run the script that will prompt you for your Google Cloud Project, or use the current one set, then prompt you for a numbered list of clusters.

> NOTE: after returning to k9s, the list of contexts may not be refreshed automatically.

2. To delete a cluster context, make sure `kubectx` is installed then select a context and press `Ctrl-D`.
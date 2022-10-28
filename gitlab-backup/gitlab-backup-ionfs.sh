#!/bin/bash

set -eou pipefail

## setup vars
date=$(date "+%Y%m%d-%H%M%S")
name="$date"_gitlab_backup.tar
data_path=/var/opt/gitlab/backups/
config_path=/etc/gitlab/
user=$(whoami)

## create backups
sudo gitlab-backup create BACKUP="$date" SKIP="artifacts"
sudo mv "$data_path/$name" /tmp/
sudo chown "$user:$user" /tmp/"$name"

sudo tar -cf "/tmp/$date"_gitlab_config.tar "$config_path"
sudo chown "$user:$user" "/tmp/$date"_gitlab_config.tar

## upload to IBC S6
ionfs put "/tmp/$name" ion://gitlab-backups/
ionfs put "/tmp/$date"_gitlab_config.tar ion://gitlab-backups/

## verify and delete local copies
ionfs ls ion://gitlab-backups/

rm -f "/tmp/$name"
rm -f "/tmp/$date"_gitlab_config.tar
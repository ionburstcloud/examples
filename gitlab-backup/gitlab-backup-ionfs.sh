#!/bin/bash

set -eou pipefail

## setup vars
date=$(date "+%Y%m%d-%H%M%S")
name="$date"_gitlab_backup.tar
data_path=/var/opt/gitlab/backups/
config_path=/etc/gitlab/

## create backups
gitlab-backup create BACKUP="$date"
tar -cvf "$data_path/$date"-config.tar "$config_path"

## upload to IBC S6
ionfs put "$data_path/$name" ion://
ionfs put "$data_path/$date"_gitlab_config.tar ion://


## verify and delete local copies
ionfs ls ion://

rm -f "$data_path/$name"
rm -f "$data_path/$date"_gitlab_config.tar
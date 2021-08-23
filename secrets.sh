#!/bin/bash
# NOTE: this is for demo only!
export DB_USR=doug
export DB_PWD=password
export DB_NAM=demo
export WP_ADM=admin
export WP_PWD=password
export WP_EML=admin@test.com
export WP_HIDE_LOGIN=not-the-usual-admin
export DNS=demo.local
# make this "https:" if demo server has SSL certificate for $DNS
export URL=http://$DNS
export WP_DIR=/srv
export WP_THEME=business
export WP_THEME_SRC=https://public-api.wordpress.com/rest/v1/themes/download/business.zip
export REPO_DIR=/repo
export REPO_BACKUP_DIR=/repo/backup
export CONTAINER=wp_demo
export CONTAINER_IP="172.18.33.33"
export CONTAINER_SUBNET="172.18.33.0\/16"
export CONTAINER_GATEWAY="172.18.33.1"

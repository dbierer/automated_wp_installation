#!/bin/bash
# NOTE: this is for demo only!
export DB_USR=demo
export DB_PWD=password
export DB_NAM=demo
export DB_HOST=localhost
export WP_ADM=admin
export WP_PWD=password
export WP_EML=admin@demo.com
# don't set this if you do not want wps-hide-login installed
export WP_HIDE_LOGIN=not-the-usual-admin
export DNS=demo.local
# make this "https:" if target server has SSL certificate for $DNS
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
# list of packages to install from 3 different sources
export INSTALL_WP_PLUGINS="woocommerce"
export INSTALL_WPACKAGIST="elex-bulk-edit-products-prices-attributes-for-woocommerce-basic,order-import-export-for-woocommerce,wordpress-seo,add-from-server,jetpack,w3-total-cache,imagify"
export INSTALL_PACKAGIST=""

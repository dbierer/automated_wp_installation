#!/bin/bash
# usage: install_wp.sh [USER]
. /tmp/secrets.sh

# bail out if already installed
if [[ -d $WP_DIR/bedrock ]]; then
    echo "WordPress already installed ..."
    exit 0
fi

cd $WP_DIR
export USR=$USER
if [[ ! -z "$1" ]]; then
    export USR=$1
fi

echo "Starting MySQL ..."
/etc/init.d/mysql start
sleep 3

echo "Setting up WordPress ..."
rm -f composer.phar
wget https://getcomposer.org/download/latest-stable/composer.phar
php composer.phar create-project roots/bedrock
mv -f composer.phar bedrock/composer.phar
cd bedrock
php composer.phar require wp-cli/wp-cli-bundle
echo "apache_modules:" >>wp-cli.yml
echo "  - mod_rewrite" >>wp-cli.yml
php composer.phar require aaemnnosttv/wp-cli-dotenv-command
rm -f .env
vendor/bin/wp --allow-root dotenv init
vendor/bin/wp --allow-root dotenv salts generate
vendor/bin/wp --allow-root dotenv set key value
vendor/bin/wp --allow-root dotenv set DB_NAME $DB_NAM
vendor/bin/wp --allow-root dotenv set DB_USER $DB_USR
vendor/bin/wp --allow-root dotenv set DB_PASSWORD $DB_PWD
vendor/bin/wp --allow-root dotenv set DB_HOST localhost
vendor/bin/wp --allow-root dotenv set WP_ENV production
vendor/bin/wp --allow-root dotenv set WP_HOME $URL
vendor/bin/wp --allow-root dotenv set WP_SITEURL $URL/wp
vendor/bin/wp --allow-root core install --url=$DNS --title="$DNS" --admin_user=$WP_ADM --admin_password=$WP_PWD --admin_email=$WP_EML

echo "Installing WP Plugins ... "
vendor/bin/wp --allow-root plugin install woocommerce --activate
php composer.phar require "wpackagist-plugin/elex-bulk-edit-products-prices-attributes-for-woocommerce-basic"
php composer.phar require "wpackagist-plugin/order-import-export-for-woocommerce"
php composer.phar require "wpackagist-plugin/wordpress-seo"
php composer.phar require "wpackagist-plugin/add-from-server"
php composer.phar require "wpackagist-plugin/jetpack"
php composer.phar require "wpackagist-plugin/w3-total-cache"
php composer.phar require "wpackagist-plugin/imagify"
php composer.phar require "wpackagist-plugin/wps-hide-login"

echo "Activating WP Plugins ... "
vendor/bin/wp --allow-root plugin activate elex-bulk-edit-products-prices-attributes-for-woocommerce-basic
vendor/bin/wp --allow-root plugin activate order-import-export-for-woocommerce
vendor/bin/wp --allow-root plugin activate wordpress-seo
vendor/bin/wp --allow-root plugin activate add-from-server
vendor/bin/wp --allow-root plugin activate jetpack
vendor/bin/wp --allow-root plugin activate w3-total-cache
vendor/bin/wp --allow-root plugin activate imagify
vendor/bin/wp --allow-root plugin activate wps-hide-login
vendor/bin/wp --allow-root option update whl_page "$WP_HIDE_LOGIN" --skip-plugins --skip-themes

echo "Installing theme ..."
wget --unlink -O /tmp/$WP_THEME.zip $WP_THEME_SRC
vendor/bin/wp --allow-root theme install /tmp/$WP_THEME.zip --activate

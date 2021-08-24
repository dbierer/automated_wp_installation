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

# setting up .env file
php composer.phar require aaemnnosttv/wp-cli-dotenv-command
rm -f .env
vendor/bin/wp --allow-root dotenv init
vendor/bin/wp --allow-root dotenv salts generate
vendor/bin/wp --allow-root dotenv set key value
vendor/bin/wp --allow-root dotenv set DB_NAME $DB_NAM
vendor/bin/wp --allow-root dotenv set DB_USER $DB_USR
vendor/bin/wp --allow-root dotenv set DB_PASSWORD $DB_PWD
vendor/bin/wp --allow-root dotenv set DB_HOST $DB_HOST
vendor/bin/wp --allow-root dotenv set WP_ENV production
vendor/bin/wp --allow-root dotenv set WP_HOME $URL
vendor/bin/wp --allow-root dotenv set WP_SITEURL $URL/wp
vendor/bin/wp --allow-root core install --url=$DNS --title="$DNS" --admin_user=$WP_ADM --admin_password=$WP_PWD --admin_email=$WP_EML

# installing plugins as defined in "secrets.sh"
if [[ "$INSTALL_WP_PLUGINS" != "" ]]; then
    echo "Installing WP Plugins ... "
    echo $INSTALL_WP_PLUGINS | tr "," "\n" | while read LINE
    do
      vendor/bin/wp --allow-root plugin install $LINE --activate
    done
fi

if [[ "$INSTALL_WPACKAGIST" != "" ]]; then
    echo "Installing wpackagist Plugins ... "
    echo $INSTALL_WPACKAGIST | tr "," "\n" | while read LINE
    do
      php composer.phar require wpackagist-plugin/$LINE
    done
fi

if [[ "$INSTALL_PACKAGIST" != "" ]]; then
    echo "Installing packagist Plugins ... "
    echo $INSTALL_PACKAGIST | tr "," "\n" | while read LINE
    do
      php composer.phar require $LINE
    done
fi

if [[ "$INSTALL_WPACKAGIST" != "" ]]; then
    echo "Activating wpackagist Plugins ... "
    echo $INSTALL_WPACKAGIST | tr "," "\n" | while read LINE
    do
      vendor/bin/wp --allow-root plugin activate $LINE
    done
fi

if [[ "$INSTALL_PACKAGIST" != "" ]]; then
    echo "Activating packagist Plugins ... "
    echo $INSTALL_PACKAGIST | tr "," "\n" | while read LINE
    do
      vendor/bin/wp --allow-root plugin activate $LINE
    done
fi

# installing wps-hide-login
if [[ "$WP_HIDE_LOGIN" != "" ]]; then
    echo "Installing and enabling wps-hide-login ..."
    php composer.phar require "wpackagist-plugin/wps-hide-login"
    vendor/bin/wp --allow-root plugin activate wps-hide-login
    vendor/bin/wp --allow-root option update whl_page "$WP_HIDE_LOGIN" --skip-plugins --skip-themes
fi

echo "Installing theme ..."
wget --unlink -O /tmp/$WP_THEME.zip $WP_THEME_SRC
vendor/bin/wp --allow-root theme install /tmp/$WP_THEME.zip --activate

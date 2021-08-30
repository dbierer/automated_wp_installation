#!/bin/bash
# usage: install_wp.sh [USER]
. ./secrets.sh

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

echo "Make sure MySQL is accessible and that the database has been created ..."
echo "Updating Composer ..."
if [[ -f ./composer.phar ]]; then
    php composer.phar self-update
else
    rm -f composer.phar
    wget https://getcomposer.org/download/latest-stable/composer.phar
fi

echo "Setting up WordPress ..."
php composer.phar create-project roots/bedrock
mv -f composer.phar bedrock/composer.phar
cd bedrock
php composer.phar require wp-cli/wp-cli-bundle
echo "apache_modules:" >>wp-cli.yml
echo "  - mod_rewrite" >>wp-cli.yml

# setting up .env file
php composer.phar require aaemnnosttv/wp-cli-dotenv-command
rm -f .env
vendor/bin/wp dotenv init
vendor/bin/wp dotenv salts generate
vendor/bin/wp dotenv set key value
vendor/bin/wp dotenv set DB_NAME $DB_NAM
vendor/bin/wp dotenv set DB_USER $DB_USR
vendor/bin/wp dotenv set DB_PASSWORD $DB_PWD
vendor/bin/wp dotenv set DB_HOST $DB_HOST
vendor/bin/wp dotenv set WP_ENV production
vendor/bin/wp dotenv set WP_HOME $URL
vendor/bin/wp dotenv set WP_SITEURL $URL/wp
vendor/bin/wp core install --url=$DNS --title="$DNS" --admin_user=$WP_ADM --admin_password=$WP_PWD --admin_email=$WP_EML

# installing plugins as defined in "secrets.sh"
if [[ "$INSTALL_WP_PLUGINS" != "" ]]; then
    echo "Installing WP Plugins ... "
    echo $INSTALL_WP_PLUGINS | tr "," "\n" | while read LINE
    do
      vendor/bin/wp plugin install $LINE --activate
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
      vendor/bin/wp plugin activate $LINE
    done
fi

if [[ "$INSTALL_PACKAGIST" != "" ]]; then
    echo "Activating packagist Plugins ... "
    echo $INSTALL_PACKAGIST | tr "," "\n" | while read LINE
    do
      vendor/bin/wp plugin activate $LINE
    done
fi

# installing wps-hide-login
if [[ "$WP_HIDE_LOGIN" != "" ]]; then
    echo "Installing and enabling wps-hide-login ..."
    php composer.phar require "wpackagist-plugin/wps-hide-login"
    vendor/bin/wp plugin activate wps-hide-login
    vendor/bin/wp option update whl_page "$WP_HIDE_LOGIN" --skip-plugins --skip-themes
fi

echo "Installing theme ..."
if [[ ! -f $WP_THEME_ZIP ]]; then
    wget -O $WP_THEME_ZIP $WP_THEME_SRC
fi
vendor/bin/wp theme install $WP_THEME_ZIP --activate

echo "Set associated domain to 'bedrock/web' ..."

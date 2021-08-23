#!/bin/bash
. /tmp/secrets.sh

echo "Copying assets ..."
if [[ -d $WP_DIR/bedrock/web/img ]]; then
    mkdir -p $WP_DIR/bedrock/web/img
    cp -r $REPO_DIR/bedrock/web/img/* $WP_DIR/bedrock/web/img
fi

echo "Restoring database ..."
/etc/init.d/mysql start
if [[ -f $REPO_BACKUP_DIR/$DB_NAM.sql ]]; then
    mysql -uroot -e "SOURCE $REPO_BACKUP_DIR/$DB_NAM.sql;" $DB_NAM
else
    if [[ ! -d $REPO_BACKUP_DIR ]]; then
        mkdir -p $REPO_BACKUP_DIR
    fi
fi

echo "Starting other services ..."
/etc/init.d/phpfpm start
/etc/init.d/mysql start
lfphp --mysql --phpfpm --apache >/dev/null 2&>1

#!/bin/bash
. /tmp/secrets.sh
echo "Restoring WP installation ..."
if [[ -f $REPO_BACKUP_DIR/bedrock.zip ]]; then
    cd $WP_DIR/bedrock
    unzip -o -v $REPO_BACKUP_DIR/bedrock.zip
fi
echo "Restoring database ..."
if [[ -f $REPO_BACKUP_DIR/$DB_NAM.sql ]]; then
    mysql -uroot -e 'SOURCE $REPO_BACKUP_DIR/$DB_NAM.sql;' $DB_NAM
fi

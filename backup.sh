#!/bin/bash
. /tmp/secrets.sh
echo "Backing up database ..."
mysqldump -uroot $DB_NAM > $REPO_BACKUP_DIR/$DB_NAM.sql
cp $REPO_BACKUP_DIR/$DB_NAM.sql $REPO_BACKUP_DIR/"$DB_NAM"_`date +%Y-%m-%d`.sql
echo "Backing up WP installation ..."
cd $WP_DIR/bedrock
zip -r -u $REPO_BACKUP_DIR/bedrock.zip *

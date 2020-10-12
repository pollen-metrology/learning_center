#!/bin/bash
BACKUP_ROOT=/home/docker/learning_center
BACKUP_MOODLE_PATH=./data/moodle
BACKUP_MARIADB_PATH=./data/mariadb
BACKUP_DATE=$(date +%Y-%m-%d-%H.%M.%S)
BACKUP_NAME=backup_$(date +%Y-%m-%d-%H.%M.%S).zip
BACKUP_SQL=sql_${BACKUP_DATE}.sql;
BACKUP_FILE=./backup/backups/${BACKUP_NAME}
BACKUP_DEST=${BACKUP_ROOT}/backup/backups


#tar -czvf ${BACKUP_NAME} docker exec -it learningcenter_mariadb_1 mysqldump -h mariadb -u bn_moodle --password= bitnami_moodle
#docker exec -it learningcenter_mariadb_1 mysqldump -h mariadb -u bn_moodle --password= bitnami_moodle > ./backup/backup_$(date +%Y-%m-%d-%H.%M.%S).sql
#docker exec -it learningcenter_mariadb_1 mysqldump -h mariadb -u bn_moodle --password= bitnami_moodle > ./backup/${BACKUP_NAME}/sql.sql
#docker exec -it learningcenter_mariadb_1 mysqldump -h mariadb -u bn_moodle --password= bitnami_moodle | gzip -c > ./backup/${BACKUP_NAME}
#tar -cvjf ./backup/${BACKUP_NAME} ${BACKUP_SQL}

# Go to the root path (for cron)
cd ${BACKUP_ROOT}

# Backup SQL
#docker exec -it learningcenter_mariadb_1 mysqldump -h mariadb -u bn_moodle --password= bitnami_moodle > ${BACKUP_SQL}
docker exec -it learningcenter_mariadb_1 mysqldump -u root --password=pgfd63hxfdpg024iGms0 pollen_learning_center_moodle > ${BACKUP_SQL} 
zip -r ${BACKUP_FILE} ${BACKUP_SQL}
rm ${BACKUP_SQL}

# Backup DATA
zip -r -q ${BACKUP_FILE} ${BACKUP_MOODLE_PATH}
zip -r -q ${BACKUP_FILE} ${BACKUP_MARIADB_PATH}

# BACKUP DIVERS
zip -r ${BACKUP_FILE} ${BACKUP_ROOT}/backup/script_backup.sh 
zip -r ${BACKUP_FILE} ${BACKUP_ROOT}/backup/purge_backup.sh
zip -r ${BACKUP_FILE} ${BACKUP_ROOT}/docker-compose.yml
zip -r ${BACKUP_FILE} ${BACKUP_ROOT}/jenkins_slave/*

# BACKUP APACHE CONFIG
zip -r ${BACKUP_FILE} /etc/apache2/sites-available/01-learningcenter.conf
zip -r ${BACKUP_FILE} /etc/apache2/sites-available/01-learningcenter-le-ssl.conf
# BACKUP LETSENCRYPT CONFIG
zip -r ${BACKUP_FILE} /etc/letsencrypt/live/learningcenter.pollen-metrology.com/*

# Get exists backup before purge
#ssh sshd@5.182.252.230 -p 10122 -i nas-backup-key
rsync -av -e 'ssh -p 10122 -i nas-backup-key' sshd@nas-backup-01.pollen-metrology.com:/shares/pollenbackup/Docker/learning-center/backups/ ${BACKUP_DEST}

# ROTATION
echo "purge older backup"
${BACKUP_ROOT}/backup/./purge_backup.sh
#./purge_backup.sh

# OFF-SITE SYNCHRO
rsync -r --delete -av -e 'ssh -p 10122 -i nas-backup-key' ${BACKUP_DEST} sshd@nas-backup-01.pollen-metrology.com:/shares/pollenbackup/Docker/learning-center/

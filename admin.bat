@echo off
SET USAGE="Usage: init.sh up|down|build|ls|init|shell [--no-backup]"
SET CONTAINER="php_cert"
SET INIT=0
CALL secrets.cmd

IF "%~1"=="" GOTO :done

IF "%1"=="up" GOTO :up
IF "%1"=="start" GOTO :up
GOTO :opt2
:up
copy docker-compose.yml.dist docker-compose.yml
get-content docker-compose.yml | %{$_ -replace "=DNS=","%DNS%"}
get-content docker-compose.yml | %{$_ -replace "=CONTAINER=","%CONTAINER%"}
get-content docker-compose.yml | %{$_ -replace "=CONTAINER_IP=","%CONTAINER_IP%"}
get-content docker-compose.yml | %{$_ -replace "=CONTAINER_SUBNET=","%CONTAINER_SUBNET%"}
get-content docker-compose.yml | %{$_ -replace "=CONTAINER_SUBNET=","%CONTAINER_SUBNET%"}
docker-compose up -d %2
IF "%~2%" == "--no-backup" GOTO:EOF
docker exec %CONTAINER% /bin/bash -c "/tmp/restore.sh"
GOTO:EOF

:opt2
IF "%1" =="down" GOTO :down
IF "%1"=="stop" GOTO :down
GOTO :opt3
:down
IF "%~2%" == "--no-backup" GOTO :do_down
docker exec %CONTAINER% /bin/bash -c "/tmp/backup.sh"

:do_down
docker-compose down
takeown /R /F *
del 1
GOTO:EOF

:opt3
IF "%1"=="build" GOTO :build
GOTO :opt4
:build
copy docker-compose.yml.dist docker-compose.yml
get-content docker-compose.yml | %{$_ -replace "=DNS=","%DNS%"}
get-content docker-compose.yml | %{$_ -replace "=CONTAINER=","%CONTAINER%"}
get-content docker-compose.yml | %{$_ -replace "=CONTAINER_IP=","%CONTAINER_IP%"}
get-content docker-compose.yml | %{$_ -replace "=CONTAINER_SUBNET=","%CONTAINER_SUBNET%"}
get-content docker-compose.yml | %{$_ -replace "=CONTAINER_SUBNET=","%CONTAINER_SUBNET%"}
docker-compose build %2
GOTO:EOF

:opt4
IF "%1"=="ls" GOTO :ls
GOTO :opt5
:ls
docker container ls
GOTO:EOF

:opt5
IF "%1"=="init" GOTO :init
GOTO :opt6
:init
docker exec %CONTAINER% /bin/bash -c "/etc/init.d/mysql restart"
docker exec %CONTAINER% /bin/bash -c "/etc/init.d/php-fpm restart"
docker exec %CONTAINER% /bin/bash -c "/etc/init.d/httpd restart"
GOTO:EOF

:opt6
IF "%1"=="shell" GOTO :shell
GOTO :done
:shell
IF "%2"=="" GOTO :usage
IF "%2"=="7" (docker exec -it %CONTAINER7% /bin/bash) ELSE (docker exec -it %CONTAINER8% /bin/bash)
GOTO:EOF

:done
echo "Done"
echo %USAGE%
echo "You entered %1 and %1"
GOTO:EOF

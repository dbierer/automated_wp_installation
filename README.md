# WP Automation

Creates a base WP installation in a Docker container.

## Before Container Build
If you're running Docker on Linux or Mac:
    * Set entries to all settings in `example.secrets.dist` and rename to `secrets.sh`
If you're running Docker on Windows:
    * Set entries to all settings in `example.secrets.cmd.dist` and rename to `secrets.cmd`

## Setting up the Demo
To run the demo using the existing demo "secrets", proceed as follows:
1. Install Docker
    * If you are running Windows, start here: [https://docs.docker.com/docker-for-windows/install/](https://docs.docker.com/docker-for-windows/install/).
    * If you are on a Mac, start here: [https://docs.docker.com/docker-for-mac/install/](https://docs.docker.com/docker-for-mac/install/).
    * If you are on Linux, have a look here: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/).
2. Install Docker Compose.  For all operating systems, start here: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/).
3. Clone this repository
    * If you have installed git, use the following command:
```
git clone https://github.com/dbierer/automated_wp_installation.git /path/to/repo
```
    * Otherwise, you can simply download and unzip from this URL: [https://github.com/dbierer/automated_wp_installation/archive/main.zip](https://github.com/dbierer/automated_wp_installation/archive/main.zip)
    * And then unzip into a folder you create which we refer to as `/path/to/repo` in this guide

## Running the Demo in Windows
Assign the IP address `172.18.33.33` to `demo.local`

To successfully run the demo, open the Windows _Power Shell_ and proceed as follows:
```
cd C:\path\to\repo
admin build
admin up
```
NOTES:
* you only need to run `admin build` the first time only
* will not work in a regular command prompt: the batch file commands require the _Power Shell_

To stop the demo container (and backup), proceed as follows:
```
cd C:\path\to\repo
admin down
```
NOTES:
* the `takeown` command runs to reset local user permissions.


## Running the Demo in Linx or Mac
Assign the IP address `172.18.33.33` to `demo.local`
```
echo "172.18.33.33  demo.local" >>/etc/hosts
```

To successfully run the demo, open a terminal window and proceed as follows:
```
cd /path/to/repo
./admin.sh build
./admin up
```
NOTE: you only need to run `admin build` the first time only

To stop the demo container (and backup), proceed as follows:
```
cd /path/to/repo
./admin.sh down
```
NOTE: the `chown` command runs to reset local user permissions.


## To access the WordPress site
From a browser on your host computer (outside the Docker container):
```
http://demo.local
```

To login as admin use the value you set in the "secrets" file for `WP_HIDE_LOGIN`:
```
http://demo.local/?not-the-usual-admin
```

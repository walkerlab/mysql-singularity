# MYSQL Server Singularity Container

A mysql:8.0.28 docker image package to be ran on singularity containerization solution.

<br/>

# Initialization

## Building or Downloading the image (mysql.sif)

To start, build the singularity image with the command below which will store it as mysql.sif:

    sudo singularity build mysql.sif mysql.def

or 

    singularity pull --arch amd64 library://synicix/walkerlab/mysql.sif:latest
<br/>

## Starting Singularity Container for the First Time
<br/>

First we need to create the apporiate folders to store the /var/lib/mysql data directory and the /var/lib/run directory. Simply run these these commands under the folder where you want to stored them:

    mkdir -p ./var/lib/mysql
    mkdir -p ./var/run/mysqld

Note that there is also a default my.cnf that is provided in this repo. You can modify it to your liking and it will be bind into the container in the appropriate location

Start the server with the correct files binding via:

    singularity instance start --bind <path_to_var_lib_mysql>:/var/lib/mysql/ --bind <path_to_var_run_mysqld>:/var/run/mysqld/ --bind <path_to_my.cnf>:/etc/mysql/my.cnf mysql.sif mysql

Logging in root requires to you extract the password that was generated for you during the initial start up:

    cat ~/.singularity/instances/logs/<host_name>/<username>/mysql.err | grep "A temporary password is generated for root@localhost"

Then shell into the running instance with:

    singularity shell instance://mysql

Login with root:

    mysql -u root -p

Change the root password for localhost

    ALTER USER 'root'@'localhost' IDENTIFIED BY '<root_password_here>';

Create root user with remote access (Optional)

    CREATE USER 'root'@'%' IDENTIFIED BY '<root_password_here>'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

# Shutdown
Simply run:
    
    singularity instance stop mysql

# Normal Startup
To start normally after the first time setup has been done simply run 

    singularity instance start --bind <path_to_var_lib_mysql>:/var/lib/mysql/ --bind <path_to_var_run_mysqld>:/var/run/mysqld/ --bind <path_to_my.cnf>:/etc/mysql/my.cnf mysql.sif mysql

# SLURM Deployement (HYAK)
There is a script for scheduling it on the HYAK cluster via direct run or cronjob (Highly Recommneded)

The script will find if the server is already deployed, if it is the script will exist, if not it will deploy it for 14 days (This can be changed later.)

## Cron Job
Add a new cron job via:

    crontab -e

You can set it for every 5 minutes like with output redirection:

    */5 * * * * cd <directory_of_repository> && ./mysql_deployment.sh > <file_to_output_redirection_path>

## Running it directly
Simply use sbatch command to deploy it for 2 weeks:

    sbatch --account=walkerlab --partition=gpu-a40 --time=14-0:00 mysql_slurm_deployment.slurm

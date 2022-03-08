#!/bin/bash
#SBATCH --job-name=mysql_server
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --partition=gpu-a40

module load singularity
singularity run --bind /gscratch/walkerlab/mysql/var/lib/mysql:/var/lib/mysql/ --bind /gscratch/walkerlab/mysql/var/run/mysqld:/var/run/mysqld/ --bind /gscratch/walkerlab/mysql/my.cnf:/etc/mysql/my.cnf library://synicix/walkerlab/mysql.sif:latest

#!/bin/bash
echo $(whoami)
expected_job_name="mysql_server"
jobs_name=$(squeue -u sitonic -h --format %j)

# Find mysql_server_job
for job_name in $jobs_name; do
  if [ "$job_name" == "$expected_job_name" ]; then
    echo "MYSQL Server is deployed, exiting"
    exit
  fi
done

# Failed to find job thus redeploy
echo "Failed to find MYSQL server deployment, redeploying..."
sbatch --account=walkerlab --partition=gpu-a40 --time=14-0:00 mysql_slurm_deployment.slurm


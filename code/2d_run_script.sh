#!/bin/bash
#SBATCH -N 4
#SBATCH --array=1-2
#SBATCH --time=12:00:00
#SBATCH --mem-per-cpu=10GB
#SBATCH --job-name=mcmc
#SBATCH --error=sbatch-out/%x_%A_%a.err
#SBATCH --output=sbatch-out/%x_%A_%a.out

# This is an SBATCH script designed to run on a cluster using the Slurm 
# workload manager system.

# The SBATCH arguments above are specifying that I want to run my jobs with 
# 2 cores each for 12 hours and I use the array argument to run my analyses 
# for each of periods 2 and 3.

# This script should be called using sbatch on the cluster.
# 
#     sbatch 2d_run_script.sh
#
module load R_core/4.0.2-fasrc01
srun Rscript 2c_fit_stan_car_spatial_poisson_model_cluster.R ${SLURM_ARRAY_TASK_ID}

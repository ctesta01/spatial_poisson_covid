#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --array=1-2
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --mem-per-cpu=10GB
#SBATCH --job-name=plotting
#SBATCH --error=../sbatch-out/%x_%A_%a.err
#SBATCH --output=../sbatch-out/%x_%A_%a.out

# This is an SBATCH script designed to run on a cluster using the Slurm 
# workload manager system.

# This script should be called using sbatch on the cluster.
# 
#     sbatch 3e_run_3b.sh
#
module load R_core/4.0.2-fasrc01
module load gcc/9.3.0-fasrc01
srun Rscript 3b_plot_spatial_car_model_beta_fits.R ${SLURM_ARRAY_TASK_ID}

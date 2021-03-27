
# dependencies
library(here)
source(here("code/2a_dependencies.R"))

# define the period from arguments supplied to Rscript when running this file --
# period has 1 added to it so that running periods 2 & 3 is easy to do on the cluster.
# run this file from terminal as 
# 
#      Rscript 2c_fit_stan_car_spatial_poisson_model_cluster.R 1
#      Rscript 2c_fit_stan_car_spatial_poisson_model_cluster.R 2 
# 
# the command-line arguments are used in 2d_run_script.sh
period <- commandArgs(trailingOnly=T)[[1]] + 1

# compile stan model 
model <- cmdstanr::cmdstan_model(stan_file = here('code/2b_model_sparse_car.stan'))

# load intermediate data 
model_data <- readRDS(here(str_c('data/cluster_ready_data/model_data_period_', period, '.rds')))

# optimize the model
optim_fit <- model$optimize(
  data = model_data,
  seed = 100)

# format optims for starting MCMC chains
optim_fit_outcome <- 
  setNames(optim_fit$summary() %>% pull(estimate),
           optim_fit$summary() %>% pull(variable)) %>% 
  as.list()

# fit stan model
sample_fit <- model$sample(
  data = model_data,
  seed = 123,
  chains = 4,
  parallel_chains = 4,
  iter_warmup = 1500,
  iter_sampling = 32000,
  init = list(optim_fit_outcome, optim_fit_outcome, optim_fit_outcome, optim_fit_outcome)
  )

# save the stan model
sample_fit$save_output_files(
  dir = here("models/"),
  basename = paste0('stan_fit_period', period, '_most_covariates'))


# dependencies
library(here)
source(here("code/dependencies.R"))

# load covid data and covariates
source(here("code/load_and_merge_data.R"))

# load regression formulas (used in prepare_data_for_carbayes.R)
source(here("code/regression_formulas.R"))

# prepare data as if for carbayes
source(here("code/prepare_data_for_spatial_modeling.R"))

# define variables of interest
source(here("code/variables_of_interest.R"))

# compile stan model 
model <- cmdstanr::cmdstan_model(stan_file = here('code/model_sparse_car.stan'))

# run models for each time period
# for (period in 2:3) {
period <- 2
  
  # retrieve variables of interest
  variables_of_interest_period <- variables_of_interest[[period]]
  
  # create the data frame df_spatial_period which has the counties, their
  # covariates, and deaths for the seeded counties with neighbors
  c(df_spatial_period, W) %<-% create_spatial_df_and_W(df_spatial, 
      c(paste0('deaths_', period), variables_of_interest_period))
    
  # calculating variables for stan model
  N <- nrow(df_spatial_period)
  y <- df_spatial_period[[paste0('deaths_', period)]]
  E <- df_spatial_period$population
  X <- df_spatial_period[,variables_of_interest_period] %>% 
    st_drop_geometry() %>% 
    as.matrix() # covariates matrix
  p <- ncol(X)
  
  # format stan model data as list
  model_data <- list(
    n = N, 
    p = p,
    X = X,
    y = y, 
    log_offset = log(E),
    W = W,
    W_n = sum(W)/2)
  
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
    iter_sampling = 8000,
    init = list(optim_fit_outcome, optim_fit_outcome, optim_fit_outcome, optim_fit_outcome)
    )
  
  # save the stan model
  sample_fit$save_output_files(
    dir = here("models/"),
    basename = paste0('stan_fit_period', period, '_selected_covariates'))
# }


# use shinystan to inspect the stan model --- 
#    check the Rhat coefficients & other diagnostics for convergence! 

# library(shinystan)
# stanfit <- rstan::read_stan_csv(sample_fit$output_files())
# shinystan::launch_shinystan(stanfit)


# Notes -------------------------------------------------------------------


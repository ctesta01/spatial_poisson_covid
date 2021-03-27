
#####################################################
# save intermediate data, ready for mcmc on cluster # 
#####################################################


# dependencies
library(here)
source(here("code/1a_dependencies.R"))

# load covid data and covariates
source(here("code/1b_load_and_merge_data.R"))

# load regression formulas (used in prepare_data_for_carbayes.R)
source(here("code/1c_regression_formulas.R"))

# prepare data as if for carbayes
source(here("code/1d_prepare_data_for_spatial_modeling.R"))

# ensure that the variables are valid
stopifnot(length(setdiff(variables_of_interest[[2]], colnames(df_spatial))) == 0)
stopifnot(length(setdiff(variables_of_interest[[3]], colnames(df_spatial))) == 0)

# define the periods considered
# this is since we're not running the spatial model for period 1
periods <- 2:3

# specify the period
for (period in periods) {
  
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
  
  # save intermediate data
  saveRDS(model_data, here(
    str_c("data/cluster_ready_data/model_data_period_", period, ".rds")))
}
# library(rstan)
library(cmdstanr)

# dependencies
library(here)
source(here("code/dependencies.R"))

# load covid data and covariates
source(here("code/load_and_merge_data.R"))

# load regression formulas (used in prepare_data_for_carbayes.R)
source(here("code/regression_formulas.R"))

# prepare data as if for carbayes
source(here("code/prepare_data_for_carbayes.R"))

# convert the neighbor matrix W to a data frame of pairs and 
# an indicator column (0s and 1s) for whether an edge is present.
W_pairs <- W %>% as.table() %>% as.data.frame() 

# confirming that the vertices (counties) in the pairs dataframe have the same number of 
# unique entries as are present in the df_spatial data
stopifnot(length(unique(W_pairs$Var1)) == nrow(df_spatial))
stopifnot(length(unique(W_pairs$Var2)) == nrow(df_spatial))

# check that W_pairs$Freq has only 0s and 1s
stopifnot(all(W_pairs$Freq %in% c(0,1)))

# filter for actual pairs 
W_pairs %<>% filter(Freq == 1)

# convert factor levels to integers
W_pairs %<>% mutate_if(is.factor, as.integer)

# prepare data for stan
node1 <- W_pairs$Var1
node2 <- W_pairs$Var2
N_edges <- length(node1)
stopifnot(N_edges == length(node2))
N <- nrow(df_spatial)
y <- df_spatial$deaths_1
E <- df_spatial$population

# format as list
model_data <- list(
  N = N, 
  N_edges = N_edges,
  node1 = node1, 
  node2 = node2,
  y = y, 
  E = E,
  x1 = df_spatial$scaled_per_nursing_p1)

# run stan 

# fit <- stan(
#   file = here('code/model_icar.stan'),
#   data = model_data,
#   chains = 4,
#   warmup = 100,
#   iter = 200,
#   cores = 4
#   )

model <- cmdstanr::cmdstan_model(stan_file = here('code/model_icar.stan'))

# optim_fit <- model$optimize(
#   data = model_data,
#   seed = 123)
# 
#> Warning: Fitting finished unexpectedly!

sample_fit <- model$sample(
  data = model_data,
  seed = 123,
  chains = 2,
  parallel_chains = 2,
  iter_warmup = 100,
  iter_sampling = 200)

library(shinystan)
shinystan::launch_shinystan(sample_fit)

saveRDS(fit, here("models/stan_fit_period1_one_covariate.rds"))

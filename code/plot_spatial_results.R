
########################
# Plot Spatial Results # 
########################

library(rstan)
library(here)
library(magrittr)
library(tidyverse)
library(zeallot)
library(ggplot2)


period3_model_rstan <- rstan::read_stan_csv( 
  csvfiles = list.files(
    path = here("models/"),
    pattern = "stan_fit_period3_selected_covariates-202103110752.*",
    full.names = TRUE))

spatial_terms <- rstan::summary(period3_model_rstan, pars = paste0('phi[', 1:2681, ']'))$summary

alpha <- rstan::summary(period3_model_rstan, pars = 'alpha')$summary %>% 
  as.data.frame()

spatial_terms %<>% as.data.frame() %>% 
  tibble::rownames_to_column('variable') %>% 
  dplyr::select(variable, mean)

# dependencies
source(here("code/dependencies.R"))

# load covid data and covariates
source(here("code/load_and_merge_data.R"))

# load regression formulas (used in prepare_data_for_carbayes.R)
source(here("code/regression_formulas.R"))

# prepare data as if for carbayes
source(here("code/prepare_data_for_carbayes.R"))

# define variables of interest
source(here("code/variables_of_interest.R"))

c(df_spatial_p3, W) %<-% create_spatial_df_and_W(
  df_spatial, variables_of_interest = c('deaths_3', variables_of_interest[[3]]))

df_spatial_p3$spatial_est <- spatial_terms$mean + alpha[[1]]

df_spatial_p3 %<>% mutate(
  spatial_est_exp = exp(spatial_est))

ggplot(df_spatial_p3, aes(fill = spatial_est_exp * 1e5)) + 
  geom_sf(color = 'white', size = 0.05) +
  scale_fill_viridis_c(option = "B", end = 0.9) + # , breaks = c(0, 50, 125, 200)) + 
  labs(fill = "Spatial Component of\nExpected Death Rates") + 
  ggtitle("Spatially Autocorrelated Model Estimates of Death Rates per 100,000") + 
  theme(legend.position = 'bottom')

ggsave(here("figures/spatial_terms_p3.png"),
       width = 10, height = 7)
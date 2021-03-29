
########################
# Plot Spatial Results # 
########################

# dependencies
library(here)
source(here("code/3a_dependencies.R"))

# define variables of interest
source(here("code/1c_regression_formulas.R"))

# specify the period by an argument given when calling Rscript
# on this file. run this as: 
# 
#     Rscript 3c_plot_spatially_autocorrelated_model_component.R 1
#     Rscript 3c_plot_spatially_autocorrelated_model_component.R 2
# 
period <- as.integer(commandArgs(trailingOnly=T)[[1]]) + 1

# load intermediate data 
model_data <- readRDS(here(str_c('data/cluster_ready_data/model_data_period_', period, '.rds')))

# load model results
if (period == 2) {
  model_rstan <- rstan::read_stan_csv( 
    csvfiles = list.files(
      path = here("models/"),
      pattern = "",
      full.names = TRUE))
} else if (period == 3) {
  model_rstan <- rstan::read_stan_csv( 
    csvfiles = list.files(
      path = here("models/"),
      pattern = "stan_fit_period3_most_covariates-202103281248*",
      full.names = TRUE))
}

# extract the spatial terms, encoded in the phi[] vector which has length = the
# number of counties considered.
n_counties <- model_data$n
spatial_terms <- rstan::summary(model_rstan, pars = paste0('phi[', 1:n_counties, ']'))$summary

# extract the alpha coefficient, the poisson model intercept term, summary results
alpha <- rstan::summary(model_rstan, pars = 'alpha')$summary %>% 
  as.data.frame()

# move the variable names into their own column, keep variable names & means
spatial_terms %<>% as.data.frame() %>% 
  tibble::rownames_to_column('variable') %>% 
  dplyr::select(variable, mean)

# create df_spatial so we can match the spatial model estimates with their 
# counties.
source(here("code/1d_prepare_data_for_spatial_modeling.R"))
c(df_spatial_filtered, W) %<-% create_spatial_df_and_W(
  df_spatial, variables_of_interest = c(paste0('deaths_', period), variables_of_interest[[period]]))

# exp(phi[] + alpha) is the expected death rate per population conditioning 
# out the effects from covariates. spatial_terms$mean is phi[] and alpha[[1]]
# is the mean of the alpha estimates from the posterior samples.
df_spatial_filtered$spatial_est <- exp(spatial_terms$mean + alpha[[1]])

# plot the spatial results -- we're looking to see that where there are
# hot-spots they're surrounded by warm areas and vice versa, to ensure that the
# regularization (imposed by the Besag-York-Mollié prior) is working properly.

ggplot(df_spatial_filtered, aes(fill = spatial_est * 1e5)) + 
  geom_sf(color = 'white', size = 0.05) +
  scale_fill_viridis_c(option = "B", end = 0.9, 
                       trans = scales::pseudo_log_trans(sigma = 50),
                       breaks = c(0, 75, 250, 1000),
                       limits = c(0, max(df_spatial_filtered$spatial_est*1e5))) + # , breaks = c(0, 50, 125, 200)) + 
  labs(fill = "Spatial Component of\nExpected Deaths per 100,000") + 
  ggtitle(paste0("Spatially Autocorrelated Model Estimates of Expected Deaths per 100,000 in Period ", period)) + 
  theme(legend.position = 'bottom')

# save the spatial results plot
ggsave(here(paste0("figures/spatial_terms_p", period, ".png")),
       width = 10, height = 7)


########################
# Plot Spatial Results # 
########################

# dependencies
library(here)
source(here("code/dependencies.R"))

library(ggridges)

# load covid data and covariates
source(here("code/load_and_merge_data.R"))

# load regression formulas (used in prepare_data_for_carbayes.R)
source(here("code/regression_formulas.R"))

# prepare data as if for carbayes
source(here("code/prepare_data_for_spatial_modeling.R"))

# define variables of interest
source(here("code/variables_of_interest.R"))

for (period in 2:3) {

# load model results
  if (period == 2) {
    model_rstan <- rstan::read_stan_csv( 
      csvfiles = list.files(
        path = here("models/"),
        pattern = "stan_fit_period2_selected_covariates-202103151313*",
        full.names = TRUE))
  } else if (period == 3) {
    model_rstan <- rstan::read_stan_csv( 
      csvfiles = list.files(
        path = here("models/"),
        pattern = "stan_fit_period3_selected_covariates-202103132258*",
        full.names = TRUE))
  }

  # extract the spatial terms, encoded in the phi[] vector which has length = the
  # number of counties considered.
  spatial_terms <- rstan::summary(model_rstan, pars = paste0('phi[', 1:2681, ']'))$summary
  
  # extract the alpha coefficient, the poisson model intercept term, summary results
  alpha <- rstan::summary(model_rstan, pars = 'alpha')$summary %>% 
    as.data.frame()
  
  # move the variable names into their own column, keep variable names & means
  spatial_terms %<>% as.data.frame() %>% 
    tibble::rownames_to_column('variable') %>% 
    dplyr::select(variable, mean)
  
  # create df_spatial so we can match the spatial model estimates with their 
  # counties.
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
  
  # ggplot(df_spatial_filtered, aes(x = spatial_est * 1e5)) + 
  #   geom_histogram()
  # 
  # ggplot(df_spatial_filtered, aes(x = spatial_est * 1e5)) + 
  #   geom_boxplot()
  # 
  # quantile(df_spatial_filtered$spatial_est * 1e5, c(0.25, 0.75))
  
}
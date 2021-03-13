
###############################
# Plot Stan CAR Model Results #
###############################

library(here)
library(rstan)
library(magrittr)
library(bayesplot)


# define variables of interest
source(here("code/variables_of_interest.R"))

# retrieve fit models
# period1_model <- readRDS(here("models/stan_fit_period1_selected_covariates.rds"))
# period2_model <- readRDS(here("models/stan_fit_period2_selected_covariates.rds"))
# period3_model <- readRDS(here("models/stan_fit_period3_selected_covariates.rds"))

# period3_model <- cmdstanr::read_cmdstan_csv(
#   files = list.files(
#     path = here("models/"),
#     pattern = "stan_fit_period3_selected_covariates-202103110752.*",
#     full.names = TRUE))

period3_model_rstan <- rstan::read_stan_csv( 
  csvfiles = list.files(
    path = here("models/"),
    pattern = "stan_fit_period3_selected_covariates-202103110752.*",
    full.names = TRUE))

# extract period 3 posterior as matrix
posterior_p3 <- as.matrix(period3_model_rstan)

# rename with nice names
colnames(posterior_p3)[1:4] <- 
  c("Political Lean", "Median Income", "Crowding", "Nursing Homes")

# density plots for non-spatial 
mcmc_areas(posterior_p3,
           pars = colnames(posterior_p3)[1:4],
           prob = 0.80) + 
  ggtitle("Posterior distributions for non-spatial terms",
          "With medians and 80% intervals, period 3")

ggsave(here("figures/stan_car_poisson_period_3.png"),
       width = 10, height = 7)


# Traceplots 

color_scheme_set("mix-blue-pink")
p <- mcmc_trace(posterior_p3, pars = colnames(posterior_p3)[1:4],
                n_warmup = 1500, facet_args = list(nrow = 4)) 

ggsave(plot = p, filename = here("figures/traceplot_period_3.png"))
  
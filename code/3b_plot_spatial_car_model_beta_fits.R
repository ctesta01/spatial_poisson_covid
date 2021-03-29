
###################################################
# Plot Stan CAR Model Results - Non-Spatial Terms #
###################################################

# dependencies
library(here)
source(here("code/3a_dependencies.R"))

# define variables of interest
source(here("code/1c_variables_of_interest.R"))

# specify the period by an argument given when calling Rscript
# on this file. run this as: 
# 
#     Rscript 3b_plot_spatial_car_model_beta_fits.R 1
#     Rscript 3b_plot_spatial_car_model_beta_fits.R 2
# 
period <- as.integer(commandArgs(trailingOnly=T)[[1]]) + 1

# retrieve fit model - period 2
period2_model_rstan <- 

model_rstan <- 
  if (period == 2) {
  } else if (period == 3) {
    rstan::read_stan_csv( 
    csvfiles = list.files(
      path = here("models/"),
      pattern = "stan_fit_period3_most_covariates-202103281248*",
      full.names = TRUE))
  }

# extract period 3 posterior as matrix
posterior <- as.matrix(model_rstan)

# rename with nice names 
nice_names <- variables_of_interest[[period]]
colnames(posterior)[1:length(nice_names)] <- nice_names


# posterior density plots -------------------------------------------------

# density plots for non-spatial beta terms - period 2
mcmc_areas(posterior,
           pars = colnames(posterior)[1:length(nice_names)],
           prob = 0.80) + 
  ggtitle("Posterior distributions for non-spatial terms",
          str_c("With medians and 80% intervals, period ", period))

# save the density plots - period 2
ggsave(here(str_c("figures/stan_car_poisson_period_", period, ".png")),
       width = 10, height = 7)


# traceplots --------------------------------------------------------------

# set traceplot color scheme
color_scheme_set("mix-blue-pink")

# make traceplots - period 2
p <- mcmc_trace(posterior, pars = colnames(posterior)[1:length(nice_names)],
                n_warmup = 1500, facet_args = list(nrow = length(nice_names))) 

# save the traceplots - period 2
ggsave(plot = p, filename = here(str_c("figures/traceplot_period_", period, ".png")))

 

# beta rhats --------------------------------------------------------------

# extract rhats
rhats <- bayesplot::rhat(model_rstan)

# rename rhats
names(rhats)[1:length(nice_names)] <- nice_names

# set rhats colorscheme
color_scheme_set('brightblue')

# plot rhats - period 2
mcmc_rhat(rhats[1:length(nice_names)]) + 
  yaxis_text()

# save rhats - period 2
ggsave(here(str_c("figures/stan_car_poisson_period_", period, "_rhats.png")),
  width = 7, height = 3)


# spatial rhats -----------------------------------------------------------

# construct subtitle for spatial rhats - period 2
n_bad_rhats <- length(which(rhats[(length(nice_names)+1):(length(rhats)-1)] > 1.05))
n_rhats <- length(rhats[(length(nice_names)+1):(length(rhats)-1)])
subtitle_part_1 <- paste0(n_bad_rhats, " of ", n_rhats, " terms or ", paste0(round(n_bad_rhats / n_rhats * 100, 1), '%'),
          " had ")
subtitle_part_2 <- " values greater than 1.05"

# plot rhats - period 2
mcmc_rhat(rhats[(length(nice_names)+1):(length(rhats)-1)]) + 
  ggtitle(expression(hat(R) ~ "values for spatial-terms φ"),
          bquote(.(subtitle_part_1) ~ hat(R) ~ .(subtitle_part_2)))

ggsave(here(str_c("figures/stan_car_poisson_period_", period, "_spatial_rhats.png")),
       height = 10, width=7)
          

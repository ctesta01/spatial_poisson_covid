
###################################################
# Plot Stan CAR Model Results - Non-Spatial Terms #
###################################################

# dependencies
library(here)
source(here("code/dependencies.R"))

# define variables of interest
source(here("code/variables_of_interest.R"))

# retrieve fit model - period 2
period2_model_rstan <- rstan::read_stan_csv( 
  csvfiles = list.files(
    path = here("models/"),
    pattern = "stan_fit_period2_selected_covariates-202103151313-*",
    full.names = TRUE))

# retrieve fit model - period 3
period3_model_rstan <- rstan::read_stan_csv( 
  csvfiles = list.files(
    path = here("models/"),
    pattern = "stan_fit_period3_selected_covariates-202103132258-*",
    full.names = TRUE))

# extract period 3 posterior as matrix
posterior_p2 <- as.matrix(period2_model_rstan)
posterior_p3 <- as.matrix(period3_model_rstan)

# rename with nice names - period 2
p2_nice_names <- variables_of_interest_friendly_names[[2]]
colnames(posterior_p2)[1:length(p2_nice_names)] <- p2_nice_names

# rename with nice names - period 3
p3_nice_names <- variables_of_interest_friendly_names[[3]]
colnames(posterior_p3)[1:length(p3_nice_names)] <- p3_nice_names


# posterior density plots -------------------------------------------------

# density plots for non-spatial beta terms - period 2
mcmc_areas(posterior_p2,
           pars = colnames(posterior_p2)[1:length(p2_nice_names)],
           prob = 0.80) + 
  ggtitle("Posterior distributions for non-spatial terms",
          "With medians and 80% intervals, period 2")

# save the density plots - period 2
ggsave(here("figures/stan_car_poisson_period_2.png"),
       width = 10, height = 7)

# density plots for non-spatial beta terms - period 3 
mcmc_areas(posterior_p3,
           pars = colnames(posterior_p3)[1:length(p3_nice_names)],
           prob = 0.80) + 
  ggtitle("Posterior distributions for non-spatial terms",
          "With medians and 80% intervals, period 3")

# these all seem to make intuitive sense to me (given what analyses i've already seen): 
# more republication ~ higher death rate
# higher income ~ lower death rate 
# more education ~ lower death rate 
# nursing homes ~ higher death rate
# policy strictness ~ lower death rate

# save the density plots - period 2
ggsave(here("figures/stan_car_poisson_period_3.png"),
       width = 10, height = 7)



# traceplots --------------------------------------------------------------

# set traceplot color scheme
color_scheme_set("mix-blue-pink")

# make traceplots - period 2
p <- mcmc_trace(posterior_p2, pars = colnames(posterior_p2)[1:length(p2_nice_names)],
                n_warmup = 1500, facet_args = list(nrow = length(p2_nice_names))) 

mcmc_trace(period2_model_rstan, pars = paste0("beta[", 1:4, "]"), n_warmup = 1500)

# save the traceplots - period 2
ggsave(plot = p, filename = here("figures/traceplot_period_2.png"))

# make traceplots - period 3
p <- mcmc_trace(posterior_p3, pars = colnames(posterior_p3)[1:length(p3_nice_names)],
                n_warmup = 1500, facet_args = list(nrow = length(p3_nice_names))) 

mcmc_trace(period3_model_rstan, pars = paste0("beta[", 1:4, "]"), n_warmup = 1500)

# save the traceplots - period 3
ggsave(plot = p, filename = here("figures/traceplot_period_3.png"))
 

# beta rhats --------------------------------------------------------------

# extract rhats
rhats_p2 <- bayesplot::rhat(period2_model_rstan)
rhats_p3 <- bayesplot::rhat(period3_model_rstan)

# rename rhats
names(rhats_p2)[1:length(p2_nice_names)] <- p2_nice_names
names(rhats_p3)[1:length(p3_nice_names)] <- p3_nice_names

# set rhats colorscheme
color_scheme_set('brightblue')

# plot rhats - period 2
mcmc_rhat(rhats_p2[1:length(p2_nice_names)]) + 
  yaxis_text()

# save rhats - period 2
ggsave(here("figures/stan_car_poisson_period_2_rhats.png"),
  width = 7, height = 3)

# plot rhats - period 3
mcmc_rhat(rhats_p3[1:length(p3_nice_names)]) + 
  yaxis_text()

# save rhats - period 3
ggsave(here("figures/stan_car_poisson_period_3_rhats.png"),
  width = 7, height = 3)


# spatial rhats -----------------------------------------------------------

# construct subtitle for spatial rhats - period 2
n_bad_rhats <- length(which(rhats_p2[(length(p2_nice_names)+1):(length(rhats_p2)-1)] > 1.05))
n_rhats <- length(rhats_p2[(length(p2_nice_names)+1):(length(rhats_p2)-1)])
subtitle_part_1 <- paste0(n_bad_rhats, " of ", n_rhats, " terms or ", paste0(round(n_bad_rhats / n_rhats * 100, 1), '%'),
          " had ")
subtitle_part_2 <- " values greater than 1.05"

# plot rhats - period 2
mcmc_rhat(rhats_p2[(length(p2_nice_names)+1):(length(rhats_p2)-1)]) + 
  ggtitle(expression(hat(R) ~ "values for spatial-terms φ"),
          bquote(.(subtitle_part_1) ~ hat(R) ~ .(subtitle_part_2)))

ggsave(here("figures/stan_car_poisson_period_2_spatial_rhats.png"),
       height = 10, width=7)
          
# construct subtitle for spatial rhats - period 3
n_bad_rhats <- length(which(rhats_p3[(length(p3_nice_names)+1):(length(rhats_p3)-1)] > 1.05))
n_rhats <- length(rhats_p3[(length(p3_nice_names)+1):(length(rhats_p3)-1)])
subtitle_part_1 <- paste0(n_bad_rhats, " of ", n_rhats, " terms or ", paste0(round(n_bad_rhats / n_rhats * 100, 1), '%'),
          " had ")
subtitle_part_2 <- " values greater than 1.05"

# plot rhats - period 2
mcmc_rhat(rhats_p3[(length(p3_nice_names)+1):(length(rhats_p3)-1)]) + 
  ggtitle(expression(hat(R) ~ "values for spatial-terms φ"),
          bquote(.(subtitle_part_1) ~ hat(R) ~ .(subtitle_part_2)))

ggsave(here("figures/stan_car_poisson_period_3_spatial_rhats.png"),
       width = 7, height = 10)
          

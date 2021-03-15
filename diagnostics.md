# Model Diagnostics

[Contemporary advice](https://mc-stan.org/rstan/reference/Rhat.html) is to only
use Monte Carlo Markov Chain based results after an R-hat convergence diagnostic
of 1.05 or less has been reached.

Below we show the traceplots for the main parameters and the convergence
diagnostics for every parameter in each of the models.

##### Period 2 

![](figures/traceplot_period_2.png)

##### R-hat values for main effects

![](figures/stan_car_poisson_period_2_rhats.png)

![](figures/stan_car_poisson_period_2_spatial_rhats.png)

##### Period 3 

![](figures/traceplot_period_3.png)

##### R-hat values for main effects

![](figures/stan_car_poisson_period_3_rhats.png)

![](figures/stan_car_poisson_period_3_spatial_rhats.png)

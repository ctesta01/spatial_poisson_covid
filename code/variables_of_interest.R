# define variables of interest

# the main analysis (which this repository's modeling results are intended to
# supplement) has shifted to primarily predicting county-seeding during period 1
# rather than death rates.
variables_of_interest_p1 <- c(
)

variables_of_interest_p2 <- c(
  'scaled_per_nursing_p2',
  'scaled_per_black_p2',
  'scaled_per_atleast_hs_p2',
  'scaled_per_hispanic_p2'
)

variables_of_interest_p3 <- c(
  'scaled_political_leaning_p3',
  'scaled_income_p3',
  'scaled_per_atleast_hs_p3',
  'scaled_per_nursing_p3',
  'scaled_strict_p3'
)

variables_of_interest <- list(
  variables_of_interest_p1,
  variables_of_interest_p2,
  variables_of_interest_p3)

# human-friendly names 

variables_of_interest_friendly_names <- list()

variables_of_interest_friendly_names[[1]] <- 
  c()

variables_of_interest_friendly_names[[2]] <- 
  c('Nursing Homes',
    'Black %',
    'High School Education',
    'Hispanic %')

variables_of_interest_friendly_names[[3]] <- 
  c('Political Lean',
    'Median Income',
    'High School Education',
    'Nursing Homes',
    'Policy Strictness')
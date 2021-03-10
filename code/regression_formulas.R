
# regression_formula_p1 <- deaths_1 ~ 
#   # scaled_income_p1 + 
#   # scaled_political_leaning_p1 + 
#   # scaled_density_p1 + 
#   # scaled_per_poc_p1 + 
#   # scaled_per_black_p1 + 
#   # # scaled_mask_usage_p1 + 
#   # scaled_crowding_p1 + 
#   # # scaled_dist_to_airport_p1 + 
#   # scaled_strict_p1 + 
#   # scaled_google_p1 + 
#   # scaled_population + 
#   scaled_per_nursing_p1 + 
#   # scaled_65plus_p1 + 
#   # scaled_lat + 
#   # scaled_lon + 
#   offset(log(population))

regression_formula_p1 <- deaths_1 ~ 
  scaled_income_p1 + 
  scaled_political_leaning_p1 + 
  scaled_density_p1 + 
  scaled_per_poc_p1 + 
  scaled_per_black_p1 + 
  # scaled_mask_usage_p1 + 
  scaled_crowding_p1 + 
  # scaled_dist_to_airport_p1 + 
  scaled_strict_p1 + 
  scaled_google_p1 + 
  # scaled_population + 
  scaled_per_nursing_p1 + 
  scaled_65plus_p1 + 
  # scaled_lat + 
  # scaled_lon + 
  offset(log(population))


# regression_formula_p1_rhs <- ~ 
#   scaled_income_p1 + 
#   scaled_political_leaning_p1 + 
#   scaled_density_p1 + 
#   scaled_per_poc_p1 + 
#   scaled_per_black_p1 + 
#   scaled_mask_usage_p1 + 
#   scaled_crowding_p1 + 
#   scaled_dist_to_airport_p1 + 
#   scaled_strict_p1 + 
#   scaled_google_p1 + 
#   scaled_population_p1 + 
#   scaled_per_nursing_p1 + 
#   scaled_65plus_p1 
  # scaled_lat + 
  # scaled_lon + 
  # log(population)


regression_formula_p2 <- deaths_2 ~ 
  scaled_income_p2 + 
  scaled_political_leaning_p2 + 
  scaled_density_p2 + 
  scaled_per_poc_p2 + 
  scaled_per_black_p2 + 
  scaled_mask_usage_p2 + 
  scaled_crowding_p2 + 
  scaled_dist_to_airport_p2 + 
  scaled_strict_p2 + 
  scaled_google_p2 + 
  scaled_per_nursing_p2 + 
  scaled_65plus_p2 + 
  # scaled_lat + 
  # scaled_lon + 
  offset(log(population))

regression_formula_p2_rhs <- ~ 
  scaled_income_p2 + 
  scaled_political_leaning_p2 + 
  scaled_density_p2 + 
  scaled_per_poc_p2 + 
  scaled_per_black_p2 + 
  scaled_mask_usage_p2 + 
  scaled_crowding_p2 + 
  scaled_dist_to_airport_p2 + 
  scaled_strict_p2 + 
  scaled_google_p2 + 
  scaled_population_p2 + 
  scaled_per_nursing_p2 + 
  scaled_65plus_p2 
  # scaled_lat + 
  # scaled_lon



regression_formula_p3 <- deaths_3 ~ 
  scaled_income_p3 + 
  scaled_political_leaning_p3 + 
  scaled_density_p3 + 
  scaled_per_poc_p3 + 
  scaled_per_black_p3 + 
  scaled_mask_usage_p3 + 
  scaled_crowding_p3 + 
  scaled_dist_to_airport_p3 + 
  scaled_strict_p3 + 
  scaled_google_p3 + 
  scaled_per_nursing_p3 + 
  scaled_65plus_p3 + 
  # scaled_lat + 
  # scaled_lon + 
  offset(log(population))

regression_formula_p3_rhs <- ~ 
  scaled_income_p3 + 
  scaled_political_leaning_p3 + 
  scaled_density_p3 + 
  scaled_per_poc_p3 + 
  scaled_per_black_p3 + 
  scaled_mask_usage_p3 + 
  scaled_crowding_p3 + 
  scaled_dist_to_airport_p3 + 
  scaled_strict_p3 + 
  scaled_google_p3 + 
  scaled_population_p3 + 
  scaled_per_nursing_p3 + 
  scaled_65plus_p3 
  # scaled_lat + 
  # scaled_lon 
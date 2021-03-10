
#####################################
# prepare data for spatial modeling #
#####################################

# merge the spatial counties data into the regression data 
df_spatial <- inner_join(us_counties_map, df, by = c('county_fips' = 'FIPS'))

# remove zero death counties
# df_spatial %<>% filter(deaths_3 > 0)

# drop NA rows
no_nas_p1_indexes <- st_drop_geometry(df_spatial)[,all.vars(regression_formula_p1)] %>% complete.cases()
df_spatial_no_nas <- df_spatial[no_nas_p1_indexes,]

# double check that there are no more NA rows
no_nas_p1_indexes2 <- ! complete.cases(st_drop_geometry(df_spatial)[,all.vars(regression_formula_p1)])
which(no_nas_p1_indexes2)

# print number of NA rows
st_drop_geometry(df_spatial)[,all.vars(regression_formula_p1)] %>% 
  filter(! complete.cases(.)) %>% 
  nrow()

# calculate neighbors matrix
W.nb <- poly2nb(df_spatial)
W.list <- nb2listw(W.nb, style="B", zero.policy = TRUE)

# we have some no-neighbor counties, so we need to remove those 
no_neighbor_counties <- W.list$weights %>% sapply(length) %>% equals(0) 
df_spatial <- df_spatial[!no_neighbor_counties,]

# recalculate the neighbors weights
W.nb <- poly2nb(df_spatial)
W.list <- nb2listw(W.nb, style="B")
W <- nb2mat(W.nb, style="B")

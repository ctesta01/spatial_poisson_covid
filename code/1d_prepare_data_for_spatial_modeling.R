
#####################################
# prepare data for spatial modeling #
#####################################

# merge the spatial counties data into the regression data 
df_spatial <- inner_join(us_counties_map, df, by = c('county_fips' = 'FIPS'))

create_spatial_df_and_W <- function(df_spatial, variables_of_interest) {
  
  # drop NA rows
  no_nas_indexes <- st_drop_geometry(df_spatial)[,variables_of_interest] %>% complete.cases()
  df_spatial <- df_spatial[no_nas_indexes,]
  
  # double check that there are no more NA rows
  no_nas_indexes2 <- complete.cases(st_drop_geometry(df_spatial)[,variables_of_interest])
  stopifnot(all(no_nas_indexes2))
  
  # confirm no NA rows
  n_na_rows <- st_drop_geometry(df_spatial)[,variables_of_interest] %>% 
    filter(! complete.cases(.)) %>% 
    nrow()
  stopifnot(n_na_rows == 0)
  
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
  
  # return a named list
  return(list(df_spatial = df_spatial, W = W))
}


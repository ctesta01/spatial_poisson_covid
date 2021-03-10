
# Load Data

# load regression data
df <- readr::read_csv(here("data/regression_variables.csv"))
df %<>% dplyr::select(-geometry)

# load us counties data
us_counties_map <- get_urbn_map('counties', sf=T)

# convert fips to string 
df$FIPS %<>% as.character() %>% paste0(ifelse(nchar(.) == 4, "0", ""), .)

# load popsizes
popsizes <- readr::read_csv(here("data/covid_county_population_usafacts.csv"), col_types = cols('c', 'c', 'c', 'd'))
popsizes$countyFIPS %<>% as.character() %>% paste0(ifelse(nchar(.) == 4, "0", ""), .)

# merge popsizes into regression data 
df %<>% left_join(popsizes, by = c('FIPS' = 'countyFIPS'))

# cleaning ---------------------------------------------------------------------------------------

# it appears some of the death counts are negative
df$deaths_3 %>% summary()
df$deaths_3[df$deaths_3 < 0] <- 0 # replace with zeroes
df$deaths_2[df$deaths_2 < 0] <- 0 # replace with zeroes
df$deaths_1[df$deaths_1 < 0] <- 0 # replace with zeroes

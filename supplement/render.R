#############################
# render the supplement pdf #
#############################

library(here)
rmarkdown::render(here("supplement/supplement.Rmd"),
                  output_file = here("supplement/supplement.pdf"),
                  clean = FALSE)

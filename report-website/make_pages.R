# libraries
if (!require("librarian")){
  install.packages("librarian")
  library(librarian)
}
shelf(
  dplyr, glue, here, purrr, readr, rmarkdown)

# variables ----

# input data
dir_data <- here("data/alaska")
idxs_csv <- glue("{dir_data}/_indicators.csv")

# output website
dir_web  <- here("report-website")
idx_rmd  <- glue("{dir_web}/_indicator.Rmd")

# read indicators ----

idxs_tbl <- readr::read_csv(idxs_csv, col_types = cols())

# write html page per indicator ----

idxs_tbl %>% 
  purrr::pwalk(function(idx, region, name, data_csv, ...){
    # output html file
    out_htm <- glue("{dir_web}/z_{idx}.html")
    
    # render from indicator Rmd template into html
    rmarkdown::render(
      idx_rmd,
      output_file = out_htm,
      params = list(
        idx_region = region,
        idx_name   = name,
        idx_csv    = data_csv)) })

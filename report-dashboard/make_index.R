if (!require("librarian")){
  install.packages("librarian")
  library(librarian)
}
shelf(
  dplyr, glue, here, knitr, readr)

dir_data <- here("data/alaska")
idxs_csv <- glue("{dir_data}/_indicators.csv")

idxs_tbl <- read_csv(idxs_csv, col_types = cols())

dir_dash <- here("report-dashboard")
setwd(dir_dash) # getwd()

readLines("_index.Rmd") %>% 
  writeLines("index.Rmd")

region_previous <- ""
for (i in 1:nrow(idxs_tbl)){ # i = 2
  attach(idxs_tbl[i,])
  
  message(glue("idx: {idx}"))
  
  # browser()
          
  if (region != region_previous){
    glue("\n\n# {region}\n\n") %>% 
      write("index.Rmd", append=T)
    region_previous <- region
  }
  
  knit_expand("_indicator_expand.Rmd") %>% 
    write("index.Rmd", append=T)
}

rmarkdown::render("index.Rmd")

# libraries
if (!require("librarian")){
  install.packages("librarian")
  library(librarian)
}
shelf(
  dplyr, glue, here, purrr, readr, rvest, stringr)

# variables
url      <- "https://apps-afsc.fisheries.noaa.gov/refm/reem/ecoweb/Index.php?ID=9"
dir_data <- here("data/alaska")
idxs_csv <- glue("{dir_data}/_indicators.csv")
rgns     <- c(
  EBS  = "Eastern Bering Sea",
  WAI  = "Western AI",
  CAI  = "Central AI",
  EAI  = "Eastern AI",
  WGOA = "Western Gulf of Alaska",
  EGOA = "Eastern Gulf of Alaska")

# read indicator xml nodes
xml <- rvest::read_html(url)
xml_idx <- xml %>% 
  html_elements("a[title='open data set']")

# save table of indicators
idxs_tbl <- tibble(
  name = xml_idx %>% 
    html_text() %>%
    str_trim(),
  pg = xml_idx %>% 
    html_attr("href") %>% 
    str_replace("javascript:popUp\\('(.*)'\\)", "\\1")) %>% 
  mutate(
    idx     = str_replace(pg, fixed("dataWindow.php?Data="), ""),
    url     = glue("{dirname(url)}/{pg}"),
    rgn     = ifelse(
      str_detect(idx, "_"),
      str_replace(idx, "([A-z]+)_(.*)", "\\1"),
      "EBS"),
    region   = rgns[rgn],
    meta_yml = glue("{dir_data}/{idx}.yml"),
    data_csv = glue("{dir_data}/{idx}.csv")) %>%
  select(rgn, idx, region, name, url, meta_yml, data_csv, html)
dir.create(dir_data, showWarnings = F, recursive = T)
write_csv(idxs_tbl, idxs_csv)

# write indicators to data/ folder
idxs_tbl %>% 
  pwalk(
    function(idx, url, meta_yml, data_csv, ...){
      # get table
      d <- read_html(url) %>% 
        html_table() %>% 
        .[[1]]
      
      # write meta
      d[1:3,] %>% 
        write_delim(meta_yml, col_names = F)
      
      # write data
      d[5:nrow(d),] %>% 
        write_csv(data_csv, col_names = F)
    })
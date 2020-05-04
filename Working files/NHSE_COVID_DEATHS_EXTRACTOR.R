library(tidyverse)
library(readxl)
library(janitor)
library(lubridate)

yest_d <- day(Sys.Date()-1)
yest_m <- lubridate::month((Sys.Date()-1), label = TRUE, abbr=FALSE)
yest_y <- year(Sys.Date()-1)
download_filepath <- "c:/Test/" #change this to your own filepath


durl <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2020/04/" # this might break once we move to next month?
filename <- paste("COVID-19-total-announced-deaths-",yest_d,"-",yest_m,"-",yest_y,".xlsx", sep="") #this sometimes chnages to "COVID-19-all-announced-deaths, may need to check the url above sometimes
download_url <- paste(durl, filename, sep="")
download.file(download_url, paste(download_filepath, filename, sep=""), method="curl")
remove(durl, yest_d, yest_m, yest_y)


trust_death_summary <- read_xlsx(paste(download_filepath, filename, sep=""), sheet= "COVID19 total deaths by trust", skip = 15) %>%
  clean_names() %>%
  slice(3:n()) %>%
  #filter(nhs_england_region == "Midlands") %>% # filter to a region if you wish.
  remove_empty(c("rows", "cols")) %>%
  select(nhs_england_region:total) %>% #gets rid of any hidden data located after the total column
  select(-up_to_01_mar_20, -awaiting_verification, -nhs_england_region, -total) %>% #removes columns that are not part of a time series
  rename("Provider"=name) %>%
  pivot_longer(col=c(-code, -Provider), names_to= "date", values_to="number_of_deaths") %>% # transform to long format. 
  mutate(date = str_sub(date, 2,-1))

trust_death_summary$date <- parse_double(trust_death_summary$date)
trust_death_summary <- trust_death_summary %>% mutate(date = as_date(date, origin="1899-12-30")) #fix the date formatting.

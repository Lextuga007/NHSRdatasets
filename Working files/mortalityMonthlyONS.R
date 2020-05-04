library(readxl)
library(janitor)
library(tidyverse)
library(stringi)
library(lubridate)
library(tidyxl)

# Source and licence acknowledgement

# This data has been made available through Office of National Statistics under the Open Government
# Licence http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/

#https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales


# Download data -----------------------------------------------------------

# 2020
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2020/publishedoutputfebruary20202.xls",
  destfile = "Monthly2020Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2019
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2019/publishedoutputdecember2019.xls",
  destfile = "Monthly2019Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2018
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2018/publishedannual2018.xls",
  destfile = "Monthly2018Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2017
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2017/publishedoutputannual2017final.xls",
  destfile = "Monthly2017Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2016
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2016/publishedoutput2016final.xls",
  destfile = "Monthly2016Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2015
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2015/publishedoutput2015final.xls",
  destfile = "Monthly2015Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2014
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2014/publishedoutput2014finaltcm774115982.xls",
  destfile = "Monthly2014Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2013
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2013/publishedoutput2013finaltcm773717241.xls",
  destfile = "Monthly2013Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2012
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2012/publishedoutput2012finaltcm773197501.xls",
  destfile = "Monthly2012Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2011
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2011/publishedoutput2011finaltcm772738151.xls",
  destfile = "Monthly2011Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2010
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2010/publishedoutputfeb021tcm772274383.xls",
  destfile = "Monthly2010Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2009
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2009/publishedoutput200tcm772274362.xls",
  destfile = "Monthly2009Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2008
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2008/publishedoutput200tcm772274292.xls",
  destfile = "Monthly2008Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2007
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2007/publishedoutput200tcm772274233.xls",
  destfile = "Monthly2007Mortality.xls",
  method = "wininet",
  mode = "wb")

# 2006
download.file(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fbirthsdeathsandmarriages%2fdeaths%2fdatasets%2fmonthlyfiguresondeathsregisteredbyareaofusualresidence%2f2006/publishedoutput200tcm772274163.xls",
  destfile = "Monthly2006Mortality.xls",
  method = "wininet",
  mode = "wb")


# Reload just figure worksheet -------------------------------------

files_list_sheets <- list.files(path = "Working files/Monthly",
                         pattern = "Figures",
                         full.names = TRUE
                         )

for(i in files_list_sheets) {

  x <- read_xls((i))

  assign(i, x)
}


# Formats of cells --------------------------------------------------------

# because bold has been used to denote hierarchy of regions

formats <- xlsx_formats("Working files/Monthly/Monthly2006Mortality-Figures for 2006.xlsx")

formats$local$font$bold

# Format data 2006 - 2010 -----------------------------------------------------------

formatFunction <- function(file){

ONS <- file %>%
  clean_names %>%
  remove_empty(c("rows","cols")) %>%
  rename_at(vars(starts_with("Monthly")), ~("codes")) %>%
  mutate(category = coalesce(x2, x3, x4),

         # Remove the footnote numbers in category
         category = case_when(str_detect(category, pattern = '[0-9]') ~ substr(category, 1, str_locate(category, pattern = '[0-9]') - 1),
                              TRUE ~ category)) %>%
  select(category, everything()) %>%
  filter(!codes %in% c('Footnotes:',
                          '1')) %>%
  select(-x2, -x3, -x4) %>%
  mutate(category = case_when(is.na(category) ~ 'category',
                              TRUE ~ category),
         codes = case_when(str_detect(codes, "Area Codes") ~ "area_codes",
                           TRUE ~ codes))



  # Push date row to column names

  onsFormattedJanitor <- row_to_names(ONS, 1)

  x <- onsFormattedJanitor %>%
    pivot_longer(cols = -category:-area_codes,
                 names_to = "dates",
                 values_to = "counts")

return(x)

}

Mortality2006 <- formatFunction(`Working files/Monthly/Monthly2006Mortality-Figures for 2006.csv`)
Mortality2007 <- formatFunction(`Working files/Monthly/Monthly2007Mortality-Figures for 2007.csv`)
Mortality2008 <- formatFunction(`Working files/Monthly/Monthly2008Mortality-Figures for 2008.csv`)
Mortality2009 <- formatFunction(`Working files/Monthly/Monthly2009Mortality-Figures for 2009.csv`)
Mortality2010 <- formatFunction(`Working files/Monthly/Monthly2010Mortality-Figures for 2010.csv`)

# # Format data 2011  -----------------------------------------------------------

# Added column about former district areas

formatFunction <- function(file){

  ONS <- `Working files/Monthly/Monthly2011Mortality-Figures for 2011.csv` %>%
    clean_names %>%
    remove_empty(c("rows","cols")) %>%
    rename_at(vars(starts_with("Monthly")), ~("category_2")) %>%
    mutate(category_1 = coalesce(category_2, x2, x3),

           # Remove the footnote numbers in category
           category_1 = case_when(str_detect(category_1, pattern = '[0-9]') ~ substr(category_1, 1, str_locate(category_1, pattern = '[0-9]') - 1),
                                TRUE ~ category_1)) %>%
    select(category_1, category_2, everything()) %>%
    fill(x2) %>%
    mutate(category_2 = case_when(x2 == "Former districts of:" ~ x2,
                                  TRUE ~ category_2)) %>%
    filter(!is.na(x4)) %>%
    select(-x2, -x3) %>%

    # # move column headers to first row as next chunk will make this the column headers
    # mutate(category_1 = case_when(is.na(category_1) ~ 'category_1',
    #                             TRUE ~ category_1),
    #        category_2 = case_when(is.na(category_2) ~ "category_2",
    #                          TRUE ~ category_2),
    # move UA to category 2
    mutate(category_2 = case_when(str_detect(category_1, " UA") ~ "UA",
                                  str_detect(category_1, "(Met County)") ~ "Met County",
                                  TRUE ~ category_2),
           category_1 = case_when(str_detect(category_1, " UA") ~
                                    substr(category_1,1,str_locate(category_1, " UA") -1),
                                  TRUE ~ category_1),
    )



  # Push date row to column names

  onsFormattedJanitor <- row_to_names(ONS, 1)

  x <- onsFormattedJanitor %>%
    pivot_longer(cols = -category:-area_codes,
                 names_to = "dates",
                 values_to = "counts")

  return(x)

}

Mortality2011 <- formatFunction(`Working files/Monthly/Monthly2011Mortality-Figures for 2011.csv`)
Mortality2012 <- formatFunction(`Working files/Monthly/Monthly2012Mortality-Figures for 2012.csv`)
Mortality2013 <- formatFunction(`Working files/Monthly/Monthly2013Mortality-Figures for 2013.csv`)
Mortality2014 <- formatFunction(`Working files/Monthly/Monthly2014Mortality-Figures for 2014.csv`)
Mortality2015 <- formatFunction(`Working files/Monthly/Monthly2015Mortality-Figures for 2015.csv`)
Mortality2016 <- formatFunction(`Working files/Monthly/Monthly2016Mortality-Figures for 2016.csv`)
Mortality2017 <- formatFunction(`Working files/Monthly/Monthly2017Mortality-Figures for 2017.csv`)
Mortality2018 <- formatFunction(`Working files/Monthly/Monthly2018Mortality-Figures for 2018.csv`)
Mortality2019 <- formatFunction(`Working files/Monthly/Monthly2019Mortality-Figures for 2019.csv`)
Mortality2020 <- formatFunction(`Working files/Monthly/Monthly2020Mortality-Figures for 2020.csv`)

# Bind together -----------------------------------------------------------

ons_mortality_monthly <- do.call("rbind", list(
  Mortality2006,
  Mortality2007,
  Mortality2008,
  Mortality2009,
  Mortality2010,
  Mortality2011,
  Mortality2012,
  Mortality2013,
  Mortality2014,
  Mortality2015,
  Mortality2016,
  Mortality2017,
  Mortality2018,
  Mortality2019,
  Mortality2020))


  # Save as rda file

  save(ons_mortality_monthly, file = "data/ons_mortality_monthly.rda")

  # Save as an csv file

  write_csv(ons_mortality_monthly, file = "`Working files`/ons_mortality_monthly.csv")

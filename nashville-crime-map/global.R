library(tidyverse)
library(shiny)
library(RSocrata)
library(lubridate)
library(sf)
library(mapdeck)

#load app token for connecting to database
app_token <- read_tsv("app_token.txt", col_names = FALSE) %>%
  pull(1)
#function to connect to database
get_data <- function(n_weeks, app_token) {
  #pull max date
  max_dt <- read.socrata(
    "https://data.nashville.gov/resource/2u6v-ujjs.csv?$order=incident_occurred DESC &$limit=10",
    app_token = app_token
  ) %>% 
    pull(incident_occurred) %>%
    max(na.rm=TRUE)
  #pull n most recent weeks of data
  start_dt <- max_dt - weeks(n_weeks)
  read.socrata(
    paste0(
      "https://data.nashville.gov/resource/2u6v-ujjs.csv?$order=incident_occurred DESC &$where=incident_occurred >", 
      "'", format.POSIXct(start_dt, format = "%Y-%m-%dT%H:%M:%S"), "'"
    ), 
    app_token = app_token
  )
}

source(file.path("mapdeck_key.R")) #load mapdeck key
#load Nashville census polygon data
polyLS <- readRDS(gzcon(url("https://github.com/mcnewcp/Nashville-census-tracts/blob/master/Nashville_Census_Polygons_2019.RDS?raw=true")))

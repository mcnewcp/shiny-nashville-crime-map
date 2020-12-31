library(tidyverse)
library(shiny)
library(RSocrata)
library(lubridate)
library(sf)
library(mapdeck)

source(file.path("keys.R")) #load keys

#pull max date
max_date <- read.socrata(
  "https://data.nashville.gov/resource/2u6v-ujjs.csv?$order=incident_occurred DESC &$limit=10",
  app_token = app_token
) %>%
  pull(incident_occurred) %>%
  max(na.rm=TRUE) %>%
  date()

#function to connect to database
get_data <- function(start_date, end_date, app_token) {
  #pull n most recent weeks of data
  start_dt <- ymd_hms(paste(start_date, "00:00:00"))
  end_dt <- ymd_hms(paste(end_date, "23:59:59"))
  read.socrata(
    paste0(
      "https://data.nashville.gov/resource/2u6v-ujjs.csv?$order=incident_occurred DESC &$where=incident_occurred >=", 
      "'", format.POSIXct(start_dt, format = "%Y-%m-%dT%H:%M:%S"), "' AND incident_occurred <", 
      "'", format.POSIXct(end_dt, format = "%Y-%m-%dT%H:%M:%S"), "'"
    ), 
    app_token = app_token
  )
}

#load Nashville census polygon data
polyLS <- readRDS(gzcon(url("https://github.com/mcnewcp/Nashville-census-tracts/blob/master/Nashville_Census_Polygons_2019.RDS?raw=true")))

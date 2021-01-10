library(shiny)
#run app
runApp("nashville-crime-map")

#deploy to shinyapps.io
rsconnect::deployApp(file.path('nashville-crime-map'))

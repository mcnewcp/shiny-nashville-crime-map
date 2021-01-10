fluidPage(  
  sidebarLayout(
    sidebarPanel(
      dateRangeInput(
        "daterange", "Select Date Range", 
        start = max_date - days(7), end = max_date, format = "mm/dd/yy",
        max = max_date
      ),
      actionButton("download_button", "Connect to Live Data!"),
      hr(),
      radioButtons(
        "map_select", "Choose Map View",
        choices = c("Individual Points", "Aggregated Polygons"),
        selected = "Individual Points"
      ),
      conditionalPanel(
        condition = "input.map_select == 'Aggregated Polygons'",
        radioButtons(
          "agg_select", "Aggregate points by:",
          choices = c("Census Tract", "Census Block Group", "Voting District"),
          selected = "Census Tract"
        ),
        sliderInput("opacity", "Choose Layer Opacity", min = 0, max = 1, value = 1, step = 0.05),
        sliderInput("height", "Choose Layer Elevation Multiplier", min = 0, max = 100, value = 50, step = 1)
      ),
      
    ),
    mainPanel(
      mapdeckOutput("map"),
      verbatimTextOutput("debug")
    )
  )
)
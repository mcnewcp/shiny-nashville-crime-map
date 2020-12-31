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
        "map_select", "Choose Map Grouping",
        choices = c("Census Tract", "Census Block Group", "Voting District", "Individual Points"),
        selected = "Census Block Group"
      ),
      sliderInput("opacity", "Choose Layer Opacity", min = 0, max = 1, value = 0.6, step = 0.05)
    ),
    mainPanel(
      mapdeckOutput("map"),
      verbatimTextOutput("debug")
    )
  )
)
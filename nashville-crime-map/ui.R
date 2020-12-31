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
      )
    ),
    mainPanel(
      mapdeckOutput("map"),
      verbatimTextOutput("debug")
    )
  )
)
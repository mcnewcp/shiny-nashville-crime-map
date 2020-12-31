fluidPage(  
  sidebarLayout(
    sidebarPanel(
      dateRangeInput(
        "daterange", "Select Date Range", 
        start = max_date - days(7), end = max_date, format = "mm/dd/yy",
        max = max_date
      ),
      actionButton("download_button", "Connect to Live Data!")
    ),
    mainPanel(
      mapdeckOutput("map"),
      verbatimTextOutput("debug")
    )
  )
)
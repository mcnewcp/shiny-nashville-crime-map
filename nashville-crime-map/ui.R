fluidPage(theme = shinytheme("darkly"), title = "Nashville Crime Data Map", 
  titlePanel("Nashville Crime Data Map"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput(
        "daterange", "Select Date Range", 
        start = max_date - days(7), end = max_date, format = "mm/dd/yy",
        max = max_date
      ),
      actionButton("download_button", "Connect to Live Data!"),
      tagList(br(), br(), "Live data loaded from: ", a("data.nashville.gov", href="https://data.nashville.gov/Police/Metro-Nashville-Police-Department-Incidents/2u6v-ujjs")),
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
      mapdeckOutput("map", height = '800px'),
      h5("right click + drag to change perspective"),
      h5("left click + drag to pan"),
      h5("mouse wheel to zoom"),
      h5("hover points for details")
      
      # verbatimTextOutput("debug")
    )
  )
)

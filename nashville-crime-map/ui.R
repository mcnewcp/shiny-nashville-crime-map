fluidPage(  
  sidebarLayout(
    sidebarPanel(
      numericInput("weeks", "Weeks of data to load:", value = 3, min = 1, max = 100, step = 1),
      actionButton("download_button", "Load!")
    ),
    mainPanel(
      mapdeckOutput("map")
    )
  )
)
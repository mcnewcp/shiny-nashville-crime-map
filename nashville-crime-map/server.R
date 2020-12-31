function(input, output) {
  #load dataset
  dataSF <- reactive({
    #only update on button press
    input$download_button
    isolate({
      withProgress({
        setProgress(message = "Connecting to live data...")
        get_data(input$weeks, app_token) %>%
          #drop blank coords
          filter(!is.na(longitude) | !is.na(latitude)) %>%
          #drop coord errors (i.e. coords way outside of Nashville)
          filter(latitude > 35 & latitude < 36.7) %>%
          filter(longitude > -87.7 & longitude < -85.7) %>%
          #one entry per datetime per lat/lon
          distinct(incident_occurred, latitude, longitude, .keep_all = TRUE) %>%
          #make sf object
          st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
          #make tooltip
          mutate(tooltip = paste(incident_occurred, "<br/>", offense_description))
      })
    })
  })
  
  #generate aggregated SF
  aggSF <- reactive({
    polyLS$block_group %>%
      #count points in each polygon
      mutate(incidents = lengths(st_intersects(., dataSF()))) %>%
      #make tooltip
      mutate(tooltip = paste(name, "<br/>Incident Count:", incidents))
  })
  
  #generate map
  output$map <- renderMapdeck({
    mapdeck(token = mapdeck_key, style = mapdeck_style('dark'), pitch = 45)
  })
  #update map layer
  observeEvent({aggSF()}, {
    mapdeck_update(map_id = "map") %>%
      add_polygon(
        data = aggSF(),
        fill_colour = "incidents", fill_opacity = 0.5,
        elevation = "incidents", elevation_scale = 30,
        tooltip = "tooltip"
      ) 
  })
}
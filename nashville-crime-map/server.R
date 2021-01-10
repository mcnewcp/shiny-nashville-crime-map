function(input, output) {
  #load dataset
  dataSF <- reactive({
    #only update on button press
    input$download_button
    isolate({
      withProgress({
        setProgress(message = "Connecting to live data...")
        get_data(input$daterange[1], input$daterange[2], app_token) %>%
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
    if (input$agg_select == "Census Tract") {
      polyLS$tract %>%
        #count points in each polygon
        mutate(incidents = lengths(st_intersects(., dataSF()))) %>%
        #make tooltip
        mutate(tooltip = paste(name, "<br/>Incident Count:", incidents))
    } else if (input$agg_select == "Census Block Group") {
      polyLS$block_group %>%
        #count points in each polygon
        mutate(incidents = lengths(st_intersects(., dataSF()))) %>%
        #make tooltip
        mutate(tooltip = paste(name, "<br/>Incident Count:", incidents))
    } else {
      polyLS$voting_district %>%
        #count points in each polygon
        mutate(incidents = lengths(st_intersects(., dataSF()))) %>%
        #make tooltip
        mutate(tooltip = paste(name, "<br/>Incident Count:", incidents))
    }
  })
  
  #handle layer opacity
  layer_opacity <- reactive({
    #mapdeck doesn't like opacity == 1
    ifelse(input$opacity == 1, 0.999, input$opacity)
  })
  
  #generate map
  output$map <- renderMapdeck({
    mapdeck(
      token = mapdeck_key, style = mapdeck_style('dark'), pitch = 45,
      location = c(-86.77644756173848, 36.164626527074354), zoom = 9.5
    )
  })
  #update map layer(s)
  observe({
    if (input$map_select == "Individual Points") {
      mapdeck_update(map_id = "map") %>%
        clear_polygon(layer_id = "agglayer") %>%
        add_heatmap(
          data = dataSF(),
          layer_id = "heatlayer",
          update_view = FALSE
        ) %>%
        add_scatterplot(
          data = dataSF(),
          layer_id = "pointlayer",
          fill_colour = "#FFFFFF", 
          radius = 25,
          tooltip = "tooltip",
          update_view = FALSE,
          auto_highlight = TRUE
        )
    } else {
      mapdeck_update(map_id = "map") %>%
        clear_heatmap("heatlayer") %>%
        clear_scatterplot("pointlayer") %>%
        add_polygon(
          data = aggSF(),
          layer_id = "agglayer",
          fill_colour = "incidents", fill_opacity = layer_opacity(),
          elevation = "incidents", elevation_scale = input$height,
          tooltip = "tooltip",
          update_view = FALSE,
          auto_highlight = TRUE
        ) 
    }
    
    
  })
  
  #debug print
  output$debug <- renderPrint(input$map_select)
  
}
transform_metadata_to_df <- function(x) {
  x[[1]] %>% 
    map(as_tibble) %>% 
    bind_rows() %>% # list_rbind also works
    mutate(latestData = 
             map_chr(latestData, 1, .default = NA_character_)) %>% 
    mutate(latestData = 
             as_datetime(latestData, tz = "UTC")) %>% 
    unnest_wider(location) %>% 
    unnest_wider(latLon)
}

to_iso8601 <- function(dttm, offset) {
  dttm %>% 
    add(days(offset)) %>%
    iso8601() %>% 
    paste0("Z")
}

transform_volumes <- function(x) {
  x$trafficData$volume$byHour %>%
    as_tibble() %>% 
    unnest_wider(edges) %>% 
    unnest_wider(node) %>% 
    unnest_wider(total) %>% 
    unnest_wider(volumeNumbers) %>% 
    mutate(from = as_datetime(from),
           to = as_datetime(to))
}

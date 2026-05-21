# ------------------------------------------------------------------------------
# Purpose: Pulls in Bellevue's stage data from the Herrera DRIP API
# Author: Brianna Pierce
# Email: bpierce@bellevuewa.gov
# Created: 2026-05-21
# Revised: 2026-05-21
# ------------------------------------------------------------------------------


# Required Packages ------------------------------------------------------------
require(dplyr)
require(tidyr)
require(httr2)
require(jsonlite)
require(dotenv)


# Create a function to get data via the API ------------------------------------
getStage <- function(start_date = "2022-10-01",
                     end_date = "2025-09-30",
                     limit = "900_000") {
  
  # Load EDMS secrets from env file
  dotenv::load_dot_env(file = "env")
  
  # Build the URL
  url         <-  'https://hec-drip-edms.azurewebsites.net/ts'
  project     <-  Sys.getenv("EDMS_PROJECT")
  secret      <-  Sys.getenv("EDMS_API_KEY")
  endpoint    <-  "inst_vals"
  query_params = c("project" = project,
                   "parameter" = "Stage",
                   "start_date" = start_date,
                   "end_date" = end_date,
                   "timezone" = "US/Pacific",
                   "limit" = limit)
  
  # Get set up
  JSON_export <- list()
  data <- data.frame()
  
  # Get the data
  while (!is.null(query_params[[1]])) {
    # REQUEST BUILD
    response  <- request(url) %>%
      req_headers("accept" = "application/json") %>%
      req_headers("x-api-key" = secret)  %>%
      req_url_path_append(project) %>%  # required on all
      req_url_path_append(endpoint) %>%     # required on all
      req_url_query(!!!query_params)
    
    # REQUEST PERFORM AND TRANSFORM TO JSON
    table_info <- req_perform(response) %>%
      resp_body_string() %>%
      fromJSON()
    
    if(length(data) == 0){
      data <- data.frame(table_info$results)
    } else{
      data <- rbind(data, data.frame(table_info$results))
    }
    
    query_params <- table_info$next_params
    
  }
  
  # Return the dataframe
  return(data)
  
}

# Test the function ----
#x <- getStage()









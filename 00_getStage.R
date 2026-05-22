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
require(arrow)
require(lubridate)


# Create a function to get data via the API ------------------------------------

getStage <- function(start_date = NULL,
                     end_date = NULL,
                     aggregation_unit = c("15 mins", "hour", "day", "week", "month", "quarter", "season", "year")) {     #Setting the start and end dates to null fetches all available data
  # Check user input against valid options listed above
  aggregation_unit <- match.arg(aggregation_unit)
  
  # Load EDMS secrets from .env file
  dotenv::load_dot_env(file = "env")
  
  # Build the URL
  url <- 'https://hec-drip-edms.azurewebsites.net/ts'
  project <- Sys.getenv("EDMS_PROJECT")
  secret <- Sys.getenv("EDMS_API_KEY")
  query_params <- c("start_date" = start_date, "end_date" = end_date)
  endpoint <- "pqt"
  
  # Specify columns (gauges)
  # Note, these column names will be changing with the next API update so I will need to change them. Could make this dynamic by first calling the table names from the API and then using fuzzy matching to pull the relevant columns.
  columns = c(
    "Stage_ft_Bellevue Utilities - COB-WT3_Stage-ft (time-corr)",
    "Stage_ft_Bellevue Utilities - RichardsBelRM0.4_Water-Lvl-ft",
    "Stage_ft_Bellevue Utilities 08LAK2827_Water-Lvl-ft"
  )
  
  # REQUEST BUILD
  request <- request(url) %>%
    req_headers("accept" = "application/json") %>%
    req_headers("x-api-key" = secret) %>%
    req_url_path_append(project) %>% 
    req_url_path_append(endpoint) %>% 
    req_body_json(columns) %>%
    req_url_query(!!!query_params) %>%
    req_method("GET")
  
  # REQUEST PERFORM AND TRANSFORM TO JSON
  response <- req_perform(request)
  
  data <- read_parquet(response$body) # Final output from the API
  
  # CLEAN UP
  # Remove rows where there is no stage for any gauge associated with the timestamp
  data <- data[rowSums(is.na(data)) < ncol(data)-1, ]
  
  # Clean up the timestamps and aggregate
  data <- data %>% 
    pivot_longer(cols = columns, 
                 names_to = "Gauge", 
                 values_to = "Stage_ft")
  
  if (aggregation_unit == "15 min") {
    data$datetime <- round_date(data$datetime, "15 mins")
  } else {
    data$datetime <- floor_date(data$datetime, aggregation_unit)  
  }
    
  data <- data %>% 
    drop_na(Stage_ft) %>% 
    pivot_wider(id_cols = datetime, 
                names_from = Gauge, 
                values_from = Stage_ft,
                values_fn=mean) # Average values on the same time step
  
  # Add the water year
  data$WY <- ""
  data$WY[month(data$datetime) >= 10] <- year(data$datetime[month(data$datetime) >= 10])+1
  data$WY[month(data$datetime) < 10] <- year(data$datetime[month(data$datetime) < 10])
  
  return(data)
}

# Test the function ----
# x <- getStage()
# View(x)
# 
# x1 <- getStage(aggregation_unit = "hour")
# View(x1)

x <- getStage(aggregation_unit = "day")
View(x)

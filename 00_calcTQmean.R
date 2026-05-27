# ------------------------------------------------------------------------------
# Purpose: Creates a function to calculate TQmean
# Author: Brianna Pierce
# Email: bpierce@bellevuewa.gov
# Created: 2026-05-21
# Revised: 2026-05-21
# ------------------------------------------------------------------------------

# For development only: get the data
daily <- getStage(aggregation_unit = "day")
View(daily)

# *** TQmean is based off of the daily average

# Required Packages ------------------------------------------------------------
require(dplyr)
require(tidyr)
require(lubridate)

# Create a function to calculate the TQmean ------------------------------------
calc.TQmean <- function(daily_data) {
  
  TQmean <- daily_data %>% 
    group_by(WY) %>% 
    mutate(WY_avg_stage = mean) #....ok I have multiple columns for each gauge
  # I think I should edit the getStage function to keep it pivoted long. 
  # Then group by gauge and WY.
  # Pick back up here .............................
  
  
  
  
  # step 1: pull out data only for the water year
  daily.data <- daily.data %>%
    mutate(date = as.Date(date, format = "%Y-%m-%d")) %>%
    filter(date >= start.date & date <= end.date) %>%
    arrange(date)
  # step 2 Compute and append annual average reach depth to each row
  daily.data <- daily.data %>%
    mutate(mean.ard = mean(daily.ard.ft)) 
  
  # step 3 create logical value representing daily average depth > annual average depth (i.e. tqm)
  daily.data$tqm <- ifelse(daily.data$mean.ard > daily.data$daily.ard.ft, 1, 0)
  
  # step 4 compute proportion of time over mean daily average reach depth
  TQmean <- sum(daily.data$tqm)/length(daily.data$tqm)
  return(TQmean)
}
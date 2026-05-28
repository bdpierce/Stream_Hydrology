# ------------------------------------------------------------------------------
# Purpose: Creates a function to calculate the Richards-Baker Index for stream flashiness
# Author: Brianna Pierce
# Email: bpierce@bellevuewa.gov
# ------------------------------------------------------------------------------

# *** The Richards-Baker Index (RBI) is a dimensionless index of flow 
#     oscillations relative to total flow, based on daily average discharge 
#     measured during a water year.
# *** RBI is computed by dividing the sum of the absolute day-to-day changes in 
#     mean daily discharge (or stage) by the sum of the daily mean over the WY.


# For development only: get the data
# source("00_getStage.R")
# daily <- getStage(aggregation_unit = "day")
# daily_data <- daily
# View(daily_data)

# Required Packages ------------------------------------------------------------
require(dplyr)

# Create a function to calculate the RBI ---------------------------------------

calcRBI <- function(daily_data){
  
  # Calculate the absolute differences in daily average stage
  daily_data <- daily_data %>%
    group_by(Gauge, WY) %>% 
    arrange(datetime, .by_group = T) %>% 
    mutate(stage_diff = abs(Stage_ft - lag(Stage_ft))) %>%
    na.omit()  # Remove NA values resulting from the lag 
  
  # Calculate RBI
  rbi <- daily_data %>% 
    summarize(RBI = sum(stage_diff, na.rm=T)/sum(Stage_ft),
              SampledDays = sum(!is.na(Stage_ft))+1,  # Because stage_diff includes a lag, one row for each WY will be NA and is removed. Thus, we need to add 1 to get a correct sample completeness.
              PercentComplete = round((sum(!is.na(Stage_ft))+1)/yday(paste0(max(WY), "-12-31"))*100, 1))
  
  return(rbi)
}


# Test the function
#calcRBI(daily)

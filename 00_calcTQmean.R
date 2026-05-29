# ------------------------------------------------------------------------------
# Purpose: Creates a function to calculate TQmean
# Author: Brianna Pierce
# Email: bpierce@bellevuewa.gov
# ------------------------------------------------------------------------------

# *** TQmean is the fraction of time during a water year that the daily average 
#     stage or discharge is greater than the annual average value of that year.


# Load required packages -------------------------------------------------------
require(dplyr)

# Create a function to calculate the TQmean ------------------------------------
calcTQmean <- function(daily_data) {
  
  # Calculate the mean stage per WY per gauge
  daily_data <- daily_data %>% 
    group_by(Gauge, WY) %>% 
    mutate(WY_avg_stage = mean(Stage_ft, na.rm = T))
  
  # Flag values greater than the annual mean
  daily_data$tqm_flag <- if_else(daily_data$Stage_ft > daily_data$WY_avg_stage, 1, 0)
  
  # Calculate the proportion of daily averages over the mean daily average stage
  # And include a summary of sample completeness
  TQmean <- daily_data %>% 
    summarize(TQmean = sum(tqm_flag, na.rm=T)/sum(!is.na(Stage_ft)), 
              SampledDays = sum(!is.na(Stage_ft)),
              WYPercentComplete = round(sum(!is.na(Stage_ft))/yday(paste0(max(WY), "-12-31"))*100, 1) )
  
  return(TQmean)
}


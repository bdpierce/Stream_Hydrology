# ------------------------------------------------------------------------------
# Purpose: Creates a function to calculate the stream stage reversals
# Author: Brianna Pierce
# Email: bpierce@bellevuewa.gov
# ------------------------------------------------------------------------------

# *** Flow or stage reversals are the number of times that the stage or flow rate 
#     changed from an increase to a decrease or vice versa during a water year.
# *** This metric uses daily average data from Oct 1 to April 30 of the WY.


# Load required packages -------------------------------------------------------
require(dplyr)
require(lubridate)

# Create a function to calculate reversals -------------------------------------

calcReversals <- function(daily_data){
  
  # Detect flow reversals
  daily_data <- daily_data %>%
    filter(month(datetime) %in% c(1,2,3,4,10,11,12)) %>%  # trim data to Oct 1 to April 30
    group_by(Gauge, WY) %>% 
    arrange(datetime, .by_group = T) %>% 
    mutate(stage_diff = Stage_ft - lag(Stage_ft)) %>%     # calculate the difference in daily average stage
    mutate(direction = sign(stage_diff)) %>%              # determine if stage is increasing or decreasing
    mutate(reversal_flag = ifelse(abs(direction - lag(direction)) == 2, 1, NA )) # flag reversals
  
  # Tally reversals and report sample completeness
  revs <- daily_data %>% 
    summarise(Reversals = sum(reversal_flag, na.rm = T),
              SampledDays = sum(!is.na(Stage_ft)),
              PercentComplete = round(sum(!is.na(Stage_ft))/(1+as.integer(difftime(ymd(paste0(max(year(datetime)), "-4-30")), ymd(paste0(min(year(datetime)), "-10-01")))))*100, 1) )
  return(revs)
}


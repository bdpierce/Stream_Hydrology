# Purpose: Creates a function to calculate the Richards-Baker Index for stream flashiness
# Author: Brianna Pierce
# Email: bpierce@bellevuewa.gov
# Created: 2026-05-27
# Revised: 2026-05-27
# ------------------------------------------------------------------------------

# *** The Richards-Baker Index (RBI) is a dimensionless index of flow 
#     oscillations relative to total flow, based on daily average discharge 
#     measured during a water year.

# For development only: get the data
# source("00_getStage.R")
# daily <- getStage(aggregation_unit = "day")
# daily_data <- daily
# View(daily_data)

# Required Packages ------------------------------------------------------------
# require(dplyr)
# require(tidyr)
# require(lubridate)
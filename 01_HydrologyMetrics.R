# ------------------------------------------------------------------------------
# Purpose: Assembles the Tqmean, RBI, and flow reversal metrics from discharge and stage data
# Author: Brianna Pierce
# Email: bpierce@bellevuewa.gov
# ------------------------------------------------------------------------------

# Source code to get functions -------------------------------------------------
source("00_getStage.R")
source("00_calcTQmean.R")
source("00_calcRBI.R")
source("00_calcReversals.R")

# Get the data -----------------------------------------------------------------
daily <- getStage(aggregation_unit = "day")


# 1. Calculate Tqmean ----------------------------------------------------------
tqm <- calcTQmean(daily_data = daily)

# 2. Calculate Richards Baker Flashiness Index (RBI) ---------------------------
rbi <- calcRBI(daily_data = daily)

# 3. Calculate reversals -------------------------------------------------------
rev <- calcReversals(daily_data = daily)


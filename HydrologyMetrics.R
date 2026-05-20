# ------------------------------------------------------------------------------
# Title: Stream hydrology metrics
# Purpose: Computes Tqmean, RBI, and flow reversal metrics from discharge and stage data
# Author: Brianna Pierce
# Email: bpierce@bellevuewa.gov
# Created: 2026-05-19
# Revised: 2026-05-19
# ------------------------------------------------------------------------------

# Load Packages ----------------------------------------------------------------

# 1. Tqmean


# 2. Richards Baker Flashiness Index (RBI)

#' Baker, D.B., R.P. Richards, T.T. Loftus, and J.W. Kramer.  2004.  A New Flashiness Index:
#' Characteristics and Applications to Midwestern Rivers and Streams.  April 2004.
#' Journal of the American Water Resources Association (JAWRA).  Pages 503:522.

RBIcalc <- function(Q){
  
  time.start <- proc.time();
  
  # Size
  myLen <- length(Q)
  
  # Add previous record in second column
  Qprev <- c(NA,Q[-myLen])
  
  # Create dataframe.
  myData <- as.data.frame(cbind(Q,Qprev))
  
  # delta (absolute)
  myData[,"AbsDelta"] <- abs(myData[,"Q"] - myData[,"Qprev"])
  
  # SumQ
  SumQ <- sum(myData[,"Q"],na.rm=TRUE)
  
  # Sum Delta
  SumDelta <- sum(myData[,"AbsDelta"], na.rm=TRUE)
  
  #
  RBIsum <- SumDelta / SumQ
  
  time.elaps <- proc.time()-time.start
  # cat(c("Rarify of samples complete. \n Number of samples = ",nsamp,"\n"))
  # cat(c(" Execution time (sec) = ", elaps[1]))
  # flush.console()
  
  # Return RBI value for data submitted.
  return(RBIsum)
  #
} 


# 3. Flow reversals


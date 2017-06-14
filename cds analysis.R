# load libraries ####

# load local R files
source("functions.R")
source("parameters.R")

# main function ####

# set seed
set.seed(2038)

reps <- 10
lapply(
   c("NO_CDS", "CDS"),
   replicate(reps, decisionCDSImpliment(parameters, x)),
   parameters = parameters
)


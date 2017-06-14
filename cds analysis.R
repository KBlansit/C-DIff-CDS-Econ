# load libraries ####

# load local R files
source("functions.R")
source("parameters.R")

# main function ####

# set seed
set.seed(2039)

reps <- 99999
stratificaiton <- c("NO_CDS", "CDS")

# apply function
results <- lapply(
  stratificaiton,
  mainFunctionWrapper,
  parameters = parameters,
  reps = reps
)

names(results) <- stratificaiton
df <- as.data.frame(results)



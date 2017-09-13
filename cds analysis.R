# load libraries ####
require(yaml)

# load local R files
source("src/functions.R")

# main function ####

# set seed
set.seed(2039)

# load parameters
parameters <- yaml.load_file("parameters.yaml")

# initialize simulation parameters
reps <- 9999
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

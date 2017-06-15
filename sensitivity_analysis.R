# load libraries ####

# load local R files
source("src/functions.R")
source("src/one_way_sensitivity.R")

# initilaize parameters ####

# set seed
set.seed(82765)

# load parameters
parameters <- yaml.load_file("parameters.yaml")

# initialize simulation parameters
reps <- 999

# one way sensitivity for chance values
prob_names = c(
  "pPositiveResult",
  "pFalsePositiveNoCDS",
  "pFalsePositiveYesCDS",
  "pFalseNegativeNoCDS",
  "pFalseNegativeYesCDS"
)

prob_range <- seq(0., 1., by = 0.1)

# run one way sensitivity for chance vars
prob_results <- lapply(
  prob_names,
  oneWaySensitivityAnalysis,
  parameters = parameters,
  d_range = prob_range,
  reps = reps
)


#oneWaySensitivityAnalysis("ctruenegative", parameters, seq(0, 10000, by=1000), 99)

#dollar_names

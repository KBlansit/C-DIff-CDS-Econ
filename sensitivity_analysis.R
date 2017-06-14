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
reps <- 99

# one way sensitivity for chance values
prob_names = c(
  "pPositiveResult",
  "pFalsePositiveNoCDS",
  "pFalsePositiveYesCDS",
  "pFalseNegative"
)

prob_range <- seq(0., 1., by = 0.1)

autoRunSensitivity(prob_names, prob_range, parameters, reps)

cost_names = c(
  "cBaseCostCDiffTx",
  "cFalsePositiveInf",
  "cFalseNegativeInf",
  "cTrueNegative",
  "cTestCost",
  "cBPAImpliment"
)

cost_range <- seq(0, 10000, by = 1000)

autoRunSensitivity(cost_names, cost_range, parameters, reps)


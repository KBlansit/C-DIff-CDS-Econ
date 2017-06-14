# load libraries ####

# load local R files
source("src/functions.R")
source("src/one_way_sensitivity.R")

# load parameters
parameters <- yaml.load_file("parameters.yaml")

# example code

# test negativeTest
replicate(5, negativeTest(parameters))

# test positiveTest
replicate(5, positiveTest(parameters, "NO_CDS"))
replicate(5, positiveTest(parameters, "CDS"))

# test cdiff test
replicate(5, cDiffTest(parameters, "NO_CDS"))
replicate(5, cDiffTest(parameters, "CDS"))

# test decision part
replicate(10, decisionCDSImpliment(parameters, "NO_CDS"))
replicate(10, decisionCDSImpliment(parameters, "CDS"))

# test primary wrapper
oneWaySensitivityAnalysis("cTrueNegative", parameters, seq(0, 10000, by=1000), 999)

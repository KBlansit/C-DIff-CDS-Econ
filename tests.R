# load libraries ####

# load local R files
source("functions.R")

# example code
yaml.load_file("parameters.yaml")->parameters

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

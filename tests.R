# load libraries ####

# load local R files
source("functions.R")
source("parameters.R")

# example code

# test negativeTest
replicate(5, negativeTest(parameters))

# test positiveTest
replicate(5, positiveTest("NO_CDS", parameters))
replicate(5, positiveTest("CDS", parameters))

# test cdiff test
replicate(5, cDiffTest("NO_CDS", parameters))
replicate(5, cDiffTest("CDS", parameters))

replicate(10, decisionCDSImpliment("NO_CDS", parameters))
replicate(10, decisionCDSImpliment("CDS", parameters))

# parameters####
# set parameters to hash
parameters<- list(
  # cost parameters
    
  cBaseCostCDiffTx = 4000,
  
  cFalsePositiveInflatorMin = -1500,
  cFalsePositiveInflatorMode = -100,
  cFalsePositiveInflatorMax = -500,
  
  cFalseNegativeInflatorMin = -500,
  cFalseNegativeInflatorMode = 250,
  cFalseNegativeInflatorMax = 1000,
  
  cTrueNegative = 0,
  
  # test results
  pPositiveResult = 0.4,
  
  pFalsePositiveNoCDS = 0.4,
  pFalsePositiveYesCDS = 0.4,
  
  pFalseNegative = 0.5
  
)

set.seed(2038)
# main function

# example code
replicate(5, negative(parameters))
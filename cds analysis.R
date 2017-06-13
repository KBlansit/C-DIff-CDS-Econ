
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



negative <- function(parameters){
  # case when false negative
  if(runif(1, min=0, max=1) >= parameters$pFalseNegative) {
    # base cost
    cBaseCost <- parameters$cBaseCostCDiffTx
    
    # false negative inflator 
    cNegativeInflator <- rtriangle(1,
      parameters$cFalseNegativeInflatorMin,
      parameters$cFalseNegativeInflatorMax,
      parameters$cFalseNegativeInflatorMode
    )
    
    # sum up
    totalCost <- cBaseCost + cNegativeInflator
  }
  # case when true negative
  else{
    # base cost
    totalCost <- parameters$cTrueNegative
  }
  return(totalCost)
}

# example code
replicate(5, negative(parameters))
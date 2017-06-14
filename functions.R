# load libraries ####
require(triangle)

# functions ####
positiveTest <- function(state, parameters){
  # determine which probability to use
  
  # use for no CDS case
  if(state == "NO_CDS"){
    pFalsePositive <- parameters$pFalsePositiveNoCDS
  # use for CDS case
  } else if(state == "CDS"){
    pFalsePositive <- parameters$pFalsePositiveYesCDS
  }
  
  # case when false positive
  if(runif(1, min=0, max=1) >= pFalsePositive) {
    # base cost
    cBaseCost <- parameters$cBaseCostCDiffTx
    
    # false negative inflator 
    cFalsePositiveInflator <- rtriangle(1,
      parameters$cFalsePositiveInflatorMin,
      parameters$cFalsePositiveInflatorMax,
      parameters$cFalsePositiveInflatorMode
    )
    
    # sum up
    totalCost <- cBaseCost + cFalsePositiveInflator
  }
  # case when true negative
  else{
    # base cost
    totalCost <- parameters$cBaseCostCDiffTx
  }
  return(totalCost)
}

negativeTest <- function(parameters){
  # case when false negative
  if(runif(1, min=0, max=1) >= parameters$pFalseNegative) {
    # base cost
    cBaseCost <- parameters$cBaseCostCDiffTx
    
    # false negative inflator 
    cFalseNegativeInflator <- rtriangle(1,
      parameters$cFalseNegativeInflatorMin,
      parameters$cFalseNegativeInflatorMax,
      parameters$cFalseNegativeInflatorMode
    )
    
    # sum up
    totalCost <- cBaseCost + cFalseNegativeInflator
  }
  # case when true negative
  else{
    # base cost
    totalCost <- parameters$cTrueNegative
  }
  return(totalCost)
}

cDiffTest <- function(state, parameters){
  if(runif(1, min=0, max=1) >= parameters$pPositiveResult){
    result <- positiveTest(state, parameters) + parameters$cTestCost
  }
  else{
    result <- negativeTest(parameters) + parameters$cTestCost
  }
  
  return(result)
}

decisionCDSImpliment <- function(state, parameters){
  # use for no CDS case
  if(state == "NO_CDS"){
    result <- 0
  # use for CDS case
  } else if(state == "CDS"){
    result <- parameters$cBPAImpliment
  }
  result <- result + cDiffTest(state, parameters)
  return(result)
}
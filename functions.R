# load libraries ####
require(triangle)
require(assertthat)

# functions ####
triangleWrapper <- function(parameters) {
  # assertions
  stopifnot(!is.null(parameters[["min"]]))
  stopifnot(!is.null(parameters[["max"]]))
  stopifnot(!is.null(parameters[["mode"]]))
  
  # return random value
  return(rtriangle(1, parameters$min, parameters$max, parameters$mode))
}

distributionWrapper <- function(parameters){
  # distribution: triangle
  # min
  # mode
  # max
  #
  # distribution: guassian
  # mean
  # sd
  #
  # distribution: point
  # point
  
  # triangle
  if(parameters$distribution == "triangle"){
    return(triangleWrapper(parameters))
    
  # guassian
  } else if(parameters$distribution == "guassian"){
    
  }
}

positiveTest <- function(parameters, state){
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
    cFalsePositiveInflator <- triangleWrapper(parameters$cFalsePositiveInf)
      
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
    cFalseNegativeInflator <- triangleWrapper(parameters$cFalseNegativeInf)
    
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

cDiffTest <- function(parameters, state){
  if(runif(1, min=0, max=1) >= parameters$pPositiveResult){
    result <- positiveTest(parameters, state) + parameters$cTestCost
  }
  else{
    result <- negativeTest(parameters) + parameters$cTestCost
  }
  
  return(result)
}

decisionCDSImpliment <- function(parameters, state){
  # use for no CDS case
  if(state == "NO_CDS"){
    result <- 0
  # use for CDS case
  } else if(state == "CDS"){
    result <- parameters$cBPAImpliment
  }
  result <- result + cDiffTest(parameters, state)
  return(result)
}

mainFunctionWrapper <- function(state, parameters, reps){
  return(replicate(reps, decisionCDSImpliment(parameters, state)))
}

oneWaySensitivityAnalysis <- function(parameter) {
  # to allow multiple 
}
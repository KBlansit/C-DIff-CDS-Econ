# load custom libraries ####
source('src/wrapper_functions.R')



# set disease result
if(runif(1, min=0, max=1) >= pPositiveDisease) {
    disease = "POSITIVE"
}

if (disease == "POSITIVE") {
    cost <- distributionWrapper(parameters$cPositiveDiseaseTreatPositiveTest)
} else {
    
}






    # case when treat
    if(test_strategy == "TREAT") {
        # get prob
        pPositiveDisease <- distributionWrapper(parameters$pPositiveDiseaseTreatPositiveTestCDS)
        
        #  determine if positive disease
        if(runif(1, min=0, max=1) >= pFalsePositive) {
        } else {
            cost <- distributionWrapper(parameters$cNegativeDiseaseTreatPositiveTest)
        }
        
    # case when no treat
    } else if(test_strategy == "NO_TREAT") {
        # get prob
        pPositiveDisease <- distributionWrapper(parameters$pPositiveDiseaseNoTreatPositiveTestCDS)
        
        #  determine if positive disease
        if(runif(1, min=0, max=1) >= pFalsePositive) {
            cost <- distributionWrapper(parameters$cPositiveDiseaseTreatNegativeTest)
        } else {
            cost <- distributionWrapper(parameters$cNegativeDiseaseTreatNegativeTest)
        }
    }




negativeTest <- function(parameters, state) {
    # initialize cost
    totalCosts <- 0
    
    # case when treat
    if(state == "TREAT") {
        # get prob
        pPositiveDisease <- distributionWrapper(parameters$pPositiveDiseaseTreat)
        
        #  determine if positive disease
        if(runif(1, min=0, max=1) >= pFalsePositive) {
            cost <- distributionWrapper(parameters$cPositiveResultTreat)
        }
        
    # case when no treat
    } else if(state == "NO_TREAT") {
        # get prob
        pPositiveDisease <- distributionWrapper(parameters$pPositiveDiseaseNoTreat)
        
        #  determine if positive disease
        if(runif(1, min=0, max=1) >= pFalsePositive) {
            cost <- distributionWrapper(parameters$cPositiveResultNoTreat)
        }
    }

    return(cost)
}


######
positiveTest <- function(parameters, state) {
  # determine which probability to use
  
  # use for no CDS case
  if(state == "NO_CDS"){
    pFalsePositive <- distributionWrapper(parameters$pFalsePositiveNoCDS)
  # use for CDS case
  } else if(state == "CDS"){
    pFalsePositive <- distributionWrapper(parameters$pFalsePositiveYesCDS)
  }
  
  # case when false positive
  if(runif(1, min=0, max=1) >= pFalsePositive) {
    # base cost
    cBaseCost <- distributionWrapper(parameters$cBaseCostCDiffTx)
    
    # false negative inflator 
    cFalsePositiveInflator <- distributionWrapper(parameters$cFalsePositiveInf)
      
    # sum up
    totalCost <- cBaseCost + cFalsePositiveInflator
  }
  # case when true negative
  else{
    # base cost
    totalCost <- distributionWrapper(parameters$cBaseCostCDiffTx)
  }
  return(totalCost)
}

negativeTest <- function(parameters, state){
  # determine which probability to use
  
  # use for no CDS case
  if(state == "NO_CDS"){
    pFalseNegative <- distributionWrapper(parameters$pFalseNegativeNoCDS)
  # use for CDS case
  } else if(state == "CDS"){
    pFalseNegative <- distributionWrapper(parameters$pFalseNegativeYesCDS)
  }
  
  # case when false positive
  if(runif(1, min=0, max=1) >= pFalseNegative) {
    # base cost
    cBaseCost <- distributionWrapper(parameters$cBaseCostCDiffTx)
    
    # false negative inflator 
    cFalseNegativeInflator <- distributionWrapper(parameters$cFalseNegativeInf)
      
    # sum up
    totalCost <- cBaseCost + cFalseNegativeInflator
  }
  # case when true negative
  else{
    # base cost
    totalCost <- distributionWrapper(parameters$cBaseCostCDiffTx)
  }
  return(totalCost)
}

cDiffTest <- function(parameters, state){
  if(runif(1, min=0, max=1) >= distributionWrapper(parameters$pPositiveResult)) {
    result <- positiveTest(parameters, state) + distributionWrapper(parameters$cTestCost)
  }
  else{
    result <- negativeTest(parameters, state) + distributionWrapper(parameters$cTestCost)
  }
  
  return(result)
}

decisionCDSImpliment <- function(parameters, state){
  # use for no CDS case
  if(state == "NO_CDS"){
    result <- 0
  # use for CDS case
  } else if(state == "CDS"){
    result <- distributionWrapper(parameters$cBPAImpliment)
  }
  result <- result + cDiffTest(parameters, state)
  return(result)
}

mainFunctionWrapper <- function(state, parameters, reps){
  return(replicate(reps, decisionCDSImpliment(parameters, state)))
}


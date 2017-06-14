parameters<- list(
  # cost parameters
    
  cBaseCostCDiffTx = 4000,
  
  cFalsePositiveInf = list(
    min = -1500,
    mode = -500,
    max = -100
  ),
  
  cFalseNegativeInf = list(
    min = -500,
    mode = 250,
    max = 1000
  ),
  
  cTrueNegative = 0,
  
  # test results
  pPositiveResult = 0.4,
  
  pFalsePositiveNoCDS = 0.4,
  pFalsePositiveYesCDS = 0.4,
  
  pFalseNegative = 0.5,
  
  cTestCost = 400,
  cBPAImpliment = 6000
  
)
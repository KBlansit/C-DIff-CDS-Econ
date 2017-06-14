# load custom libraries ####
source('src/functions.R')

setParametersToPoints <- function(tmp_parameters, var_name) {
  # change all parameters to point parameters
  for (curr_name in names(tmp_parameters)) {
    # changes distribution to a point
    # 
    # triangle: (min + max + mode) / 3
    # guassian: mean
    # point: point
    
    # set curr parameter
    curr_param <- tmp_parameters[[curr_name]]
    
    # triangle
    if (curr_param$distribution == "triangle") {
      # calculate point
      point <- curr_param$min + curr_param$max + curr_param$mode
      point <- point/3
      
    # guassian
    } else if (curr_param$distribution == "mean") {
      # calculate point
      point <- curr_param$mean
      
    # point
    } else if (curr_param$distribution == "point") {
      # calculate point
      point <- curr_param$point
    }
    
    tmp_parameters[[curr_name]] <- list(distribution = "point", point = point)
  }
  
  return(tmp_parameters)
}

runSensitivityWrapper <- function(value, var_name, tmp_parameters, reps) {
  # set value for sensitive parameter
  tmp_parameters[[var_name]]$point <- value
  
  # run function
  stratificaiton <- c("NO_CDS", "CDS")
  
  # apply function
  results <- lapply(
    stratificaiton,
    mainFunctionWrapper,
    parameters = tmp_parameters,
    reps = reps
  )
  
  # convert to dataframe and 
  names(results) <- stratificaiton
  df <- as.data.frame(results)
  df <- cbind(df, list(value = value))
  
  return(df)
}

oneWaySensitivityAnalysis <- function(var_name, parameters, d_range, reps) {
  # set parameters to point
  tmp_parameters <- setParametersToPoints(parameters, var_name)
  
  # run analyses
  sensitive_rslt <- lapply(
    d_range,
    runSensitivityWrapper,
    var_name = var_name,
    tmp_parameters = tmp_parameters,
    reps = reps
  )
  
  # combine results
  df <- do.call(rbind, sensitive_rslt)
  
  return(df)
}
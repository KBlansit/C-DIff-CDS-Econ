# load libraries ####
require(dplyr)
require(tidyr)
require(tibble)
require(magrittr)

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

summarizeSensitivityResults <- function(df, reps) {
  # returns delta delta
  
  # transform to wide
  long_df <- gather(df, CDS, cost, NO_CDS, CDS)
  
  # add by group
  median_df <- long_df %>%
    group_by(CDS, value) %>%
    summarise(sum= sum(cost))
  
  wide_df <- spread(median_df, CDS, sum)
  
  wide_df$av_diff = (wide_df$CDS - wide_df$NO_CDS)/reps
  
  # return range of values
  diff_df <- wide_df %>% filter(value %in% range(value)) %>% select(av_diff)
  delta <- diff(diff_df$av_diff)
  
  return(delta)
}

autoRunSensitivity <- function(var_names, d_range, parameters, reps) {
  # wrapper function
  
  # run one way sensitivity for chance vars
  sensitivities <- lapply(
    var_names,
    oneWaySensitivityAnalysis,
    parameters = parameters,
    d_range = d_range,
    reps = reps
  )

  # return to list
  lst_summary <- lapply(sensitivities, summarizeSensitivityResults, reps=reps)
  names(lst_summary) <- var_names
  
  # convert to df
  df <- as.data.frame(t(as.data.frame(lst_summary)))
  
  # extract var names
  df$var <- rownames(df) 
  rownames(df) <- NULL
  names(df) <- c("diff", "var")
  
  return(df)
}
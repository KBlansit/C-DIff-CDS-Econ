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

guassianWrapper <- function(parameters) {
  # assertions
  stopifnot(!is.null(parameters[["mean"]]))
  stopifnot(!is.null(parameters[["sd"]]))
  
  return(rnorm(1, mean, sd))
}

pointWrapper <- function(parameters) {
  # assertions
  stopifnot(!is.null(parameters[["point"]]))
  
  return(parameters$point)
}

distributionWrapper <- function(parameters) {
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
    return(guassianWrapper(parameters))
    
  # point
  } else if(parameters$distribution == "point"){
    return(pointWrapper(parameters))
    
  }
}
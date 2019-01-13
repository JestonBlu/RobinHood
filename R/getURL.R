#' Get the URL for the RobinHood API Endpoints
#' 
#' @param endpoint which api endpoint to look up?
getURL = function(endpoint) {
  
  api.endpoint = list(
    url = "https://api.robinhood.com/",
    token = "oauth2/token/",
    revoke_token = "oauth2/revoke_token/",
    accounts = "accounts/"
  ) 
  
  x = which(names(api.endpoint) == endpoint)
  
  ep = paste(api.endpoint$url, as.character(api.endpoint[x]), sep = "")
  
  return(ep)
}

#' RobinHood API: User
#'
#' Backend function called by get_user() to return user data
#'
#' @param RH object of class RobinHood
#' @import httr magrittr
#' @export
api_user <- function(RH) {

  # URL and token
  url <- api_endpoints("user")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url, add_headers("Accept" = "application/json", "Authorization" = token))
  httr::stop_for_status(dta)
  
  # format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.list(dta)

  return(dta)
}

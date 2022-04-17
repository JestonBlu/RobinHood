#' RobinHood API: Historicals crypto
#'
#' Backend function called by get_historicals_crypto(). Returns a data frame of historical price data.
#'
#' @param RH object of class RobinHood
#' @param url (string) full url coming from get_historicals_crypto
#' @import httr magrittr
#' @export
api_historicals_crypto <- function(RH, url) {

  # url to get historical data
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(dta)
  
  # Format return
  dta <- RobinHood::mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta$data_points)

  return(dta)
}

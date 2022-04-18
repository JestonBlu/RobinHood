#' RobinHood API: Historicals
#'
#' Backend function called by get_historicals(). Returns a data frame of historical price data.
#'
#' @param RH object of class RobinHood
#' @param historicals_url (string) api url
#' @param body (string) api body
#' @import httr magrittr
#' @export
api_historicals <- function(RH, historicals_url, body) {

  # URL and token
  url <- paste(historicals_url, "?", body, sep = "")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(dta)

  # Format return
  dta <- RobinHood::mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta$results$historicals)

  dta <- dta %>%
    dplyr::mutate_at(c("open_price", "close_price", "high_price", "low_price", "volume"), as.numeric) %>%
    dplyr::mutate_at("begins_at", lubridate::ymd_hms)

  return(dta)
  }

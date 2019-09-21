#' RobinHood API: Historicals
#'
#' Backend function called by get_historicals(). Returns a data frame of historical price data.
#'
#' @param RH object of class RobinHood
#' @param historicals_url (string) api url
#' @param body (string) api body
#' @import curl magrittr
#' @export
api_historicals <- function(RH, historicals_url, body) {

  # URL and token
  url <- paste(historicals_url, "?", body, sep = "")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- httr::GET(url,
    httr::add_headers("Accept" = "application/json",
                "Content-Type" = "application/json",
                "Authorization" = token))

  # Format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta$results$dta)

  dta <- dta %>%
    dplyr::mutate_at(c("open_price", "close_price", "high_price", "low_price"), as.numeric) %>%
    dplyr::mutate_at("begins_at", lubridate::ymd_hms)

  return(dta)
  }

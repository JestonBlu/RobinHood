#' RobinHood API: Analyst ratings
#'
#' Backend function called by get_ratings() to get analyst rating from RobinHood
#'
#' @param RH object of class RobinHood
#' @param symbol (string)
#' @import httr magrittr
#' @export
api_ratings <- function(RH, symbol) {

  # URL and token
  token <- paste("Bearer", RH$tokens.access_token)
  instrument_id <- api_instruments(RH, symbol)
  instrument_id <- instrument_id$results$id

  url <- paste(api_endpoints("ratings"), instrument_id, sep = "")

  # GET call
  dta <- GET(url, add_headers("Accept" = "application/json", "Authorization" = token))
  httr::stop_for_status(dta)
  
  # format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.list(dta$results)

  dta <- list(
    buy_percent = dta$summary$num_buy_ratings / sum(dta$summary),
    summary = dta$summary,
    comments = dta$ratings %>% data.frame
  )

  return(dta)
}

#' Get market hours for a specific date
#'
#' Get a list of markets
#'
#' @param RH object of class RobinHood
#' @param market_date (string) date in the form 'yyyy-mm-dd', default today
#' @import curl jsonlite magrittr lubridate
#' @export
get_market_hours <- function(RH, market_date = NULL) {

  # If no date is provided, use todays date
  if (is.null(market_date)) market_date <- suppressWarnings(today())

  # Get market information
  markets <- api_markets(RH, api_endpoints("markets"))

  # Replace url with the overidden date
  market_hours_url <- gsub(suppressWarnings(today()), market_date, markets$todays_hours)

  # Empty data frame to collect results
  market_hours <- data.frame()

  for (i in market_hours_url) {
      x <- api_markets(RH, i, type = 'list')
      x <- x %>% data.frame
      market_hours = rbind(market_hours, x)
  }

  # Keep relevant columns
  markets = markets[, c("name", "acronym", "city", "website", "timezone")]
  market_hours = market_hours[, c("opens_at", "closes_at", "extended_opens_at", "extended_closes_at", "is_open", "date")]

  # Adjust time format
  market_hours$opens_at <- strftime(ymd_hms(market_hours$opens_at), format = "%H:%M:%S")
  market_hours$closes_at <- strftime(ymd_hms(market_hours$closes_at), format = "%H:%M:%S")
  market_hours$extended_opens_at <- strftime(ymd_hms(market_hours$extended_opens_at), format = "%H:%M:%S")
  market_hours$extended_closes_at <- strftime(ymd_hms(market_hours$extended_closes_at), format = "%H:%M:%S")

  markets = cbind(markets, market_hours)

  return(markets)
}

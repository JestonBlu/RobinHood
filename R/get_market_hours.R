#' Get market hours
#'
#' Get a list of markets available on RobinHood with trading hours for a specific date.
#'
#' @param RH object of class RobinHood
#' @param market_date (string) date in the form 'yyyy-mm-dd', default today
#' @import curl jsonlite magrittr lubridate
#' @export
get_market_hours <- function(RH, market_date = NULL) {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  # If no date is provided, use todays date
  if (is.null(market_date)) market_date <- suppressWarnings(today())

  # Get market information
  markets <- api_markets(RH, api_endpoints("markets"))

  # Replace url with the overidden date
  market_hours_url <- gsub(suppressWarnings(today()), market_date, markets$todays_hours)

  # Empty data frame to collect results
  market_hours <- data.frame()

  for (i in market_hours_url) {

      x <- api_markets(RH, i, type = "list")
      # Look for nulls and replace with NA
      if (length(x$closes_at) == 0) x$closes_at <- NA
      if (length(x$extended_opens_at) == 0) x$extended_opens_at <- NA
      if (length(x$next_open_hours) == 0) x$next_open_hours <- NA
      if (length(x$previous_open_hours) == 0) x$previous_open_hours <- NA
      if (length(x$is_open) == 0) x$is_open <- NA
      if (length(x$extended_closes_at) == 0) x$extended_closes_at <- NA
      if (length(x$date) == 0) x$date <- NA
      if (length(x$opens_at) == 0) x$opens_at <- NA

      x <- x %>% data.frame

      market_hours <- rbind(market_hours, x)
  }

  # Keep relevant columns
  markets <- markets[, c("name", "acronym", "city", "website", "timezone")]
  market_hours <- market_hours[, c("opens_at", "closes_at", "extended_opens_at",
                                   "extended_closes_at", "is_open", "date")]

  # Adjust time format
  market_hours$opens_at <- strftime(ymd_hms(market_hours$opens_at), format = "%H:%M:%S")
  market_hours$closes_at <- strftime(ymd_hms(market_hours$closes_at), format = "%H:%M:%S")
  market_hours$extended_opens_at <- strftime(ymd_hms(market_hours$extended_opens_at), format = "%H:%M:%S")
  market_hours$extended_closes_at <- strftime(ymd_hms(market_hours$extended_closes_at), format = "%H:%M:%S")

  markets <- cbind(markets, market_hours)

  return(markets)
}

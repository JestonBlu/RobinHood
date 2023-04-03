#' Get open market hours
#'
#' Get a list of markets available on RobinHood with trading hours for a specific date.
#'
#' @param RH object of class RobinHood
#' @param market_date (string) date in the form 'yyyy-mm-dd', default today
#' @param tz (string) one of timezone returned by OlsonNames(), defaults to local
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_market_hours(RH)
#'}
get_market_hours <- function(RH, market_date = NULL, tz = Sys.timezone()) {

    # Check if RH is valid
    RobinHood::check_rh(RH)

    # If no date is provided, use todays date
    if (is.null(market_date)) market_date <- suppressWarnings(lubridate::today())

    # Get market information
    markets <- RobinHood::api_markets(RH, RobinHood::api_endpoints("markets"))

    # Replace url with the overidden date
    market_hours_url <- gsub(suppressWarnings(lubridate::today()), market_date, markets$todays_hours)

    # Empty data frame to collect results
    market_hours <- data.frame()

    for (i in market_hours_url) {

        x <- RobinHood::api_markets(RH, i, type = "list")

        # Look for nulls and replace with NA
        if (length(x$date) == 0) x$date <- NA
        if (length(x$is_open) == 0) x$is_open <- NA
        if (length(x$opens_at) == 0) x$opens_at <- NA
        if (length(x$closes_at) == 0) x$closes_at <- NA
        if (length(x$late_option_closes_at) == 0) x$late_option_closes_at <- NA
        if (length(x$extended_opens_at) == 0) x$extended_opens_at <- NA
        if (length(x$extended_closes_at) == 0) x$extended_closes_at <- NA
        if (length(x$all_day_opens_at) == 0) x$all_day_opens_at <- NA
        if (length(x$all_day_closes_at) == 0) x$all_day_closes_at <- NA
        if (length(x$previous_open_hours) == 0) x$previous_open_hours <- NA
        if (length(x$next_open_hours) == 0) x$next_open_hours <- NA

      x <- data.frame(x)

      market_hours <- rbind(market_hours, x)
    }

    # Keep relevant columns
    markets <- markets[, c("name", "acronym", "city", "website", "timezone")]
    market_hours <- market_hours[, c("opens_at", "closes_at", "extended_opens_at", "extended_closes_at", "is_open", "date")]

    # Overwrite timezone to match local or input
    markets$timezone <- tz

    # Format time
    market_hours <- market_hours %>%
      dplyr::mutate_at(c("opens_at", "closes_at", "extended_opens_at", "extended_closes_at"),
                       function(x) lubridate::with_tz(lubridate::ymd_hms(x), tzone = tz))

    markets <- cbind(markets, market_hours)

    return(markets)
}

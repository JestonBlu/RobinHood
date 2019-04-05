#' Get porfolio summaries related to your RobinHood Account
#'
#' Returns a dataframe of portfolio summaries for a specific period of time. Default is current day.
#'
#' @param RH object of class RobinHood
#' @param interval (string) Interval of time to aggregate to (examples: hour, day, week, month)
#' @param span (string) Period of time you are interested in (examples: day, week, month, year)
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_portfolios(RH)
#' get_portfolios(RH, interval = "day", span = "3month")
#'}
get_portfolios <- function(RH, interval = NULL, span = NULL) {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  # Get account number
  account_number <- api_accounts(RH)
  account_number <- account_number$account_number

  # Construct URL for query
  if (is.null(interval) | is.null(span)) {
      porfolio_url <- api_endpoints("portfolios")
      portfolios <- api_portfolios(RH, porfolio_url)

      # reorder columns
      portfolios <- portfolios[, c("start_date", "unwithdrawable_grants", "excess_maintenance_with_uncleared_deposits",
                                 "excess_maintenance", "market_value", "withdrawable_amount", "last_core_market_value",
                                 "unwithdrawable_deposits", "extended_hours_equity", "excess_margin",
                                 "excess_margin_with_uncleared_deposits", "equity", "last_core_equity",
                                 "adjusted_equity_previous_close", "equity_previous_close", "extended_hours_market_value")]

    } else {
      porfolio_url <- paste(api_endpoints("portfolios"),
                            "/historicals/?account_number=", account_number,
                            "&interval=", interval,
                            "&span=", span,
                            sep = "")
      portfolios <- api_portfolios(RH, porfolio_url)

      # reorder columns
      portfolios <- portfolios[, c("begins_at", "adjusted_open_equity", "adjusted_close_equity", "open_equity",
                                   "close_equity", "open_market_value", "close_market_value", "net_return", "session")]

   }

  return(portfolios)

}

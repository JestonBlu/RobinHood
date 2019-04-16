#' Download all financial instruments available on RobinHood
#'
#' Get a dataframe of all listed companies including ticker symbols and tradeability indicators.
#'
#' @param RH object of class RobinHood
#' @param add_fundamentals (logical) if TRUE then return fundamental data (long run time)
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_tickers(RH)
#'}
get_tickers <- function(RH, add_fundamentals = FALSE) {

    if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

    tickers <- api_tickers(RH)

    tickers <- tickers[, c("symbol", "rhs_tradability", "country", "name", "state", "list_date")]

    tickers <- tickers[tickers$rhs_tradability == "tradable", ]

    symbols <- tickers$symbol

    if (add_fundamentals == TRUE) {
      # Stopwatch
      start_time <- proc.time()

      cat("Getting additional investment fundamentals...")

      fundamentals <- data.frame()

      for (i in 1:length(symbols)) {
          x <- get_fundamentals(RH, symbols[i])
          fundamentals <- rbind(fundamentals, x)

          if (i %in% seq(0, 15000, 50)) {
              profvis::pause(1)
          }
        }

      # Stopwatch
      end_time <- proc.time() - start_time

      cat("..........COMPLETE (", round(end_time[3] / 60, 2), "minutes)")
    }

    tickers <- dplyr::left_join(tickers, fundamentals, by = "symbol")

    return(tickers)
}

#' Download all financial instruments available on RobinHood
#'
#' Get a dataframe of all listed companies including ticker symbols and tradeability indicators.
#'
#' @param RH object of class RobinHood
#' @param add_fundamentals (logical) if TRUE then return fundamental data (long run time)
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_tickers(RH)
#'}
get_tickers <- function(RH, add_fundamentals = FALSE) {

    # Check if RH is valid
    check_rh(RH)

    # Call the tickers api to retrieve all stock symbols
    tickers <- api_tickers(RH)

    # limit columns and only return tradeable symbols
    tickers <- tickers[, c("symbol", "rhs_tradability", "country", "name", "state", "list_date")]
    tickers <- tickers[tickers$rhs_tradability == "tradable", ]


    # If fundamentals are requested
    if (add_fundamentals == TRUE) {

        # Create string of symbols to get fundamentals on
        symbols <- tickers$symbol

        # Stopwatch
        start_time <- proc.time()

        cat("Getting additional investment fundamentals...")

        fundamentals <- data.frame()

        # Get fundamentals on each symbol, with a 1 second delay every 50 calls
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

    # Join tickers and fundamentals
    tickers <- dplyr::left_join(tickers, fundamentals, by = "symbol")

    return(tickers)
}

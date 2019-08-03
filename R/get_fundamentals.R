#' Get fundamental investment statistics for a particular ticker symbol
#'
#' @param RH object of class RobinHood
#' @param ticker (string) vector of ticker symbols
#' @param include_description (logical) include a long description of the company (default: FALSE)
#' @import curl magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_fundamentals(RH, "CAT")
#'}
get_fundamentals <- function(RH, ticker, include_description = FALSE) {

    check_rh(RH)

    ticker <- paste(ticker, collapse = ",")

    fundamentals <- api_fundamentals(RH, ticker)

    x <- data.frame(
          open                   = NA,
          high                   = NA,
          low                    = NA,
          volume                 = NA,
          average_volume_2_weeks = NA,
          average_volume         = NA,
          high_52_weeks          = NA,
          dividend_yield         = NA,
          float                  = NA,
          low_52_weeks           = NA,
          market_cap             = NA,
          pb_ratio               = NA,
          pe_ratio               = NA,
          shares_outstanding     = NA,
          description            = NA,
          instrument             = NA,
          ceo                    = NA,
          headquarters_city      = NA,
          headquarters_state     = NA,
          sector                 = NA,
          industry               = NA,
          num_employees          = NA,
          year_founded           = NA,
          symbol                 = ticker
        )

    if (nrow(fundamentals) == 0) {
         fundamentals <- x
         fundamentals$symbol <- ticker
      }

    fundamentals$symbol <- ticker

    if (include_description == FALSE) {
        fundamentals <- fundamentals[, !names(fundamentals) %in% c("description", "instrument")]
      }

    return(fundamentals)
}

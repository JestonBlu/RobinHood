#' Get ticker symbols for popular tags on RobinHood
#'
#' Geta a data frame of ticker symbols and names linked to trending tags on the RobinHood website.
#'
#' @param RH object class RobinHood
#' @param tag (string) a hyphenated tag such as "100-most-popular"
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_tag(RH, "100-most-popular")
#'}
get_tag <- function(RH, tag) {

    # Check if RH is valid
    RobinHood::check_rh(RH)

    # Get a list of instrument IDs for a particular tag
    instrument_id <- RobinHood::api_tag(RH, tag)

    # Use instrument IDs to get the ticker symbol and name
    instruments <- c()

    for (i in instrument_id) {
      instrument <- RobinHood::api_instruments(RH, instrument_url = i)
      x <- ifelse(is.null(instrument$symbol), "", instrument$symbol)
      instruments <- c(instruments, x)
    }

    return(instruments)
  }

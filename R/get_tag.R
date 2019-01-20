#' Get ticker symbols for popular tags on RobinHood
#'
#' Geta a data frame of ticker symbols and names linked to trending tags on the RobinHood website.
#'
#' @param RH object class RobinHood
#' @param tag (string) a hyphenated tag such as "100-most-popular"
#' @import curl jsonlite magrittr
#' @export
get_tag <- function(RH, tag) {

    # Get a list of instrument IDs for a particular tag
    instrument_id <- api_tag(RH, tag)

    # Use instrument IDs to get the ticker symbol and name
    instruments <- c()

    for (i in 1:length(instrument_id)) {
      instrument <- api_instruments(RH, instrument_id[i])

      x <- ifelse(is.null(instrument$symbol), "", instrument$symbol)

      instruments <- c(instruments, x)
    }

    return(instruments)

}

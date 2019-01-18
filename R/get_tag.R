#' Get ticker symbols for popular tags on RobinHood
#'
#'
#' @param RH object class RobinHood
#' @param tag (string) a hyphenated tag such as "100-most-popular"
#' @import curl jsonlite magrittr
#' @export
get_tag <- function(RH, tag) {

    # Get a list of instrument IDs for a particular tag
    instrument_id <- api_tag(RH, tag)

    # Use instrument IDs to get the ticker symbol and name
    instruments <- data.frame()

    for (i in 1:length(instrument_id)) {
      instrument <- api_instruments(RH, instrument_id[i])

      x <- data.frame(simple_name = ifelse(is.null(instrument$simple_name), "", instrument$simple_name),
                      symbol = ifelse(is.null(instrument$symbol), "", instrument$symbol))

      instruments <- rbind(instruments, x)
    }

    return(instruments)

}

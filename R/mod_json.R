#' Converts a data frame to json minus the square brackets on the ends
#'
#' @param x dataframe intended for json conversoin
#' @param type (string) one of "fromJSON" or "toJSON"
#' @export
mod_json <- function(x, type) {

  if (type == "toJSON") {
    x <- x %>% 
      jsonlite::toJSON()

    x <- substr(x, 2, nchar(x) - 1)

    return(x)
  }

  if (type == "fromJSON") {

    x <- jsonlite::fromJSON(rawToChar(x$content))

    return(x)
  }

}

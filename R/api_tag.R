#' RobinHood API: Tag
#'
#' Get a list of instruments for a certain trending tag on RobinHood
#'
#' @param RH object of class RobinHood
#' @param tag (string) a hyphenated tag such as "100-most-popular"
#' @import curl jsonlite magrittr
api_tag <- function(RH, tag) {

  tag_url <- paste(api_endpoints("tags"), tag, "/", sep = "", collapse = "")

  # Log in, get access token
  tag <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = tag_url) %$% content %>%
    rawToChar %>%
    fromJSON %$% instruments

  return(tag)
}

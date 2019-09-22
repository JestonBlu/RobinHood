#' RobinHood API: Tag
#'
#' Backend function called by get_tag(). Returns a list of instrument ids.
#'
#' @param RH object of class RobinHood
#' @param tag (string) a hyphenated tag such as "100-most-popular"
#' @import curl magrittr
#' @export
api_tag <- function(RH, tag) {

  # URL and token
  url <- paste(api_endpoints("tags"), tag, "/", sep = "", collapse = "")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- httr::GET(url,
      httr::add_headers("Accept" = "application/json",
                  "Content-Type" = "application/json",
                  "Authorization" = token))

  # format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.list(dta$instruments)

  return(dta)
}

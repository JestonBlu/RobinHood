#' Cancel an ACH transfer from your RobinHood account
#'
#' @param RH object of class RobinHood
#' @param cancel_url (string) cancel url returned from initiating a transfer with place_ach_transfer()
#' @import httr magrittr
cancel_ach_transfer <- function(RH, cancel_url) {

  dta <- api_ach(RH, action = "cancel", cancel_url)

  ifelse(length(dta) == 0, message("Transfer cancelled"), message("Not able to cancel transfer"))

}

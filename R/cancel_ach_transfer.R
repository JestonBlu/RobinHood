#' Cancel an ACH transfer from your RobinHood account
#'
#' @param RH object of class RobinHood
#' @param cancel_url (string) cancel url returned from initiating a transfer with place_ach_transfer()
#' @import httr magrittr
#' @export
cancel_ach_transfer <- function(RH, cancel_url) {

  cancel_ach <- RobinHood::api_ach(RH, action = "cancel", cancel_url = cancel_url)

  if (length(cancel_ach) == 0) cat("Transfer Canceled \n")

  if (length(cancel_ach) >  0) {
    cat("Not able to verify cancelation, check get_ach(RH, action = 'status', ...)")
  }

}

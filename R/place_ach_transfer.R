#' Place an ACH transfer to and from your RobinHood account
#'
#' @param RH object of class RobinHood
#' @param action (string) one of "deposit", "withdraw"
#' @param amount (numeric) amount in dollars you want to deposit or withdraw
#' @param transfer_url (string) url of your linked account, output of get_ach(RH, "relationships")
#' @import httr magrittr
#' @export
place_ach_transfer <- function(RH, action, amount, transfer_url) {

  if(!action %in% c("deposit", "withdraw")) stop("Invalid action")

  ach_order <- api_ach(RH, action, amount, transfer_url = transfer_url)

  return(ach_order)

  }

#' Place an ACH transfer to and from your RobinHood account
#'
#' @param RH object of class RobinHood
#' @param action (string) one of "deposit", "withdraw"
#' @param amount (numeric) amount in dollars you want to deposit or withdraw
#' @param transfer_url (string) url of your linked account, output of get_ach(RH, "relationships")
#' @import httr magrittr
place_ach_transfer <- function(RH, action, amount, transfer_url) {

  if(!action %in% c("deposit", "withdraw")) stop("Invalid action")

  # URL and token
  url <- api_endpoints("ach_transfers")
  token <- paste("Bearer", RH$tokens.access_token)

  # Body of call
  detail <- data.frame(ach_relationship = transfer_url,
                       amount = amount,
                       direction = action)

  # Post call
  dta <- POST(url,
              add_headers("Accept" = "application/json",
                          "Content-Type" = "application/json",
                          "Authorization" = token),
              body = mod_json(detail, "toJSON")) %>%
    content(type = "json") %>%
    rawToChar() %>%
    jsonlite::fromJSON() %>%
    as.list()

  # Select elements
  dta <- list(
    status_url = dta$url,
    cancel_url = dta$cancel,
    amount = dta$amount,
    direction = dta$direction,
    state = dta$state,
    fees = dta$fees,
    scheduled = dta$scheduled,
    early_access_amount = dta$early_access_amount,
    rhs_state = dta$rhs_state,
    created_at = dta$created_at,
    updated_at = dta$updated_at,
    expected_sweep_at = dta$expected_sweep_at,
    expected_landing_date = dta$expected_landing_datetime
  )

  # Format return
  dta$amount <- as.numeric(dta$amount)
  dta$fees <- as.numeric(dta$fees)
  dta$early_access_amount <- as.numeric(dta$early_access_amount)
  dta$created_at <- lubridate::ymd_hms(dta$created_at)
  dta$updated_at <- lubridate::ymd_hms(dta$updated_at)
  dta$expected_sweep_at <- lubridate::ymd_hms(dta$expected_sweep_at)
  dta$expected_landing_date <- lubridate::ymd_hms(dta$expected_landing_date)

  return(dta)

  }

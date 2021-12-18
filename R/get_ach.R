#' Get ACH data from your RobinHood linked bank accounts
#'
#' @param RH object of class RobinHood
#' @param action (string) one of "transfers", "relationships", "schedules", "status"
#' @param status_url (string) URL returned by place_ach_transfer()
#' @import httr magrittr
#' @export
get_ach <- function(RH, action, status_url = NULL) {

  # Check for correctly spelled action
  if (!action %in% c("transfers", "relationships", "schedules", "status")) stop("Invalid action")

  # Get tranfer history
  if (action == "transfers") {

    # Get call
    dta <- RobinHood::api_ach(RH, action)

    # Select and format
    dta <- dta %>%
      dplyr::select(c("direction", "amount", "fees", "state", "scheduled", "created_at", "updated_at",
                      "expected_landing_datetime", "ach_relationship")) %>%
      dplyr::mutate_at(c("created_at", "updated_at", "expected_landing_datetime"), lubridate::ymd_hms) %>%
      dplyr::mutate_at(c("scheduled"), as.logical) %>%
      dplyr::mutate_at(c("amount", "fees"), as.numeric)

    # Strip out the URL from the bank account ID
    dta$ach_relationship <- gsub(RobinHood::api_endpoints("ach_relationships"), "", dta$ach_relationship)
    dta$ach_relationship <- gsub("/", "", dta$ach_relationship)

    # Rename columns
    colnames(dta)[names(dta) %in% c("expected_landing_datetime", "ach_relationship")] = c("expected_landing", "id")

    # Get Bank account name
    dta_relationships <- RobinHood::api_ach(RH, action = "relationships")

    # Pull only the columns needed
    dta_relationships <- dta_relationships %>%
      dplyr::select(c("id", "bank_account_nickname", "bank_account_type", "bank_account_number"))

    # Shorten names
    colnames(dta_relationships) <- gsub("bank_", "", names(dta_relationships))

    # Join bank acount name and holder to the transfer history
    dta <- dplyr::inner_join(dta, dta_relationships, by = "id")

    # Reorder columns
    dta <- dta %>%
      dplyr::select(c("account_nickname", "account_type", "account_number", "direction", "amount", "state", "fees",
                      "scheduled", "created_at", "updated_at", "expected_landing"))

  }


  # Get linked bank accounts
  if (action == "relationships") {

    # Get call
    dta <- RobinHood::api_ach(RH, action)

    # Clean up ordering and format
    dta <- dta %>%
      dplyr::select(c("bank_routing_number", "bank_account_number", "bank_account_type", "verified", "withdrawal_limit",
                      "state", "bank_account_holder_name","bank_account_nickname", "created_at", "unlinked_at",
                      "document_request", "verify_micro_deposits", "url")) %>%
      dplyr::mutate_at(c("created_at", "unlinked_at"), lubridate::ymd_hms) %>%
      dplyr::mutate_at(c("withdrawal_limit"), as.numeric) %>%
      dplyr::rename("transfer_url" = "url")

    # Shorten names
    colnames(dta) <- gsub("bank_", "", names(dta))
  }


  # Get schedeuled transfers
  if (action == "schedules") {

    # Get call
    dta <- RobinHood::api_ach(RH, action)

    # Check if the data frame is empty
    if (nrow(dta) == 0) stop("You have no schedules")


    # Clean up format
    dta <- dta %>%
      dplyr::mutate_at(c("next_deposit_date", "last_attempt_date"), lubridate::ymd) %>%
      dplyr::mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms) %>%
      dplyr::mutate_at(c("amount"), as.numeric)

    # Get bank id
    dta$ach_relationship <- gsub(RobinHood::api_endpoints("ach_relationships"), "", dta$ach_relationship)
    dta$ach_relationship <- gsub("/", "", dta$ach_relationship)

    # Get Bank account name
    dta_relationships <- RobinHood::api_ach(RH, action = "relationships")

    # Pull only the columns needed
    dta_relationships <- dta_relationships %>%
      dplyr::select(c("id", "bank_account_nickname", "bank_account_type", "bank_account_number")) %>%
      dplyr::rename("ach_relationship" = "id")

    # Shorten names
    colnames(dta_relationships) <- gsub("bank_", "", names(dta_relationships))

    # Join bank acount name and holder to the transfer history
    dta <- dplyr::inner_join(dta, dta_relationships, by = "ach_relationship")

    # Clean up columns
    dta <- dta %>%
      dplyr::select(c("account_nickname", "account_type", "account_number", "amount", "frequency", "next_deposit_date",
                      "last_attempt_date", "created_at", "updated_at"))
  }


  if (action == "status") {

    dta <- RobinHood::api_ach(RH, action, status_url = status_url)

  }

  return(dta)

}

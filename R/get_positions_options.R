#' Get the currently held positions for your RobinHood account
#'
#' @param RH object class RobinHood
#' @param trim_pending (logical) if FALSE, then return pending and intraday columns
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_positions_options(RH)
#'}
get_positions_options <- function(RH, trim_pending = TRUE) {

  # Check if RH is valid
  check_rh(RH)

  # Options postions
  options <- api_option_positions(RH)

  # Get option type, loop through URL
  x <- unique(options$option)

  options_instruments <- data.frame()

  # Look through option instruments to pull additional columns
  for (i in x) {
    y <- api_option_instruments(RH, i)

    y <- y %>%
      select(c("url", "type", "state", "strike_price", "rhs_tradability", "tradability")) %>%
      rename(c("option_type" = "type",
              "option" = "url"))

    options_instruments <- rbind(options_instruments, y)
  }

  # Join with option positions
  options <- inner_join(options, options_instruments, by = "option")

  # Trim columns
  if (trim_pending == TRUE) {

    options <- options %>%
      select(c("chain_symbol", "option_type", "state", "strike_price", "average_price", "quantity",
               "trade_value_multiplier", "rhs_tradability", "tradability", "type", "created_at", "updated_at")) %>%
      mutate_at(c("average_price", "quantity", "trade_value_multiplier", "strike_price"), as.numeric) %>%
      mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms)

    } else {

      options <- options %>%
      select(c("chain_symbol", "option_type", "state", "strike_price", "average_price", "quantity",
               "trade_value_multiplier", "pending_buy_quantity", "pending_expired_quantity", "pending_expiration_quantity",
               "pending_exercise_quantity", "pending_assignment_quantity", "pending_sell_quantity", "intraday_quantity",
               "intraday_average_open_price", "rhs_tradability", "tradability", "type", "created_at", "updated_at")) %>%
      mutate_at(c("average_price", "quantity", "trade_value_multiplier", "pending_buy_quantity", "pending_expired_quantity",
                  "pending_expiration_quantity", "pending_exercise_quantity", "pending_assignment_quantity",
                  "pending_sell_quantity", "intraday_quantity", "intraday_average_open_price",
                  "strike_price"), as.numeric) %>%
      mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms)
    }

  return(options)

  }

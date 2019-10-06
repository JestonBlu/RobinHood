## 1.2.1

#### Bug fixes
  - `place_orders_crypto()`: fixed a typo in the api url preventing it from working
  - `place_orders`: fixed an issue with limit orders that would not work without a `stop_price`
  - `cancel_order_crypto`: fixed a typo preventing it from working
  - `get_tickers`: fixed a typo preventing function from working
  - `logout`: fixed broken api


-----------------------------------------------------------------------------------------------------------------------------

## 1.2

#### New Features
  - Added functions for trading crypto currency:
    - `get_order_history_crypto()`
    - `place_order_crypto()`
    - `cancel_order_crypto()`
    - `cancel_order_crypto()`
    - `get_quote_crypto()`

#### Clean up
  - Fixed typo in `place_order()`
  - Changed from `curl` to `httr` for backend API calls
  - Fixed bad date format in `api_accounts`
  - Improved comments in code

-----------------------------------------------------------------------------------------------------------------------------

## 1.0.7

#### Bug fixes
  - fixed a change to the upstream login api

-----------------------------------------------------------------------------------------------------------------------------

## 1.0.6

#### New Features
  - added an optional output of `get_fundamentals()` to the output of `get_tickers()`

#### Clean up
  - `get_historicals()` now returns prices formatted as numeric
  - `get_fundamentals()` now returns as a data frame instead of a list

-----------------------------------------------------------------------------------------------------------------------------

## 1.0.5

#### Bug fixes
  - `get_positions()`
    - fixed an issue that throws an error when you own no shares
    - fixed an issue that throws an error when one of your investments has no "Simple Name" value in the api

#### New Features
  - `get_historicals()`: added a new function for pulling historical prices
  - `get_portfolios()`: added a new function for pulling current and historical portfolio values
  - `get_order_history()`: added an additional field `created_at`

#### Clean up
  - Reorganized some of the api_functions to make more calls go through `api_instruments()` when pulling instrument meta data

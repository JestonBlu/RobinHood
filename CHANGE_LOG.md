## 1.0.6

#### Clean up
  - `get_historicals()` now returns prices formatted as numeric

## 1.0.5

#### Bug fixes
  - `get_positions()`
    - fixed an issue that throws an error when you own no shares
    - fixed an issue that throws an error when one of your investments has no "Simple Name" value in the api

#### New Features
  - `get_historicals()`
    - added a new function for pulling historical prices
  - `get_portfolios()`
    - added a new function for pulling current and historical portfolio values
  - `get_order_history()`
    - added an additional field `created_at`

#### Clean up
  - Reorganized some of the api_functions to make more calls go through `api_instruments()` when pulling instrument meta data

![Travis-CI](https://travis-ci.org/JestonBlu/RobinHood.svg?branch=master)
![Dev Version](https://img.shields.io/badge/github-1.2.4-blue.svg)
![CRAN Version](http://www.r-pkg.org/badges/version/RobinHood?color=blue)
![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/RobinHood)


## RobinHood
This is package is designed to help you execute trading programs in R.

**[RobinHood](https://robinhood.com)** is a no commission trading platform intended to bring investing to the masses. It is a great place to experiment with different trading strategies on a minimal investment because your trades will not be eaten up by commission fees.

Haven't signed up for a RobinHood account yet? Use my **[referral link](https://share.robinhood.com/josephb5278)**. We both get a free share of stock!


## Account Features
- [x] Account data
- [x] Add and remove investments on your watchlist
- [ ] Execute ACH transfers
- [ ] 2 factor authentication

## Equity Features
- [x] Get current holdings
- [x] Access investment statistics and quotes
- [x] Place and cancel orders
- [x] Get order status
- [x] Get price history
- [x] Get order history
- [x] Get market open/close hours
- [x] Search investments by popular tag
- [x] Calculate historical account balance
- [ ] Get options market data
- [ ] Get options contracts

## Crypto Features
- [x] Get current holdings
- [x] Get order history
- [x] Get quotes
- [x] Place and cancel orders
- [x] Get order status

**Note:** A key difference between the CRAN version and the Github version is that the API functions are exported and available to call directly. This is intended primarily to help with development and bug fixes. In the CRAN version, all API functions are not exported and instead are called behind the scenes.


## Installation
```r
# CRAN version
install.packages("RobinHood")

# Development version
devtools::install_github("jestonblu/RobinHood")
```


## Establish a connection to RobinHood
```r
library(RobinHood)

# Establishes a connection with your account and generates an oauth2 token
# Returns a list style object of relevant API keys and IDs needed to interact with your account
RH = RobinHood(username = "username", password = "password")
```


## User and Account Info
```r
# Get user info (see api_user for a list of fields)
get_user(RH)

# Get account info (see api_accounts for a list of fields)
get_accounts(RH)

# Get summary of your current portfolio
get_portfolios(RH)

# Get historical summaries of your portfolio
get_portfolios(RH, interval = "day", span = "3month")

# Structure
# $ begins_at            : POSIXct, format: "2019-01-04" "2019-01-07" "2019-01-08" "2019-01-09" ...
# $ adjusted_open_equity : num  500 504 504 504 504 ...
# $ adjusted_close_equity: num  500 504 504 504 509 ...
# $ open_equity          : num  0 504 504 504 504 ...
# $ close_equity         : num  0 504 504 504 509 ...
# $ open_market_value    : num  0 4.01 4.12 4.16 4.26 ...
# $ close_market_value   : num  0 4.07 4.14 4.27 17.52 ...
# $ net_return           : num  0 0.0001 0 0.0002 0.0094 0.0002 0 -0.0003 0.0005 0.0015 ...
# $ session              : chr  "reg" "reg" "reg" "reg" ...
```


## Investment Positions
```r
# Returns a data frame of stock ownership positions
get_positions(RH)

#  simple_name symbol quantity average_buy_price last_trade_price cost current_value          updated_at
#           GE     GE        1               8.5             8.73  8.5          8.73 2019-01-10 04:19:01
#        Zynga   ZNGA        2               0.0             4.27  0.0          8.54 2019-01-06 16:44:03

# Returns a data frame of current crypto currency holdings
get_positions_crypto(RH)

#  symbol             name quantity market_value cost_bases gain_loss          created_at
#    DOGE         Dogecoin     3261         8.09      10.01     -1.92 2019-07-15 21:08:19
#     ETC Ethereum Classic       10        66.97      39.30     27.67 2019-02-01 00:23:40
```


## Funadmentals, Quotes, and Historicals
```r
# Get instrument fundamentals
get_fundamentals(RH, 'CAT')

# Structure
# $ open                  : num 135
# $ high                  : num 138
# $ low                   : num 134
# $ volume                : num 2021397
# $ average_volume_2_weeks: num 4429974
# $ average_volume        : num 5480144
# $ high_52_weeks         : num 173
# $ dividend_yield        : num 1.97
# $ low_52_weeks          : num 112
# $ market_cap            : num 8.06e+10
# $ pe_ratio              : num 21.8
# $ shares_outstanding    : num 5.9e+08
# $ ceo                   : chr "Donald James Umpleby, III"
# $ headquarters_city     : chr "Deerfield"
# $ headquarters_state    : chr "Illinois"
# $ sector                : chr "Producer Manufacturing"
# $ industry              : chr "Trucks Or Construction Or Farm Machinery"
# $ num_employees         : int 98400
# $ year_founded          : int 1925

# Get quotes
get_quote(RH, ticker = c("CAT", "GE"), limit_output = TRUE)

#  symbol last_trade_price last_trade_price_source
#     CAT           131.66            consolidated
#      GE             8.98            consolidated

# Get crypto currency quotes (only one symbol at a time here)
get_quote_crypto(RH, symbol = "ETC")
# symbol ask_price bid_price mark_price high_price low_price open_price   volume
#    ETC  6.698958  6.684054   6.691506      7.006     6.257     6.4935 38310780

# Get historical prices
get_historicals(RH, 'CAT', interval = '30minute', span = 'day')    # Every 30 minutes for the current day

#  begins_at open_price close_price high_price  low_price   volume session interpolated
# 2019-02-25     140.99      137.47     142.55     135.27 22995597     reg        FALSE
# 2019-03-04     138.80      131.35     139.77     130.23 19397486     reg        FALSE
# 2019-03-11     131.91      132.67     134.53     131.59 23201154     reg        FALSE
# 2019-03-18     132.70      129.77     135.71     129.49 19314924     reg        FALSE

get_historicals(RH, 'CAT', interval = 'day',      span = 'week')   # Every day for the current week
get_historicals(RH, 'CAT', interval = 'week',     span = '3month') # Every week for the last 3 months
get_historicals(RH, 'CAT', interval = 'month',    span = 'year')   # Every month for the current year

```


## Orders
```r
# Place Order, should generate an email
x = place_order(RH            = RH,
                symbol        = "GE",        # Ticker symbol you want to trade
                type          = "market",    # Type of market order
                time_in_force = "gfd",       # Time period the order is good for (gfd: good for day)
                trigger       = "immediate", # Trigger or delay order
                price         = 8.96,        # The highest price you are willing to pay
                quantity      = 1,           # Number of shares you want
                side          = "buy")       # buy or sell

# Structure
# $ updated_at               : POSIXct
# $ ref_id                   : chr
# $ time_in_force            : chr
# $ fees                     : num
# $ cancel                   : chr (url needed to cancel order)
# $ response_category        : chr
# $ id                       : chr
# $ cumulative_quantity      : num
# $ stop_price               : num
# $ reject_reason            : num
# $ instrument               : chr
# $ state                    : chr
# $ trigger                  : chr
# $ override_dtbp_checks     : logi
# $ type                     : chr
# $ last_transaction_at      : POSIXct
# $ price                    : num
# $ executions               : list()
# $ extended_hours           : logi
# $ account                  : chr
# $ url                      : chr (url for checking order status)
# $ created_at               : POSIXct
# $ side                     : chr
# $ override_day_trade_checks: logi
# $ position                 : chr
# $ average_price            : num
# $ quantity                 : num

# Crypto works the same way
x = place_order_crypto(RH,
                       symbol        = "DOGE",
                       type          = "market",
                       time_in_force = "gtc",
                       price         = .002,
                       quantity      = 400,
                       side          = "buy")

# Structure
# $ account_id               : chr
# $ cancel_url               : chr
# $ created_at               : POSIXct[1:1]
# $ cumulative_quantity      : num
# $ currency_pair_id         : chr
# $ executions               : list()
# $ id                       : chr
# $ last_transaction_at      : NULL
# $ price                    : num
# $ quantity                 : num
# $ ref_id                   : chr
# $ rounded_executed_notional: num
# $ side                     : chr
# $ state                    : chr
# $ time_in_force            : chr
# $ type                     : chr
# $ updated_at               : POSIXct[1:1]

# Check the status of an order
get_order_status(RH, x$url)
get_order_status_crypto(RH, x$id)

# $updated_at
# [1] "2019-01-20T13:57:44.329458Z"
#
# $time_in_force
# [1] "gfd"
#
# $state
# [1] "queued"
#
# $type
# [1] "market"
#
# $executions
# list()

# Cancel an order (should generate an email)
cancel_order(RH, x$cancel)
cancel_order_crypto(RH, x$cancel_url)

# One of 2 messages you may receive
# "Order canceled"
# "You may have already canceled this order, check order_status()"

# Get order History
get_order_history(RH)

# Structure
# $ created_at   : POSIXct
# $ symbol       : chr
# $ side         : chr
# $ price        : num
# $ quantity     : num
# $ fees         : num
# $ state        : chr
# $ average_price: num
# $ type         : chr
# $ trigger      : chr
# $ time_in_force: chr
# $ updated_at   : POSIXct

get_order_history_crypto(RH)

# Structure
# $ name                : chr
# $ symbol              : chr
# $ created_at          : POSIXct
# $ price               : num
# $ exec_effective_price: num
# $ exec_quantity       : num
# $ side                : chr
# $ state               : chr
# $ time_in_force       : chr
# $ type                : chr
```


## Market Hours
```r
# Get market hours for a specific date
get_market_hours(RH)

#                            name     city             website   timezone acronym opens_at closes_at
# 1                    IEX Market New York  www.iextrading.com US/Eastern     IEX 08:30:00  15:00:00
# 2                   Otc Markets New York  www.otcmarkets.com US/Eastern    OTCM 08:30:00  15:00:00
# 3                  NYSE Mkt Llc New York        www.nyse.com US/Eastern    AMEX 08:30:00  15:00:00
# 4                     NYSE Arca New York        www.nyse.com US/Eastern    NYSE 08:30:00  15:00:00
# 5 New York Stock Exchange, Inc. New York        www.nyse.com US/Eastern    NYSE 08:30:00  15:00:00
# 6          NASDAQ - All Markets New York      www.nasdaq.com US/Eastern  NASDAQ 08:30:00  15:00:00
# 7                 BATS Exchange New York www.batstrading.com US/Eastern    BATS 08:30:00  15:00:00

#   extended_opens_at extended_closes_at is_open       date
# 1          08:00:00           17:00:00    TRUE 2019-01-17
# 2          08:00:00           17:00:00    TRUE 2019-01-17
# 3          08:00:00           17:00:00    TRUE 2019-01-17
# 4          08:00:00           17:00:00    TRUE 2019-01-17
# 5          08:00:00           17:00:00    TRUE 2019-01-17
# 6          08:00:00           17:00:00    TRUE 2019-01-17
# 7          08:00:00           17:00:00    TRUE 2019-01-17
```


## Tags
```r
# You can identify instruments by popular tags
get_tag(RH, tag = "100-most-popular")

#  [1] "AAPL"  "GE"    "ACB"   "F"     "CRON"  "MSFT"  "FB" ...
```


## Watchlist
```r
# Watchlist commands, currently creating and removing watchlists isn't working
watchlist(RH, action = 'get')
# [1] "Default"

watchlist(RH, action = 'get', watchlist = 'Default')
# [1] "AAPL" "TWTR" "TSLA" "NFLX" "FB"   "MSFT" "DIS"  "GPRO" ...

watchlist(RH, action = 'add', watchlist = 'Default', ticker = "CAT")
# "Instrument added to watchlist"

watchlist(RH, action = 'delete', watchlist = 'Default', ticker = 'CAT')
# "Instrument removed from watchlist"
```

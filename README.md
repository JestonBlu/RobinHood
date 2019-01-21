![Travis-CI](https://travis-ci.org/JestonBlu/RobinHood.svg?branch=master)
![Commit-Activity](https://img.shields.io/github/commit-activity/4w/JestonBlu/RobinHood.svg)
![CRAN Version](http://www.r-pkg.org/badges/version/RobinHood)
![CRAN Downloads](http://cranlogs.r-pkg.org/badges/RobinHood)

--------------------------------------------------------------------------------

## RobinHood
This is package is designed to help you execute trading programs in R.

**[RobinHood](https://robinhood.com)** is a no commission trading platform intended to bring investing to the masses. It is a great place to experiment with different trading strategies on a minimal investment because your trades will not be eaten up by commission fees.

Haven't signed up for a RobinHood account yet? Use my **[referral link](https://share.robinhood.com/josephb5278)**. We both get a free share of stock!

## Features
- [x] Access account data and current holdings
- [x] Access investment statistics and quotes
- [x] Place and cancel orders
- [x] Get market open/close hours
- [x] Search investments by popular tag
- [x] Add and remove investments on your watchlist
- [ ] Interactions with your linked bank account

## Install with devtools
```r
# Development version
devtools::install_github("jestonblu/RobinHood")
```

## Examples
```r
library(RobinHood)

# Establishes a connection with your account and generates an oauth2 token
# Returns a list style object of relevant API keys and IDs needed to interact with your account
RH = RobinHood(username = "username", password = "password")

# Get user info (see api_user for a list of fields)
get_user(RH)

# Get account info (see api_accounts for a list of fields)
get_accounts(RH)

# Returns a data.frame of positions
get_positions(RH, limit_output= TRUE)

#   simple_name symbol quantity average_buy_price last_trade_price cost current_value          updated_at
# 1          GE     GE        1               8.5             8.73  8.5          8.73 2019-01-10 04:19:01
# 2       Zynga   ZNGA        2               0.0             4.27  0.0          8.54 2019-01-06 16:44:03

# Get instrument fundamentals
str(get_fundamentals(RH, 'CAT'))

#'data.frame':	1 obs. of  19 variables:
# $ open                  : chr "135.020000"
# $ high                  : chr "137.710000"
# $ low                   : chr "133.660000"
# $ volume                : chr "1629664.000000"
# $ average_volume_2_weeks: chr "4372297.200000"
# $ average_volume        : chr "5479200.247000"
# $ high_52_weeks         : chr "173.100000"
# $ dividend_yield        : chr "1.967200"
# $ low_52_weeks          : chr "112.060000"
# $ market_cap            : chr "79392956900.000000"
# $ pe_ratio              : chr "21.800580"
# $ shares_outstanding    : chr "590106711.000000"
# $ ceo                   : chr "Donald James Umpleby, III"
# $ headquarters_city     : chr "Deerfield"
# $ headquarters_state    : chr "Illinois"
# $ sector                : chr "Producer Manufacturing"
# $ industry              : chr "Trucks Or Construction Or Farm Machinery"
# $ num_employees         : int 98400
# $ year_founded          : int 1925

# Get quotes
get_quote(RH, ticker = c("CAT", "GE"), limit_output= TRUE)

#    symbol last_trade_price last_trade_price_source
# 1    CAT       131.660000            consolidated
# 2     GE         8.980000            consolidated

# Place Order, should generate an email
x = place_order(RH = RH,
                symbol = "GE",          # Ticker symbol you want to trade
                type = "market",        # Type of market order
                time_in_force = "gfd",  # Time period the order is good for (gfd: good for day)
                trigger = "immediate",  # Trigger or delay order
                price = 8.96,           # The highest price you are willing to pay
                quantity = 1,           # Number of shares you want
                side = "buy")           # buy or sell

# List of 27
# $ updated_at               :
# $ ref_id                   :
# $ time_in_force            :
# $ fees                     :
# $ cancel                   : # url to cancel an order
# $ response_category        :
# $ id                       :
# $ cumulative_quantity      :
# $ stop_price               :
# $ reject_reason            :
# $ instrument               :
# $ state                    :
# $ trigger                  :
# $ override_dtbp_checks     :
# $ type                     :
# $ last_transaction_at      :
# $ price                    :
# $ executions               :
# $ extended_hours           :
# $ account                  :
# $ url                      : # url for checking order status
# $ created_at               :
# $ side                     :
# $ override_day_trade_checks:
# $ position                 :
# $ average_price            :
# $ quantity                 :


# Check the status of an order
get_order_status(RH, x$url)

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
# One of 2 messages you may receive
#  "Order canceled"
# "You may have already canceled this order, check order_status()"

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



# You can identify instruments by popular tags
get_tag(RH, tag = "100-most-popular")
#  [1] "AAPL"  "GE"    "ACB"   "F"     "CRON"  "MSFT"  "FB"    "AMD"   "FIT"   "GPRO"  "CGC"   "SNAP" ...

# Watchlist commands, currently creating and removing watchlists isn't working
watchlist(RH, action = 'get')
# [1] "Default"

watchlist(RH, action = 'get', watchlist = 'Default')
# [1] "AAPL" "TWTR" "TSLA" "NFLX" "FB"   "MSFT" "DIS"  "GPRO" "SBUX" "F"    "BABA" "BAC"  "FIT"  "GE"   "SNAP"

watchlist(RH, action = 'add', watchlist = 'Default', ticker = "CAT")
# [1] "Instrument added to watchlist"

watchlist(RH, action = 'delete', watchlist = 'Default', ticker = 'CAT')
# [1] "Instrument removed from watchlist"



```

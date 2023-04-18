
# RobinHood
This package aims to help you execute trading programs in R.

**[RobinHood](https://robinhood.com)** is a trading platform intended to bring investing to the masses and empower users to experiment with different trading strategies on a minimal investment basis while avoiding commission fees.

If you still need to sign up for a RobinHood account, use my **[referral link](https://share.robinhood.com/josephb5278)**. We both get a free share of stock!


## Account Features
- [x] Account data
- [x] Add and remove investments on your watchlist
- [x] Execute ACH transfers
- [x] MFA enabled

## Equity Features
- [x] Get current holdings
- [x] Access investment statistics and quotes
- [x] Place and cancel orders
- [x] Get order status
- [x] Get price history
- [x] Get order history
- [x] Get market open/close hours
- [x] Search investments by popular tag
- [x] Calculate the historical account balance
- [x] Get options market data
- [x] Get options positions
- [x] Get analyst ratings

## Crypto Features
- [x] Get current holdings
- [x] Get order history
- [x] Get quotes
- [x] Place and cancel orders
- [x] Get order status

**Note:** A key difference between the CRAN and Github versions is that the API functions are exported and available to call directly, intended primarily to help with development and bug fixes. In the CRAN version, all API functions are not exported but invoked behind the scenes.

## Installation
```r
# CRAN version
install.packages("RobinHood")

# Development version
devtools::install_github("jestonblu/RobinHood")
```

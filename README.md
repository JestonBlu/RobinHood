![](https://travis-ci.org/JestonBlu/RobinHood.svg?branch=master)
![](https://img.shields.io/github/downloads/JestonBlu/RobinHood/total.svg)
![](https://img.shields.io/badge/development-active-blue.svg)
![](https://img.shields.io/github/commit-activity/y/JestonBlu/RobinHood.svg)

## RobinHood
An R Interface for the RobinHood.com no commision investing site. 

This project is in early development and currently has just a few features. Once I get a basic set of usuable feature created then I will do a first release and stop making changes to the master branch. Until then things could structurally change without notice. For pending features please see the project page.

## Install with devtools
```r
devtools::install_github("jestonblu/RobinHood")
```


## Current Features
```r
library(RobinHood)

# Establishes a connection with your account and generates an oauth2 token
# Returns a list style object of relevant API keys and IDs needed to interact with your account
RH = RobinHood(username = "username", password = "password")

# Returns a data.frame of positions
getPositions(RH)

# Logout and revoke your oauth2 token
logout(RH)

```

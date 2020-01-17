
<!-- README.md is generated from README.Rmd. Please edit that file -->

# AWS Dynamo DB Client

## DISCLAIMER

This project has been forked from
<https://github.com/cloudyr/aws.dynamodb/> which is not maintained
anymore. Few improvements have been done too such as automatic post
processing of results and to be able to use a local version of dynamodb.

## aws.dynamodb

**aws.dynamodb** is a package for the [Amazon
DynamoDB](https://aws.amazon.com/dynamodb/) API

To use the package, you will need an AWS account and to enter your
credentials into R. Your keypair can be generated on the [IAM Management
Console](https://aws.amazon.com/) under the heading *Access Keys*. Note
that you only have access to your secret key once. After it is
generated, you need to save it in a secure location. New keypairs can be
generated at any time if yours has been lost, stolen, or forgotten. The
[**aws.iam** package](https://github.com/cloudyr/aws.iam) profiles tools
for working with IAM, including creating roles, users, groups, and
credentials programmatically; it is not needed to *use* IAM credentials.

A detailed description of how credentials can be specified is provided
at: <https://github.com/cloudyr/aws.signature/>. The easiest way is to
simply set environment variables on the command line prior to starting R
or via an `Renviron.site` or `.Renviron` file, which are used to set
environment variables in R during startup (see `? Startup`). They can be
also set within R:

``` r
Sys.setenv("AWS_ACCESS_KEY_ID" = "mykey",
           "AWS_SECRET_ACCESS_KEY" = "mysecretkey",
           "AWS_DEFAULT_REGION" = "us-east-1",
           "AWS_SESSION_TOKEN" = "mytoken")
```

## Code Examples

``` r
library("aws.dynamodb")

# list all tables
list_tables()

# Create a table
tab <- create_table(
  table = "Music",
  attributes = list(Artist = "S"),
  primary_key = "Artist"
)

# put item in database
put_item("Music", list(Artist = "No One You Know", SongTitle = "Call Me Today"))
put_item("Music", list(Artist = "Another Band", SongTitle = "Some Song"))

# get the table
get_table(tab)

# get an item
get_item("Music", c(Artist = "Another Band"))

# cleanup
delete_table(tab)
```

## Installation

[![CRAN](https://www.r-pkg.org/badges/version/aws.dynamodb)](https://cran.r-project.org/package=aws.dynamodb)
![Downloads](https://cranlogs.r-pkg.org/badges/aws.dynamodb) [![Travis
Build
Status](https://travis-ci.org/cloudyr/aws.dynamodb.png?branch=master)](https://travis-ci.org/cloudyr/aws.dynamodb)
[![codecov.io](https://codecov.io/github/cloudyr/aws.dynamodb/coverage.svg?branch=master)](https://codecov.io/github/cloudyr/aws.dynamodb?branch=master)

This package is not yet on CRAN. To install the latest development
version you can install github:

``` r
remotes::install_github("centreon/aws.dynamodb")
```

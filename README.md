# strongdm cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/strongdm.svg)](https://supermarket.getchef.com/cookbooks/strongdm)
[![Build Status](https://secure.travis-ci.org/ApplauseOSS/strongdm_cookbook.svg?branch=master)](http://travis-ci.org/ApplauseOSS/strongdm_cookbook)

## Description

This cookbook fetches the [strongDM](https://www.strongdm.com) client into
the Chef file cache, for use during a Chef run. It includes recipes for
gateways and SSH servers to self-register.

## Recipes

### default

Fetches the `sdm` client from strongDM and puts it into the Chef file cache.
Also, creates a `strongdm` local user for use by other recipes.

### gateway

Automatically registers a host as a strongDM gateway relay. This requires the
user to provide an admin token which has the following permissions:

- relay:create

### server

Automatically registers a host as a strongDM server relay. This requires the
user to provide an admin token which has the following permissions:

- datasource:create
- datasource:grant
- datasource:list
- role:list

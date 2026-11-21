# Kickstart [![Test](https://github.com/smudge/kickstarter/actions/workflows/test.yml/badge.svg)](https://github.com/smudge/kickstarter/actions/workflows/test.yml) [![RubyGems downloads](https://img.shields.io/gem/dt/kickstarter.svg)](https://rubygems.org/gems/kickstarter)
a simple API for Kickstarter.com

This is a historical scraper. Its recorded tests do not establish compatibility
with the current Kickstarter website. The RubyGems badge refers to the existing
`kickstarter` gem, not a release of this fork.

Usage:

  projects = Kickstarter.by_category(:games, :page => 1)
    # => returns back an array of projects from page 1
    
  projects = Kickstarter.by_list(:ending_soon, :page => 2, :pages => 3)
    # => returns back an array of 3 pages worth of projects, starting from page 2


A Kickstarter::Project has the following attributes:
  .name
  .handle
  .description
  .url
  .owner
  .email
  .thumbnail_url
  .pledge_amount
  .pledge_percent
  .pledge_deadline
  
The following attributes will prompt a load of the project's details page:
  
  .pledge_goal
  .short_url
  .about
  .tiers (returns array of Kickstart::Tier objects)

A Kickstarter::Tier has the following attributes:
  .minimum_pledge
  .backer_count
  .description
  .limited
  .limited_max
  .limited_remaining
  .estimated_delivery  
  
Options:
  :page => X    # which page number of results to return. May be empty
  :pages => Y   # number of pages worth of results. Don't be stupid and request too many pages...


future: 
 * support filter by pledge_amount



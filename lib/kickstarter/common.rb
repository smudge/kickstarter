require 'nokogiri'
require 'open-uri'
require 'money'

module Kickstarter
  BASE_URL = "http://www.kickstarter.com"
  Money.assume_from_symbol = true

  Categories = {
    :art         => "art",
    :comics      => "comics",
    :dance       => "dance",
    :design      => "design",
    :product_design => "product%20design",
    :fashion     => "fashion",
    :film_video  => "film%20&%20video",
    :food        => "food",
    :games       => "games",
    :music       => "music",
    :photography => "photography",
    :publishing  => "publishing",
    :technology  => "technology",
    :theater     => "theater"
  }
  
  Types = {
    :popular     => 'popular',
    :recommended => 'recommended',
    :successful  => 'successful',
    :most_funded => 'most-funded'
  }
  
  Lists = {
    :recommended       => "recommended",
    :popular           => "popular",
    :recently_launched => "recently-launched",
    :ending_soon       => "ending-soon",
    :small_projects    => "small-projects",
    :most_funded       => "most-funded",
    :curated           => "curated-pages",
  }

end
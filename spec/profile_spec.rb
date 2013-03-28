# encoding: utf-8
require 'spec_helper'
require_relative '../lib/kickstarter/profile'

describe Kickstarter::Profile do

  bubbin = "837407022"
  pennya = "pennyarcade"
  weiner = "weiner"
  smudge = "smudge"
  ryans = "ryanestrada"
  ryann = "breadpig"
  adamb = "bildersee"
  benign = "benignkingdom"
  sensible = "darrenwall"
  ralfh = "ralfh"
  chimero = "fchimero"
  gaspar = "georgegaspar"
  rivetw = "coolminiornot"


  it "finds the name" do
    VCR.use_cassette "profile/#{pennya}" do
      @profile = Kickstarter::Profile.new(pennya)
      @profile.name.should eq("Penny Arcade")
    end
  end

  it "finds the username" do
    VCR.use_cassette "profile/#{bubbin}" do
      @profile = Kickstarter::Profile.new(bubbin)
      @profile.username.should eq("837407022")
    end
  end

  it "finds the url" do
    VCR.use_cassette "profile/#{weiner}" do
      @profile = Kickstarter::Profile.new(weiner)
      @profile.url.should eq("http://www.kickstarter.com/profile/weiner")
    end
  end

  it "finds the thumbnail_url" do
    VCR.use_cassette "profile/#{smudge}" do
      @profile = Kickstarter::Profile.new(smudge)
      @profile.thumbnail_url.should eq("https://s3.amazonaws.com/ksr/avatars/593628/fb_profile_picture.medium.jpg")
    end
  end

  it "finds the location" do
    VCR.use_cassette "profile/#{ryans}" do
      @profile = Kickstarter::Profile.new(ryans)
      @profile.location.should eq("Busan, South Korea")
    end
  end

  it "finds the month joined" do
    VCR.use_cassette "profile/#{ryann}" do
      @profile = Kickstarter::Profile.new(ryann)
      @profile.joined.should eq("October 2012")
    end
  end

  it "finds the backed_count" do
    VCR.use_cassette "profile/#{adamb}" do
      @profile = Kickstarter::Profile.new(adamb)
      @profile.backed_count.should eq(11)
    end
  end

  it "finds the backed_projects (empty)" do
    VCR.use_cassette "profile/#{benign}" do
      @profile = Kickstarter::Profile.new(benign)
      @profile.backed_projects.count.should eq(0)
    end
  end

  it "finds the backed_projects (1 page)" do
    VCR.use_cassette "profile/#{sensible}", :record => :new_episodes do
      @profile = Kickstarter::Profile.new(sensible)
      @profile.backed_projects.count.should eq(5)
    end
  end

  it "finds the backed_projects (many pages)" do
    VCR.use_cassette "profile/#{ralfh}", :record => :new_episodes do
      @profile = Kickstarter::Profile.new(ralfh)
      @profile.backed_projects.count.should eq(246)
    end
  end

end
# encoding: utf-8
require 'spec_helper'
require_relative '../lib/kickstarter/project'

describe Kickstarter::Project do

  base_url = "http://www.kickstarter.com/"

  doublefine = "projects/doublefine/double-fine-adventure"
  remag = "projects/remag/re-magazine"
  goats = "projects/jonrosenberg/goats-book-iv-inhuman-resources"
  kandb = "projects/1858685678/kern-and-burn-the-book"
  omfg = "projects/georgegaspar/omfg-series-1"
  minecraft = "projects/2pp/minecraft-the-story-of-mojang"
  jaybill = "projects/jaybill/refillable-bamboo-notebook"
  the_manual = "projects/goodonpaper/the-manual"
  whooligans = "projects/fts-media/doctor-who-50th-anniversary-documentary-whooligans"
  elite = "projects/1461411552/elite-dangerous"
  chimero = "projects/fchimero/the-shape-of-design"
  weiner = "projects/weiner/science-ruining-everything-since-1543-an-smbc-coll"
  benign = "projects/benignkingdom/benign-kingdom-spring-2013"
  punchout = "projects/1607016995/pixel-perfect-mike-tysons-punch-out"
  ftl = "projects/64409699/ftl-faster-than-light"
  zefrank = "projects/zefrank/a-show-with-ze-frank"
  dee = "projects/silentjames/dee-an-illustrated-story"

  it "finds the project id" do
    VCR.use_cassette doublefine do
      @project = Kickstarter::Project.new(base_url + doublefine)
      @project.id.should eq(73409)
    end
  end

  it "finds the project name" do
    VCR.use_cassette doublefine do
      @project = Kickstarter::Project.new(base_url + doublefine)
      @project.name.should eq('Double Fine Adventure')
    end
  end

  it "finds the project description" do
    VCR.use_cassette remag do
      @project = Kickstarter::Project.new(base_url + remag)
      @project.description.should eq("Re: Magazine is the Savannah College of Art and Design's premiere fashion, art and culture publication.")
    end
  end

  it "finds the project's canonical url" do
    VCR.use_cassette goats do
      @project = Kickstarter::Project.new("http://kck.st/zWboXB")
      @project.url.should match("^https?://www.kickstarter.com/" + goats)
    end
  end

  it "finds the project's short url" do
    VCR.use_cassette kandb do
      @project = Kickstarter::Project.new(base_url + kandb)
      @project.short_url.should eq('http://kck.st/w7yP78')
    end
  end

  it "finds the project's owner" do
    VCR.use_cassette omfg do
      @project = Kickstarter::Project.new(base_url + omfg)
      @project.owner.should eq('George Gaspar')
    end
  end

  it "finds the project's image_url" do
    VCR.use_cassette minecraft do
      @project = Kickstarter::Project.new(base_url + minecraft)
      @project.image_url.should eq('https://s3.amazonaws.com/ksr/projects/21767/photo-full.jpg')
    end
  end

  it "finds a USD project's currency" do
    VCR.use_cassette the_manual do
      @project = Kickstarter::Project.new(base_url + the_manual)
      @project.currency.should eq('USD')
    end
  end

  it "finds a GBP project's currency" do
    VCR.use_cassette whooligans do
      @project = Kickstarter::Project.new(base_url + whooligans)
      @project.currency.should eq('GBP')
    end
  end

  it "finds a USD project's pledge_amount" do
    VCR.use_cassette jaybill do
      @project = Kickstarter::Project.new(base_url + jaybill)
      @project.pledge_amount.should eq(Money.parse("$10,284.00"))
    end
  end

  it "finds a GBP project's pledge_amount" do
    VCR.use_cassette elite do
      @project = Kickstarter::Project.new(base_url + elite)
      @project.pledge_amount.should eq(Money.parse("£1,578,316.00"))
    end
  end

  it "finds a USD project's pledge_goal" do
    VCR.use_cassette jaybill do
      @project = Kickstarter::Project.new(base_url + jaybill)
      @project.pledge_goal.should eq(Money.parse("$8,500.00"))
    end
  end

  it "finds a GBP project's pledge_goal" do
    VCR.use_cassette elite do
      @project = Kickstarter::Project.new(base_url + elite)
      @project.pledge_goal.should eq(Money.parse("£1,250,000.00"))
    end
  end

  it "finds a project's pledge_percent" do
    VCR.use_cassette chimero do
      @project = Kickstarter::Project.new(base_url + chimero)
      @project.pledge_percent.should eq(4.154041111111111)
    end
  end

  it "finds an ongoing project's pledge_deadline" do
    VCR.use_cassette weiner do
      @project = Kickstarter::Project.new(base_url + weiner)
      @project.pledge_deadline.utc.should eq(Time.parse("Friday Feb 22, 4:47:47am PST").utc)
    end
  end

  it "finds a completed project's pledge_deadline" do
    VCR.use_cassette zefrank do
      @project = Kickstarter::Project.new(base_url + zefrank)
      @project.pledge_deadline.utc.should eq(Time.parse("Friday Mar 08 2012 11:59:00pm PST").utc)
    end
  end

  it "finds a project's duration" do
    VCR.use_cassette weiner do
      @project = Kickstarter::Project.new(base_url + weiner)
      @project.duration.should eq(30)
    end
  end

  it "finds a project's launched_at" do
    VCR.use_cassette benign do
      @project = Kickstarter::Project.new(base_url + benign)
      @project.launched_at.utc.to_s.should eq(Time.parse("Jan 17, 2013 11:28:09am PST").utc.to_s)
    end
  end

  it "finds a project's full_description" do
    VCR.use_cassette punchout do
      @project = Kickstarter::Project.new(base_url + punchout)
      @project.full_description.should match(/I also have an unhealthy love of large 'coffee table' books and an obsessive-compulsive need to organize information./)
    end
  end

  it "finds a project's risks" do
    VCR.use_cassette dee do
      @project = Kickstarter::Project.new(base_url + dee)
      @project.risks.should match(/If the book printing takes longer than expected, the shipping estimate for \$25\+ rewards may be pushed to April 2013\./)
    end
  end

  it "finds a project's tiers" do
    VCR.use_cassette ftl do
      @project = Kickstarter::Project.new(base_url + ftl)
      @project.tiers.count eq(9)
    end
  end

end
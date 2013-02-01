# encoding: utf-8
require 'spec_helper'
require_relative '../lib/kickstarter/project_card'

describe Kickstarter::ProjectCard do

  eternity = "projects/obsidian/project-eternity/widget/card.html"
  exocomics = "projects/meacollab/extra-ordinary-comics-vol-1-and-2/widget/card.html"
  diesel = "projects/dieselsweeties/diesel-sweeties-ebook-stravaganza-3000/widget/card.html"
  makey = "projects/joylabs/makey-makey-an-invention-kit-for-everyone/widget/card.html"
  trekfans = "projects/1800676131/star-trek-deception-a-fan-film/widget/card.html"
  spacesuit = "projects/872281861/final-frontier-designs-3g-space-suit/widget/card.html"
  jackpot = "projects/1946927951/jackpot-1/widget/card.html"
  kickstat = "projects/zacinaction/kicksat-your-personal-spacecraft-in-space/widget/card.html"
  beards = "projects/476976342/poems-of-beards-and-other-things-0/widget/card.html"
  puzzlepork = "projects/1343822269/puzzlepork-coming-to-pc-mac-ios-and-android-0/widget/card.html"
  dabook = "projects/837407022/book-of-da-a-sci-fantasy-graphic-novel/widget/card.html"

  def get_node(project)
    VCR.use_cassette project do
      @nodes = Nokogiri::HTML(open("http://www.kickstarter.com/" + project)).css('.project-card')
    end
  end

  it "finds the project id" do
    @project = Kickstarter::ProjectCard.new(get_node(eternity))
    @project.id.should eq(289461)
  end

  it "finds the project name" do
    @project = Kickstarter::ProjectCard.new(get_node(exocomics))
    @project.name.should eq("Extra Ordinary Comics: Vol 1 &amp; 2")
  end

  it "finds the project description" do
    @project = Kickstarter::ProjectCard.new(get_node(diesel))
    @project.description.should eq("Help me collect twelve years of webcomics into a complete ebook form while still keeping the files free to all.")
  end

  it "finds the canonical project url" do
    @project = Kickstarter::ProjectCard.new(get_node(makey))
    @project.url.should match("^https?://www.kickstarter.com/projects/joylabs/makey-makey-an-invention-kit-for-everyone")
  end

  it "finds the project owner" do
    @project = Kickstarter::ProjectCard.new(get_node(trekfans))
    @project.owner.should eq("Leo Tierney")
  end

  it "finds the project image_url" do
    @project = Kickstarter::ProjectCard.new(get_node(spacesuit))
    @project.image_url.should eq("https://s3.amazonaws.com/ksr/projects/217667/photo-full.jpg")
  end

  it "finds a USD project's currency" do
    @project = Kickstarter::ProjectCard.new(get_node(kickstat))
    @project.currency.should eq("USD")
  end

  it "finds a GBP project's currency" do
    @project = Kickstarter::ProjectCard.new(get_node(jackpot))
    @project.currency.should eq("GBP")
  end

  it "finds the project pledge_amount" do
    @project = Kickstarter::ProjectCard.new(get_node(beards))
    @project.pledge_amount.should eq(Money.new(209300, "USD"))
  end

  it "finds the project pledge_percent" do
    @project = Kickstarter::ProjectCard.new(get_node(puzzlepork))
    @project.pledge_percent.should eq(100)
  end

  it "finds the project pledge_deadline" do
    @project = Kickstarter::ProjectCard.new(get_node(dabook))
    @project.pledge_deadline.should eq(Time.parse("2013-03-01 05:59:00 UTC"))
  end

end
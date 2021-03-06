require 'rubygems'
require 'date'
require_relative "kickstarter/common"
require_relative "kickstarter/version"
require_relative "kickstarter/profile"
require_relative "kickstarter/project"
require_relative "kickstarter/project_card"
require_relative "kickstarter/tier"

module Kickstarter
  # by category
  # /discover/categories/:category/:subcategories 
  #  :type # => [recommended, popular, successful]
  def self.by_category(category, options = {})
    path = File.join(BASE_URL, 'discover/categories', Categories[category.to_sym], Types[options[:type] || :popular])
    list_projects(path, options)
  end
  
  # by lists
  # /discover/:list
  def self.by_list(list, options = {})
    path = File.join(BASE_URL, 'discover', Lists[list.to_sym])
    list_projects(path, options)
  end
  
  def self.by_url(url)
    Kickstarter::Project.new(url)
  end
  
  private
  
  def self.list_projects(url, options = {})
    pages = options.fetch(:pages, 0)
    pages -= 1 unless pages == 0 || pages == :all

    start_page = options.fetch(:page, 1)
    end_page   = pages == :all ? 10000 : start_page + pages

    results = []

    (start_page..end_page).each do |page|
      retries = 0
      begin
        doc = Nokogiri::HTML(open("#{url}?page=#{page}"))
        nodes = doc.css('.project')
        break if nodes.empty?

        nodes.each do |node|
          results << Kickstarter::ProjectCard.new(node)
        end
      rescue Timeout::Error
        retries += 1
        retry if retries < 3
      end
    end
    results
  end
end

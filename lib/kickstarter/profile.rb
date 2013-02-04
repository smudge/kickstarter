# encoding: utf-8
require_relative 'common'
require_relative "project_item"

module Kickstarter
  class Profile

    attr_reader :node
    
    def initialize(username)
      @username = username
    end

    def name
      @name ||= page_content.css('#profile_bio h1').children.first.to_s.gsub(/\n/,'')
    end

    def username
      @username ||= node.css('something')
    end

    def url
      @url ||= BASE_URL + '/profile/' + username
    end

    def thumbnail_url
      page_content.css('#profile_avatar img').attribute('src').to_s.split('?').first
    end

    def location
      @location ||= page_content.css('#profile_bio .location').inner_html
    end

    def joined
      @joined ||= page_content.css('#profile_bio .joined').inner_html.gsub(/Joined/,'').gsub(/\n/,'')
    end

    def backed_count
      @backed_count ||= Integer(page_content.css('#profile_bio .backed').inner_html.gsub(/Backed/,'').gsub(/projects/,'').gsub(/\n/,''))
    end

    def backed_projects(opts = {})
      @backed_projects ||= Profile.fetch_projects(url, opts)
    end

    def page_content
      @page_content ||= Profile.fetch_page(url).css('#main_content')
    end

    def to_hash
      {
        :name           => name,
        :username       => username,
        :url            => url,
        :location       => location,
        :joined         => joined,
        :backed_count   => backed_count
      }
    end

    def inspect
      to_hash.inspect
    end

    private

    def self.fetch_page(url)
      retries = 0
      begin
        Nokogiri::HTML(open(url))
      rescue Timeout::Error
        retries += 1
        retry if retries < 3
      end
    end

    def self.fetch_projects(url, options = {})
      pages = options.fetch(:pages, :all)
      pages -= 1 unless pages == 0 || pages == :all

      start_page = options.fetch(:page, 1)
      end_page   = pages == :all ? 10000 : start_page + pages

      results = []

      (start_page..end_page).each do |page|
        retries = 0
        begin
          doc = Nokogiri::HTML(open("#{url}?page=#{page}"))
          nodes = doc.css('#profile_projects_list .project_item')
          break if nodes.empty?

          nodes.each do |node|
            results << Kickstarter::ProjectItem.new(node)
          end
        rescue Timeout::Error
          retries += 1
          retry if retries < 3
        end
      end
      results
    end

  end
end
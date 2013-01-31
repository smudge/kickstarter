module Kickstarter
  class Project
    
    def initialize(url)
      @seed_url = url
    end
    
    def id
      @id ||= details_page.css(".this_project_id").inner_html.to_i
    end
    
    def name
      @name ||= details_page.css("h1#title a").inner_html
    end
    
    def description
      @description ||= details_page.xpath('//meta[@property="og:description"]/@content').first.value
    end
    
    def url
      @url ||= details_page.css("h1#title a").attr('href').value
    end
    
    def handle
      @handle ||= url.split('/projects/').last.gsub(/\/$/,"")
    end
    
    def owner
      @owner ||= details_page.css('#creator-name h3 a').inner_html.to_s
    end
    
    def image_url
      @image_url ||= details_page.css('#video-section img').attr('src').value
    end
    
    def currency
      @currency ||= details_page.css("#pledged data").attr('data-currency').value
    end

    def pledge_amount
      @pledge_amount ||= Money.new(details_page.css("#pledged").attr("data-pledged").value, currency)*100
    end
    
    def pledge_percent
      @pledge_percent ||= Float(details_page.css('#pledged').attr('data-percent-raised').value)
    end
    
    def pledge_deadline
      @pledge_deadline ||= Time.parse(details_page.css("#project_duration_data").attr("data-end_time").value)
    end
    
    def pledge_goal
      @pledge_goal ||= Money.new(details_page.css("#pledged").attr('data-goal').value, currency)*100
    end

    def duration
      @duration ||= Float(details_page.css('#project_duration_data').attr('data-duration').value)
    end
    
    def launched_at
      pledge_deadline - duration*24*60*60
    end

    # Note: Not all projects are assigned short_urls.
    def short_url
      @short_url ||= details_page.css("#share_a_link").attr("value").value
    end
    
    def full_description
      @about ||= details_page.css('#about .full-description').inner_html.to_s
    end

    def risks
      @risks ||= details_page.css('#risks').inner_html.to_s
    end
    
    def tiers
      retries = 0
      results = []
      begin
        nodes = details_page.css('#what-you-get a.NS-projects-reward')
        nodes.each do |node|
          results << Kickstarter::Tier.new(node)
        end
      rescue Timeout::Error
        retries += 1
        retry if retries < 3
      end
      results
    end

    def details_page
      @details_page ||= Project.fetch_details(seed_url)
    end

    def to_hash
      {
        :id                 => id,
        :name               => name,
        :handle             => handle,
        :url                => url,
        :short_url          => short_url,
        :description        => description,
        :owner              => owner,
        :pledge_amount      => pledge_amount.format,
        :pledge_percent     => pledge_percent,
        :pledge_deadline    => pledge_deadline.to_s,
        :image_url          => image_url,
        :pledge_goal        => pledge_goal.format #,
        #:full_description   => full_description,
        #:risks              => risks,
        #:tiers              => tiers.map{|t|t.to_hash}
      }
    end

    def inspect
      to_hash.inspect
    end
    
    #######################################################
    private
    #######################################################
    
    attr_reader :seed_url
    
    def self.fetch_details(url)
      retries = 0
      begin
        Nokogiri::HTML(open(url))
      rescue Timeout::Error
        retries += 1
        retry if retries < 3
      end
    end
    
  end
end

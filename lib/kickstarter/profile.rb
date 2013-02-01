module Kickstarter
  class Profile

    attr_reader :node
    
    def initialize(*args)
      case args[0]
      when String
        @username = args[0]
      when Nokogiri::XML::Node
        @node = args[0]
      else
        raise TypeError
      end
    end

    def thumbnail_url
      page_content.css('#profile_avatar img').attribute('src').to_s
    end

    def username
      @username ||= node.css('something')
    end

    def url
      @url ||= BASE_URL + '/profile/' + username
    end

    def name
      @name ||= page_content.css('#profile_bio h1').children.first.to_s.gsub(/\n/,'')
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

    def backed_projects

    end

    def page_content
      @page_content ||= Backer.fetch_page(url).css('#main_content')
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

  end
end
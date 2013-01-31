module Kickstarter
  class ProjectCard

    attr_reader :node
    
    def initialize(node)
      @node = node
    end
    
    def id
      @id ||= /\/projects\/([0-9]+)\/photo-little\.jpg/.match(thumbnail_url)[1].to_i
    end
    
    def name
      @name ||= node.css('h2 a').first.inner_html
    end
    
    def description
      @description ||= node.css('h2 + p').inner_html
    end
    
    def url
      @url ||= BASE_URL + node.css('h2 a').first.attribute('href').to_s.split('?').first
    end
    
    def handle
      @handle ||= url.split('/projects/').last.gsub(/\/$/,"")
    end
    
    def owner
      @owner ||= node.css('h2 span').first.inner_html.gsub(/by/, "").strip
    end
    
    def image_url
      @image_url ||= thumbnail_url.gsub(/photo-little\.jpg/,'photo-full.jpg')
    end
    
    def currency
      @currency ||= pledge_amount.currency.to_s
    end

    def pledge_amount
      @pledge_amount ||= begin
        Money.assume_from_symbol = true
        Money.parse(node.css('.project-stats li')[1].css('strong').inner_html)
      end
    end
    
    def pledge_percent
      @pledge_percent ||= node.css('.project-stats li strong').inner_html.gsub(/\,/,"").to_i * 1.0
    end
    
    def pledge_deadline
      @pledge_deadline ||= Time.parse(node.css('.project-stats .ksr_page_timer').attr('data-end_time').value)
    end

    def to_hash
      {
        :id              => id,
        :name            => name,
        :handle          => handle,
        :url             => url,
        :description     => description,
        :owner           => owner,
        :pledge_amount   => pledge_amount.format,
        :pledge_percent  => pledge_percent,
        :pledge_deadline => pledge_deadline.to_s,
        :image_url       => image_url
      }
    end

    def inspect
      to_hash.inspect
    end
    
    #######################################################
    private
    #######################################################

    #Use image_url instead.
    def thumbnail_url
      node.css('.project-thumbnail img').first.attribute('src').to_s
    end
    
  end
end

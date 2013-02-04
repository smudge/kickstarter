# encoding: utf-8
require_relative 'common'

module Kickstarter
  class ProjectItem

    attr_reader :node
    
    def initialize(node)
      @node = node
    end
    
    def id
      @id ||= /\/projects\/([0-9]+)\/photo-carousel\.jpg/.match(thumbnail_url)[1].to_i
    end
    
    def name
      @name ||= node.css('.project_name').first.inner_html
    end
    
    def description
      @description ||= node.css('.project_description').first.inner_html
    end
    
    def url
      @url ||= node.attribute('href').to_s.split('?').first
    end
    
    def handle
      @handle ||= url.split('/projects/').last.gsub(/\/$/,"")
    end
    
    def image_url(style = :main)
      @image_url ||= thumbnail_url.split('?').first
      @image_url.gsub(/photo-carousel\.jpg/,"photo-#{style}.jpg")
    end
    

    def to_hash
      {
        :id              => id,
        :name            => name,
        :handle          => handle,
        :url             => url,
        :description     => description,
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
      node.css('.project_thumbnail img').first.attribute('src').to_s
    end
    
  end
end

# Scraper https://vnexpress.net/ to get Article

module Scrapers::ArticleScrappers
  class CafeF < Scrapers::Base
    CATEGORY_PATH = 'bat-dong-san.chn'.freeze
    BASE_URL = 'https://cafef.vn/'.freeze

    def initialize
      super
      @base_url = BASE_URL
    end

    def call
      article_content = page_content(hot_path)
      {
        text: text(article_content),
        images: images(article_content),
        source: base_url + hot_path
      }
    end

    private

    def text(article_content)
      article_content.css('.totalcontentdetail .title').text +
        article_content.css('#mainContent').text
    end

    def images(article_content)
      article_content.css('.totalcontentdetail img').map do |img|
        next if img.attr('src').blank?

        {
          'origin' => img.attr('src')
        }
      end.compact
    end

    def hot_path
      @hot_path ||= page_content(CATEGORY_PATH).css('.firstitem a').first[:href]
    end
  end
end

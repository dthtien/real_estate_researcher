# Scraper https://vnexpress.net/ to get Article

module Scrapers::ArticleScrappers
  class VnExpress < Scrapers::Base
    CATEGORY_PATH = 'doi-song/nha/khong-gian-song'.freeze
    BASE_URL = 'https://vnexpress.net/'.freeze

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
      ['.title_news_detail', '.description'].map do |selector|
        article_content.css('#col_sticky ' + selector).text + "\n"
      end.sum
    end

    def images(article_content)
      article_content.css('#col_sticky img').map do |img|
        next if img.attr('src').include?('data:image/')

        {
          'origin' => img.attr('src')
        }
      end.compact
    end

    def hot_path
      @hot_path ||= begin
        content = page_content(CATEGORY_PATH)

        highlight_article = content.css('article:first-child').first
        highlight_article.css('a').first[:href].gsub!(
          Scrapers::ArticleScrappers::VnExpress::BASE_URL, ''
        )
      end
    end
  end
end

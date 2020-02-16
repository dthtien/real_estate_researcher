module XmlGenerable
  extend ActiveSupport::Concern

  included do
    def self.total_sitemap_files
      @total_sitemap_files = page(1).per(50_000).total_pages
    end

    def self.xml_generate
      total_sitemap_files.times do |page|
        file_path = "#{Rails.root}/public/#{table_name}_sitemap#{page}.xml"
        File.delete(file_path) if File.exist?(file_path)
        File.open(file_path, 'a') do |f|
          slugs = page(page + 1).per(50_000).pluck(:slug)
          slugs.each_with_index do |s, index|
            link_tag = "
              <url>
                <loc>https://toplands.tech/app/#{table_name}/#{s}</loc>
                <changefreq>daily</changefreq>
              </url>
            "

            if index.zero?
              text = '<?xml version="1.0" encoding="UTF-8"?>
                <urlset
                  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
                  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
                  http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
              '

              link_tag = text + link_tag
            end

            if (index + 1) == slugs.size
              link_tag += '</urlset>'
            end

            f.write(link_tag)
          end
        end
      end
    end
  end
end

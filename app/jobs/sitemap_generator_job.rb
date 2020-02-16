class SitemapGeneratorJob < ApplicationJob
  def perform
    Land.xml_generate
    Address.xml_generate

    slack_notifier.ping("
      ----------total sitemap file-------------

      Address: #{Address.total_sitemap_files}
      Land: #{Land.total_sitemap_files}

      -----------------end---------------------
    ")
  end
end

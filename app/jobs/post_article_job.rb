class PostArticleJob < ApplicationJob
  include ActionView::Helpers::NumberHelper
  FRONT_END_URL = 'https://toplands.tech'.freeze

  def perform
    [
      Scrapers::ArticleScrappers::VnExpress, Scrapers::ArticleScrappers::CafeF
    ].each do |klass|
      content = klass.new.call
      post!(content) if content.present? && content[:images].present?
    end
  end

  private

  def message(content)
    <<-TXT
      #{content[:text]}
      Nguồn: #{content[:source]}
      Tìm hiểu thêm giá nhà đất ở TPHCM ở: #{FRONT_END_URL}
    TXT
  end

  def post!(content)
    page = Facebook::Page.new
    options = {}
    images = page.upload_images!(content[:images])
    options[:attached_media] = images.map { |id| { media_fbid: id } }

    page.post!(message(content), options)
  end
end

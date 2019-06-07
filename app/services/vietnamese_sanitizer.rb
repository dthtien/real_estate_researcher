module VietnameseSanitizer
  DICTIONARY = {
    'áàảãạăắặằẳẵâấầẩẫậ': 'a',
    'ÁÀẢÃẠĂẮẶẰẲẴÂẤẦẨẪẬ': 'A',
    'đ': 'd',
    'Đ': 'D',
    'éèẻẽẹêếềểễệ': 'e',
    'ÉÈẺẼẸÊẾỀỂỄỆ': 'E',
    'íìỉĩị': 'i',
    'ÍÌỈĨỊ': 'I',
    'óòỏõọôốồổỗộơớờởỡợ': 'o',
    'ÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢ': 'O',
    'úùủũụưứừửữự': 'u',
    'ÚÙỦŨỤƯỨỪỬỮỰ': 'U',
    'ýỳỷỹỵ': 'y',
    'ÝỲỶỸỴ': 'Y'
  }.freeze

  def self.execute!(sentence)
    origin_chars = DICTIONARY.keys.join
    # => áàảãạăắặằẳẵâấầẩẫậÁÀẢÃẠĂẮẶẰẲẴÂẤẦẨẪẬđĐ...ýỳỷỹỵÝỲỶỸỴ
    changing_chars = ''

    DICTIONARY.each { |key, value| changing_chars << (value * key.length) }
    # => aaaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAdD...yyyyyYYYYY

    sentence.tr(origin_chars, changing_chars)
  end
end
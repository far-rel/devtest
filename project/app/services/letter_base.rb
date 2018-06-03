class LetterBase

  def initialize(url, letter)
    @url = url
    @letter = letter
  end

  def price_base
    html = Requester.new.get(@url)
    doc = Nokogiri::HTML(html)
    page_text = doc.css("body").first.text
    page_text.scan(regexp).count / BigDecimal(100)
  end

  private

  def regexp
    Regexp.new("[#{@letter.upcase}#{@letter.downcase}]")
  end

end

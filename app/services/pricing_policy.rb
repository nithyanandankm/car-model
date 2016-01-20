class PricingPolicy
  attr_accessor :policy, :base_price
  VALID_POLICY = [:flexible, :fixed, :prestige]

  def initialize(policy, base_price)
    policy = policy.strip.downcase
    raise 'Unsupported policy' unless VALID_POLICY.include?(policy.to_sym)

    @policy = policy
    @base_price = base_price.to_i
  end

  def total_price
    return 0 if @base_price.to_i <= 0
    send "#{@policy}_price"
  end

  def fixed_price
    # margin is equal, how many words 'status' can you fnd on site
    # https://developer.github.com/v3/#http-redirects
    #     total_price = base_price + margin
    text = parsed_text('https://developer.github.com/v3/#http-redirects')
    margin = text.scan(/\b(status)\b/i).length
    @base_price + margin.to_i
  end

  def flexible_price
    # margin is equal, how many letters 'a' can you fnd on this site http://reuters.com
    # divided by 100
    #     total_price = base_price * margin
    text = parsed_text('http://www.reuters.com')
    margin = text.to_s.scan(/a/i).size
    margin = margin / 100.00
    (@base_price * margin).to_i
  end

  def prestige_price
    # margin is equal, how many pubDate elements can you fnd on page
    # http://www.yourlocalguardian.co.uk/sport/rugby/rss/
    #     total_price = base_price + margin
    doc = xml_doc('http://www.yourlocalguardian.co.uk/sport/rugby/rss/')
    margin = doc.xpath('//pubDate').size
    @base_price + margin.to_i
  end

  private

  def parsed_text(url)
    doc = html_doc(url)
    doc.css('style,script,title').remove
    doc.xpath('//text()').to_s
  end

  def xml_doc(url)
    Nokogiri::XML open_web(url)
  end

  def html_doc(url)
    Nokogiri::HTML open_web(url)
  end

  def open_web(url)
    Net::HTTP.get(URI.parse(url))
  end
end
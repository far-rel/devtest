class NodeBase

  def initialize(url)
    @url = url
  end

  def price_base
    html = Requester.new.get(@url)
    doc = Nokogiri::HTML(html, &:noblanks)
    count_nodes(doc.css('html').first) / BigDecimal(100)
  end

  private

  def count_nodes(starting_node)
    nodes_to_check = [starting_node]
    counter = 0
    until nodes_to_check.empty?
      node = nodes_to_check.pop
      counter += 1
      nodes_to_check.concat(node.children)
    end
    counter
  end

end

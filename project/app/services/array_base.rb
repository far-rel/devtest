class ArrayBase

  def initialize(url, array_size)
    @url = url
    @array_size = array_size
  end

  def price_base
    json_string = Requester.new.get(@url)
    starting_object = JSON.parse(json_string)
    BigDecimal(count_arrays(starting_object))
  end

  private

  def count_arrays(starting_object)
    objects_to_inspect = [starting_object]
    counter = 0
    until objects_to_inspect.empty?
      object = objects_to_inspect.pop
      if object.is_a?(Array)
        counter += 1 if object.count > @array_size
        objects_to_inspect.concat(object)
      elsif object.is_a?(Hash)
        objects_to_inspect.concat(object.values)
      end
    end
    counter
  end

end

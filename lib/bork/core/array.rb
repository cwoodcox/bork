class Array
  def extract_options!
    if last.is_a?(Hash)
      pop
    else
      {}
    end
  end

  def find(&block)
    if i = find_index(&block)
      at(i)
    else
      false
    end  
  end
end

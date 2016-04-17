module MapsHelper
  def format_link(event_type)
    sanitized_str = event_type.downcase.delete(",").delete("-").gsub("/", " ")
    words = sanitized_str.split(" ")
    link = ""
    words.each_with_index do |word, index|
      if (index == (words.length - 1))
        link += word
      else
        link += (word + "-")
      end
    end

    link
  end
end

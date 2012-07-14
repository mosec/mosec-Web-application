module Expect
  # Contact class returns "contact"
  # TextMessage class returns "text_message"
  def self.normalize_class_to_string(klass)
    klass.name.underscore.downcase
  end
  
  # list parameter is a comma-separated string or an array and returns an array of string(s)
  def self.normalize_string_to_array(list)
    if list.is_a?(String)
      list.split(',')
    elsif list.is_a?(Array)
      list
    end
  end
  
  # phone_number parameter is a string and returns a number as a string
  def self.clean_phone_number(phone_number)
    phone_number.gsub(/\D+/,'')
  end
end
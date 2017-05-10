require 'active_support/core_ext/string'

def process_values(fields_with_values = {})
  fields_with_values.each do |key, value|
    fields_with_values[key] = make_replaces value, key, fields_with_values
  end
end

def make_replaces(text, self_key, fields)
  text.scan(/\[(.*?)\]/).flatten.each do |entry_name|
    key = entry_name.downcase.to_sym
    next if key == self_key || fields[key].nil?
    entry = make_replaces fields[key].dup, key, fields
    # protect already replaced from replacing
    entry.gsub! /\[(.*?)\]/, '%%\1%%'
    text.gsub! "[#{entry_name}]", entry
  end
  # remove already replaced protection
  text.gsub /%%(.*?)%%/, '[\1]'
end

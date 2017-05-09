require 'active_support/core_ext/string'

def process_values(fields_with_values = {})
	result = fields_with_values

	# { text_1: 'text1_value [NUMBER_1]',  number_1: '2' }
	# text_2: 'text2_value [TEXT_1]',

	result.each_with_object({}) do |(key, value), hash|
		repeated_values = []
		while (value.scan(/(?<=\[)(.*?)(?=\])/).flatten - repeated_values).present?
			values = (value.scan(/(?<=\[)(.*?)(?=\])/).flatten - repeated_values)
			values.each do |key2|
				value2 = result[key2.downcase.to_sym]
				value.gsub!("[#{key2}]", value2) if value2 && !repeated_values.include?(key2) && (!value2.index("[#{key2}]"))

				repeated_values << key2 if !value2 || value2.index("[#{key2}]")
			end
		end
		hash[key] = value
	end
end

require './deck'

class Message

	def encrypt(message)
		@message = capitalize_and_strip(message)
		@message = @message.ljust(@message.length + (5 - (@message.length % 5)),'X') unless @message.length % 5 == 0
		convert do |message, keystream, result_array|
		  0.upto(@message.length - 1) { |i| result_array <<	(message[i] + keystream[i]) % 26 }
		end
	end

	def decrypt(encrypted_message)
		@message = capitalize_and_strip(encrypted_message)
		convert do |message, keystream, result_array|
			0.upto(@message.length - 1) { |i| result_array <<	((message[i] > keystream[i]) ? (message[i] - keystream[i]) % 26 : (message[i] + 26 - keystream[i]) % 26)  }
		end
	end

	private
		def convert_letters_to_numbers(message)
			output = Array.new
			message.split('').each { |x| output << x.ord - 64 }
			output
		end

		def convert_numbers_to_letters(array)
			output = ''
			array.each_with_index do |x, i|
				if i % 5 == 0
					output << ' '
				end
				output << (x + 64).chr
			end
			output.strip!
		end

		def generate_keystream(length)
			deck = Deck.new()
			message = Array.new
			1.upto(length) { |x| message << deck.next_keystream_letter }
			message
		end

		def convert
			@result_array = Array.new
			message_array = convert_letters_to_numbers(@message)
			keystream_array = generate_keystream(@message.length)
			result_array = yield(message_array, keystream_array, @result_array)
			convert_numbers_to_letters(@result_array)
		end

		def capitalize_and_strip(message)
			message.upcase.gsub(/[^A-Z]/,'')
		end
end
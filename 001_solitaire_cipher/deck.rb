require './card'

class Deck
	attr_reader :deck_highest_index, :deck

	def initialize
		@deck = Array.new
		1.upto(4) do |suite|
			1.upto(13) do |number|
				case suite
				when 1
					@deck << Card.new(:Clubs, number, number)
				when 2
					@deck << Card.new(:Diamonds, number, number + 13)
				when 3
					@deck << Card.new(:Hearts, number, number + 26)
				when 4
					@deck << Card.new(:Spades, number, number + 39)
				end
			end
		end
		@deck << Card.new(:Joker, 'A', 53)
		@deck << Card.new(:Joker, 'B', 53)
		@deck_highest_index = @deck.length - 1
	end

	def next_keystream_letter
		loop do
			move :Joker, 'A', 1
			move :Joker, 'B', 2
			joker_triple_cut
			bottom_count_cut

			break unless @deck[@deck[0].value].value == 53
		end
		@deck[@deck[0].value].value
	end

	private
		def move(suite, number, places)
			places.downto(1) do |i|
				location = locate_card suite, number
				if location == @deck_highest_index
					@deck.unshift(@deck.delete_at(@deck_highest_index))
					location = 0
				end
				old_pos = location
				new_pos = location + 1
				@deck[new_pos], @deck[old_pos] = @deck[old_pos], @deck[new_pos]
			end
		end

		def locate_card(suite, number)
			result = -1
			@deck.each_with_index do |card, index|
				if card.suite == suite and card.number == number
					result = index
					break
				end
			end
			result
		end

		def joker_triple_cut
			first_joker_position = locate_card :Joker, 'A'
			second_joker_position = locate_card :Joker, 'B'
			if first_joker_position > second_joker_position
				temp = first_joker_position
				first_joker_position = second_joker_position
				second_joker_position = temp
			end
			if first_joker_position == 0
				first_partition = []
			else
				first_partition = @deck[0..(first_joker_position - 1)]
			end
			if second_joker_position == @deck_highest_index
				third_partition = []
			else
				third_partition = @deck[(second_joker_position + 1)..@deck_highest_index]
			end
			second_partition = @deck[first_joker_position..second_joker_position]
			@deck = third_partition + second_partition + first_partition
		end

		def bottom_count_cut
			if @deck[@deck_highest_index].suite != :Joker
				first_partition = @deck[0..(@deck[@deck_highest_index].value - 1)]
				second_partition = @deck[(@deck[@deck_highest_index].value)..(@deck_highest_index - 1)]
				third_partition =  @deck[@deck_highest_index..@deck_highest_index]
				@deck = second_partition + first_partition + third_partition
			end
		end
end
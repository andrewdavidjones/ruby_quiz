class Card
	attr_reader :suite, :value, :number

	def initialize(suite, number, value)
		@suite = suite
		@number = number
		@value = value
	end
end
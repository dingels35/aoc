class DayN
  attr_reader :input, :rows

  def initialize(input)
    @input = input
    @rows = input.split("\n")
  end

  def step1
    
  end

  def step2 
    
  end

  private

end

test_input = 
"1
2
3"

input = File.read('dayN.txt')

puts "Step 1 (test): #{DayN.new(test_input).step1}"
puts "Step 1: #{DayN.new(input).step1}"
puts "Step 2 (test): #{DayN.new(test_input).step2}"
puts "Step 2: #{DayN.new(input).step2}"


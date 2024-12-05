class Day3
  attr_reader :input, :rows

  def initialize(input)
    @input = input
  end

  def step1
    process_instructions(@input)
  end

  def step2 
    filtered_instructions = @input
      .split("do()").map{ |item| item.split("don't()").first }
      .join("\n")

    # puts filtered_instructions
    process_instructions(filtered_instructions)
  end

  private

  def process_instructions(instructions)
    instructions
      .scan(/mul\((\d+\,\d+)\)/)
      .flatten
      .sum{ |item| item.split(",").map(&:to_i).reduce(&:*) }
  end

end

test_input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
test_input2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

input = File.read('Day3.txt')

puts "Step 1 (test): #{Day3.new(test_input).step1}"
puts "Step 1: #{Day3.new(input).step1}"
puts "Step 2 (test): #{Day3.new(test_input2).step2}"
puts "Step 2: #{Day3.new(input).step2}"


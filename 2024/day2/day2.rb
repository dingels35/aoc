

class Day2
  attr_reader :input, :reports

  def initialize(input)
    @input = input
    @reports = input.split("\n")
  end

  def step1
    reports.keep_if{ |report| report_is_safe1(report) }.length
  end

  def step2 
    reports.keep_if{ |report| report_is_safe2(report) }.length
  end

  private

  def report_is_safe1(report)
    report_bad_level(report).nil?
  end

  def report_is_safe2(report)
    index_of_bad_level = report_bad_level(report)
    return true if index_of_bad_level.nil? 

    new_report = remove_level_at_index(report, index_of_bad_level)
    return true if report_bad_level(new_report).nil?

    new_report = remove_level_at_index(report, index_of_bad_level-1)
    return true if report_bad_level(new_report).nil?
    
    new_report = remove_level_at_index(report, 0)
    report_bad_level(new_report).nil?
  end

  def report_bad_level(report)
    levels = levels_for(report)
    direction = levels[1] > levels[0]

    (1..levels.length-1).each do |i|
      return i if levels[i] == levels[i-1]
      return i if (levels[i] - levels[i-1]).abs > 3 
      return i unless direction == (levels[i] > levels[i-1])
    end

    nil 
   end

   def remove_level_at_index(report, idx)
    levels_for(report).reject.with_index{|v, i| i == idx }.join(" ")
   end

   def levels_for(report)
    report.split(" ").map(&:to_i)
   end

end

test_input = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

input = File.read('day2.txt')

puts "Step 1 (test): #{Day2.new(test_input).step1}"
puts "Step 1: #{Day2.new(input).step1}"
puts "Step 2 (test): #{Day2.new(test_input).step2}"
puts "Step 2: #{Day2.new(input).step2}"


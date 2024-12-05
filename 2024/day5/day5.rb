class Day5
  attr_reader :input, :rows

  def initialize(input)
    @input = input
    @rules, @pages = input.split("\n\n")
    @exclude_rules = Regexp.new(@rules.split("\n").map{ |r| r.split("|").reverse.join(".*") }.join("|"))
    @pages = @pages.split("\n")
  end

  def step1
    @pages
      .keep_if { |page| !(page =~ @exclude_rules) }
      .map { |page| page.split(",") }
      .sum { |page| page[page.length/2].to_i }
  end

  def step2 
    @pages
      .keep_if { |page| (page =~ @exclude_rules) }
      .map { |page| reorder_pages(page) }
      .map { |page| page.split(",") }
      .sum { |page| page[page.length/2].to_i }
  end

  private

  def reorder_pages(page)
    # puts "page: #{page}"
    while ((matches = page.scan(@exclude_rules)).any?)
      match = matches.first.split(",")
      to_replace = ([match.last] + match[1..-2] + [match.first]).join(",")
      # puts "#{match} - #{to_replace}"
      page.sub!(matches.first, to_replace)
    end 
    page
  end

end

test_input = 
"47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"

input = File.read('Day5.txt')

puts "Step 1 (test): #{Day5.new(test_input).step1}"
puts "Step 1: #{Day5.new(input).step1}"
puts "Step 2 (test): #{Day5.new(test_input).step2}"
puts "Step 2: #{Day5.new(input).step2}"


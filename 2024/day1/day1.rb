
input = "3   4
4   3
2   5
1   3
3   9
3   3"

input = File.read('day1.txt')

vals1 = []
vals2 = []
values = input.split("\n").map{|row| row.split(" ")}.each{ |v1, v2| vals1 << v1.strip.to_i; vals2 << v2.strip.to_i  }

vals1 = vals1.sort
vals2 = vals2.sort


sum = 0
(0..vals1.length-1).each do |i|
  sum += (vals1[i] - vals2[i]).abs
end

puts "Part 1: #{sum}"


vals1_count = vals1.inject(Hash.new(0)) do |counts, val| 
  counts[val] +=1
  counts
end

vals2_count = vals2.inject(Hash.new(0)) do |counts, val| 
  counts[val] +=1
  counts
end

similarity_score = vals1_count.inject(0) do |tot, (val, ct)|
  tot + val * ct * (vals2_count[val] || 0)
end

puts "Part 2: #{similarity_score}"


# puts vals1_count
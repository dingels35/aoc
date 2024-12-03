
# How many measurements are larger than the previous measurement?
values = File.read('day1.txt').split("\n").map(&:to_i)

# values = [199,200,208,210,200,207,240,269,260,263]

ct = 0
ct2 = 0
(1..(values.length-1)).each do |i|
  inc = values[i] > values[i-1]
  ct = ct + 1 if values[i] >= values[i-1]
  # puts "#{values[i]} - #{inc} - #{ct}"
  # ct2 = ct2 + 1 if values[i] < values[i-1]
end
puts ct

ct = 0
(1..(values.length-3)).each do |i|
  ct = ct + 1 if (values[i+2]) > values[i-1]
end
puts ct

# for each of these i had to add 1 to my output.  not sure why

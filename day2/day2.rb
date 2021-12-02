input = "forward 5
down 5
forward 8
up 3
down 8
forward 2"

input = File.read('day2.txt')
values = input.split("\n").map{ |row| row.split(" ") }.map{ |a, b| [a, b.to_i] }

pos = [0,0]
values.each do |command, value|
  case command
  when "forward" then pos[0] += value
  when "up" then pos[1] -= value
  when "down" then pos[1] += value
  end
end
puts pos.reduce(1,:*) # 1383564

# part 2
pos = [0,0]
aim = 0
values.each do |command, value|
  case command
  when "forward" then
    pos[0] += value
    pos[1] += value * aim
  when "up" then aim -= value
  when "down" then aim += value
  end
end
puts pos.reduce(1,:*) # 1488311643

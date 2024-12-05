class Day4
  attr_reader :input, :rows

  def initialize(input)
    @input = input
    @rows = input.split("\n")
    @columns = @rows.map(&:chars).transpose.map(&:join)
    @diagnals1 = diagnals(@rows)
    @diagnals2 = diagnals(@rows.map(&:reverse))
    # puts diagnals(@rows.map(&:chars))
    # puts "***"
    # puts @rows.map(&:reverse).reverse
    # puts diagnals(@columns.map(&:chars))
  end

  def step1

    @rows.sum{ |r| count_in_row(r) } +
    @columns.sum{ |r| count_in_row(r) } +
    @diagnals1.sum{ |r| count_in_row(r) } +
    @diagnals2.sum{ |r| count_in_row(r) }
  end

  def step2 
    # puts @rows
    matrix = @rows.map(&:chars)
    ct = 0
    (1..matrix.length-2).each do |i|
      (1..matrix[i].length-2).each do |j|
        next unless matrix[i][j] == "A"
        d1 = (matrix[i-1][j-1] + matrix[i+1][j+1]).chars.sort.join
        d2 = (matrix[i-1][j+1] + matrix[i+1][j-1]).chars.sort.join
        # puts "#{d1}, #{d2} - #{i} - #{j}"
        ct = ct + 1 if d1 == "MS" && d2 == "MS"
      end
    end
    ct
  end

  private

  def count_in_row(row)
    ct = row.scan("XMAS").count + row.scan("SAMX").count
    # puts "#{row} - #{ct}"
    ct
  end

  def diagnals(rows)
    # 123
    # 456
    # 789

    # 1 
    # 42
    # 753
    # 86
    # 9

    # 0,0
    # 1,0 - 0,1
    # 2,0 - 1,1 - 0,2 
    # 2,1 - 1,2 
    # 2,2 
    matrix = rows.map(&:chars)

    (0..@rows.length-2).map do |i|
      i.downto(0).map do |j|
        matrix[j][i-j]
      end.join
    end +

    (0..@rows.length-1).map do |i|
      # puts "** #{i}"
      (0..rows.length-1-i).map do |j|
        # puts "#{rows.length-1-j}, #{j+i}"
        matrix[rows.length-1-j][i+j]
      end.join
    end

  end

end



test_input = 
"MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

test_input1 = 
"....XXMAS.
.SAMXMS...
...S..A...
..A.A.MS.X
XMASAMX.MM
X.....XA.A
S.S.S.S.SS
.A.A.A.A.A
..M.M.M.MM
.X.X.XMASX"

# test_input = 
# "123
# 456
# 789"

test_input2 = 
".M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
.........."

input = File.read('Day4.txt')

puts "Step 1 (test): #{Day4.new(test_input).step1}"
puts "Step 1: #{Day4.new(input).step1}"
puts "Step 2 (test): #{Day4.new(test_input).step2}"
puts "Step 2: #{Day4.new(input).step2}"

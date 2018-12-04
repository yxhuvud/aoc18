input =
  File.read("day3.input")

# input =
# <<-EOS
# #1 @ 1,3: 4x4
# #2 @ 3,1: 4x4
# #3 @ 5,5: 2x2
# EOS

SIZE = 1000

square = SIZE.times.map { [0] * SIZE }.to_a

parsed =
  input.lines.compact_map do |row|
    m = row.match(/#(\d+) @ (\d+),(\d+): (\d+)+x(\d+)/)
    next unless m
    x, y = m[2].to_i, m[3].to_i
    a, b = m[4].to_i, m[5].to_i
    {x, y, a, b, m[1].to_i}
  end

parsed.each do |(x, y, a, b, _)|
  a.times do |i|
    b.times do |j|
      square[x + i][y + j] += 1
    end
  end
end

# puts square.map(&.join).join("\n")
puts square.sum &.count &.> (1)

parsed.each do |(x, y, a, b, id)|
  found = true
  a.times do |i|
    b.times do |j|
      found &&= square[x + i][y + j] == 1
    end
  end
  if found
    puts "part2"
    puts id
  end
end

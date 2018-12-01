input =
  File.read("day1.input")
    .split
    .map(&.to_i)

puts "part1"
puts input.sum

seen = Set(Int32).new
acc = 0
input.cycle do |val|
  seen << acc
  acc += val
  if seen.includes?(acc)
    puts "part2"
    puts acc
    exit
  end
end

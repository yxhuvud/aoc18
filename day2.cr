require "levenshtein"

input =
  File.read("day2.input")
    .split

twos = 0
threes = 0
input.each do |i|
  by_size = i.chars
    .group_by(&.itself).values
    .group_by(&.size)
  twos += 1 if by_size[2]?
  threes += 1 if by_size[3]?
end
puts "part1"
puts twos * threes

input.each do |i|
  if other = input.find { |a| Levenshtein.distance(i, a) == 1 }
    common = i.chars.zip(other.chars)
      .select { |(a, b)| a == b }
      .map(&.[1]).join
    puts "part2"
    puts common
    break
  end
end

# part2 alternative:
common = input.map(&.chars).each_combination(2).map do |(i1, i2)|
  i1.zip(i2)
    .select { |(a, b)| a == b }
    .map(&.[1]).join
end.max_by &.size
puts "part2alt"
puts common

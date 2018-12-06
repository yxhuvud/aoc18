input =
  File.read("day6.input")
    .lines

coords = input
  .map(&.split(",").map(&.to_i))
  .map { |v| {v[0], v[1]} }
  .to_set

def dist(c1, c2)
  (c1[0] - c2[0]).abs + (c1[1] - c2[1]).abs
end

SIZE = 360

map = Hash(Tuple(Int32, Int32), Tuple(Int32, Int32)).new

SIZE.times do |i|
  SIZE.times do |j|
    min = coords.min_of { |c| dist({i, j}, c) }
    lengths = coords.select { |c| dist({i, j}, c) == min }
    if lengths.size == 1
      map[{i, j}] = lengths.first
    else
      map[{i, j}] = {-1, -1}
    end
  end
end

borders = Set(Tuple(Int32, Int32)).new
SIZE.times do |i|
  {
    {i, 0}, {i, SIZE - 1}, {0, i}, {SIZE - 1, i},
  }.map { |c| borders << map[c] }
end
finite = coords - borders
counts = map.group_by(&.[1]).transform_values &.size

puts "part1"
p finite.max_of { |f| counts[f] }

S2 = 0..360
x = S2.sum do |i|
  S2.count do |j|
    coords.sum do |c|
      dist(c, {i, j})
    end < 10000
  end
end

puts "part2"
puts x

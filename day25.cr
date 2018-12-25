input =
  File.read("day25.input")

data = input.lines.map &.split(',').map(&.to_i)
neighbours = Hash(Int32, Array(Int32)).new

def dist(d, d2)
  (d[0] - d2[0]).abs + (d[1] - d2[1]).abs + (d[2] - d2[2]).abs + (d[3] - d2[3]).abs
end

data.each_with_index do |d, i|
  n = Array(Int32).new
  data.each_with_index do |d2, i2|
    n << i2 if dist(d, d2) <= 3
  end
  neighbours[i] = n
end

used = Set(Int32).new

constellations = neighbours.compact_map do |i, ns|
  next if used.includes?(i)

  constellation = Set(Int32).new
  queue = Deque(Int32).new
  queue << i
  while n = queue.shift?
    constellation << n
    used << n
    queue.concat neighbours[n].reject { |i2| used.includes?(i2) }
  end
  constellation
end

p constellations.size

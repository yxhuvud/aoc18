input = File.read("day18.input")

alias Pos = Tuple(Int32, Int32)
map = input.lines.map &.chars
maxx = map.size - 1
maxy = map[0].size - 1

def adjacent(pos, maxx, maxy)
  { {1, 0}, {0, 1}, {1, 1}, {-1, 0}, {0, -1}, {-1, -1}, {-1, 1}, {1, -1} }
    .map { |o| {pos[0] + o[0], pos[1] + o[1]} }
    .select { |(x, y)| x >= 0 && x <= maxx && y >= 0 && y <= maxy }
end

precalc_adj = (0..maxx).map do |x|
  (0..maxy).map { |y| adjacent({x, y}, maxx, maxy) }
end

def gen(map, adj)
  map.map_with_index do |l, x|
    l.map_with_index do |c, y|
      adjacent = adj[x][y]
      trees = adjacent.count { |p| map[p[0]][p[1]] == '|' }
      lumberyards = adjacent.count { |p| map[p[0]][p[1]] == '#' }
      if c == '.' && trees >= 3
        '|'
      elsif c == '|' && lumberyards >= 3
        '#'
      elsif c == '#' && (trees.zero? || lumberyards.zero?)
        '.'
      else
        c
      end
    end
  end
end

maps = Array(typeof(map)).new
maps << map
seen = Hash(typeof(map), Int32).new
seen[map] = 0

loop_start = -1
loop_length = -1
(1..Int32::MAX).each do |i|
  map = gen(map, precalc_adj)
  if v = seen[map]?
    loop_start = v
    loop_length = i - v
    break
  else
    seen[map] = i
    maps << map
  end
end

def count(map)
  map.sum(&.count &.==('|')) *
    map.sum(&.count &.==('#'))
end

map = maps[loop_start + ((1000000000 - loop_start) % loop_length)]

puts "part1: #{count maps[10]}"
puts "part2: #{count map}"

input = File.read "day17.input"

alias Pos = Tuple(Int32, Int32)
map = Hash(Pos, Char).new

def parse(l)
  l.split(/\D+/)
    .reject(&.size.==(0))
    .map(&.to_i)
end

input.lines.each do |l|
  vs = parse(l)
  if l[0] == 'x'
    (vs[1]..vs[2]).each do |y|
      map[{vs[0], y}] = '#'
    end
  else
    (vs[1]..vs[2]).each do |x|
      map[{x, vs[0]}] = '#'
    end
  end
end

miny, maxy = map.keys.map(&.last).minmax
minx, maxx = map.keys.map(&.first).minmax

def floodfill(map, maxy, pos)
  return true if pos[1] > maxy
  case map[pos]?
  when '#'
    false
  when '|'
    return true
  when '~'
    return false
  else
    map[pos] = '|'
    flow = floodfill(map, maxy, {pos[0], pos[1] + 1})
    return true if flow
    left = {pos[0] - 1, pos[1]}
    right = {pos[0] + 1, pos[1]}
    map[pos] = '|'
    flow_left = !map[left]? && floodfill(map, maxy, left)
    flow_right = !map[right]? && floodfill(map, maxy, right)
    case {flow_right, flow_left}
    when {true, false}
      while map[left] == '~'
        map[left] = '|'
        left = {left[0] - 1, pos[1]}
      end
    when {false, true}
      while map[right]? == '~'
        map[right] = '|'
        right = {right[0] + 1, pos[1]}
      end
    when {false, false}
      map[pos] = '~'
    end
    flow_right || flow_left
  end
end

floodfill(map, maxy, {500, 0})

part1 = 0
part2 = 0
(miny..maxy).each do |y|
  (minx - 1..maxx + 1).each do |x|
    part1 += 1 if map[{x, y}]? == '|' || map[{x, y}]? == '~'
    part2 += 1 if map[{x, y}]? == '~'
  end
end
puts "part1: #{part1}"
puts "part2: #{part2}"

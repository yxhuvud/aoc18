input = File.read("day20.input")[1..-1].chars

alias Pos = Tuple(Int32, Int32)
start = {0, 0}
seen = { {0, 0} => 0 }
DIRS = { 'N' => {1, 0}, 'S' => {-1, 0}, 'W' => {0, 1}, 'E' => {0, -1} }

def walk(input, pos : Pos, i, stop_condition, seen, push_back, return_from)
  case c = input[i]
  when stop_condition
    i += 1 unless push_back
    return {pos, i}
  when 'W', 'S', 'E', 'N'
    offset = DIRS[c]
    new_pos = {pos[0] + offset[0], pos[1] + offset[1]}
    seen[new_pos] = seen[new_pos]? ? {seen[new_pos], seen[pos] + 1}.min : seen[pos] + 1
    walk(input, new_pos, i + 1, stop_condition, seen, push_back, return_from)
  when '('
    pos2, i3 = walk(input, pos, i + 1, ')', seen, false, pos)
    walk(input, pos2, i3 + 1, stop_condition, seen, push_back, return_from)
  when '|'
    walk(input, return_from, i + 1, stop_condition, seen, true, return_from)
  else
    raise "Unreachable: c: #{c} #{i}"
  end
end

walk(input.dup, start, 0, '$', seen, false, start)
puts "part1: #{seen.values.max}"
puts "part2: #{seen.values.count &.>=(1000)}"

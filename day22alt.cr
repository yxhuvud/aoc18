require "./priority_queue"

DEPTH  = 3879
TARGET = {8, 713}

alias Pos = Tuple(Int32, Int32)

def calc(map, x, y)
  geologic =
    case {x, y}
    when {0, 0} then 0
    when TARGET then 0
    when {_, 0} then x * 16807
    when {0, _} then y * 48271
    else             map[{x - 1, y}] * map[{x, y - 1}]
    end
  (geologic + DEPTH) % 20183
end

def build_map(dimx, dimy)
  map = Hash(Pos, Int32).new { |h, p| h[p] ||= calc(h, p[0], p[1]) }
  0.upto(dimx) do |x|
    0.upto(dimy) do |y|
      map[{x, y}] = calc(map, x, y)
    end
  end
  map
end

map = build_map(TARGET[0], TARGET[1])

puts "Part1:"
p map.values.sum { |v| v % 3 }

enum Equipped
  None
  Gear
  Torch
end
ALLOWED = [
  {Equipped::Gear, Equipped::Torch},
  {Equipped::Gear, Equipped::None},
  {Equipped::Torch, Equipped::None},
]

alias Cost = Int32
alias State = Tuple(Pos, Equipped, Cost)

def neighbours(map, state : State)
  pos, equipped, cost = state
  moves =
    { {-1, 0}, {0, -1}, {1, 0}, {0, 1} }
      .map { |p| {pos[0] + p[0], pos[1] + p[1]} }
      .reject { |p| p[0] < 0 || p[1] < 0 }
      .select! { |p| ALLOWED[map[p] % 3].includes?(equipped) }

  states = moves.map { |p| {p, equipped, cost + 1} }
  states << {pos, ALLOWED[map[pos] % 3].find(&.!=(equipped)).not_nil!, cost + 7}
  states
end

def estimate(map, state)
  pos, equipped, cost = state
  dist = (TARGET[0] - pos[0]).abs + (TARGET[1] - pos[1]).abs
  dist + cost # adding cost to switch to Torch make it worse.
end

queue = PriorityQueue(Cost, State).new
start = { {0, 0}, Equipped::Torch, 0 }
queue.insert(start, estimate(map, start))
seen = Hash(Tuple(Pos, Equipped), Cost).new
seen[{ {0, 0}, Equipped::Torch }] = 0

res = -1
while state = queue.pull
  pos, equipped, cost = state
  if pos == TARGET && equipped == Equipped::Torch
    res = cost
    break
  end
  neighs = neighbours(map, state)
    .reject! { |s| (v = seen[{s[0], s[1]}]?) && v <= s[2] }
  neighs.each do |s|
    seen[{s[0], s[1]}] = s[2]
    queue.insert(s, estimate(map, s))
  end
end

puts "part2"
p res

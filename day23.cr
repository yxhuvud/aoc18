input = File.read "day23.input"

bots = input.lines.map do |l|
  num = /-?\d+/
  l.match(/<(#{num}),(#{num}),(#{num})>, r=(\d+)/).not_nil!.captures.not_nil!.map &.not_nil!.to_i
end
best_bot = bots.max_by &.last

def dist(bot1, bot2)
  (bot1[0] - bot2[0]).abs + (bot1[1] - bot2[1]).abs + (bot1[2] - bot2[2]).abs
end

puts "part1"
p bots.count { |b| dist(b, best_bot) <= best_bot.last }

def overlaps(pos, range, bots)
  bots.count { |b| dist(pos, b) <= b[3] + range }
end

minx = bots.min_of { |b| b[0] - b[3] }
maxx = bots.max_of { |b| b[0] + b[3] }
miny = bots.min_of { |b| b[1] - b[3] }
maxy = bots.max_of { |b| b[1] + b[3] }
minz = bots.min_of { |b| b[2] - b[3] }
maxz = bots.max_of { |b| b[2] + b[3] }
mid = {(minx + maxx) // 2, (miny + maxy) // 2, (minz + maxz) // 2}
range = {maxx - minx, maxy - miny, maxz - minz}.max // 2

while range != 0
  new_range = {(range * 2 + 2) // 3, range - 1}.min
  diff = range - new_range
  mid = {
    {mid[0] + diff, mid[1], mid[2]},
    {mid[0] - diff, mid[1], mid[2]},
    {mid[0], mid[1] + diff, mid[2]},
    {mid[0], mid[1] - diff, mid[2]},
    {mid[0], mid[1], mid[2] + diff},
    {mid[0], mid[1], mid[2] - diff},
    {mid[0], mid[1], mid[2]},
  }.max_by { |pos| overlaps(pos, new_range, bots) }
  range = new_range
end

puts "part2"
p mid.sum &.abs

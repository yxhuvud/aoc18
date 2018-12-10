input =
  File.read("day10.input")

record Point, x : Int32, y : Int32 do
  def +(other)
    Point.new(x + other.x, y + other.y)
  end

  def dy(other)
    (y - other.y).abs
  end
end

positions = [] of Point
velocities = positions.dup
input.lines.each do |l|
  part = /< *(-?\d+), *(-?\d+)>/
  if m = l.match /#{part}.*#{part}/
    positions << Point.new(m[1].to_i, m[2].to_i)
    velocities << Point.new(m[3].to_i, m[4].to_i)
  end
end

size = {10, 65}
board = [] of Array(Char)
size[0].times do 
  board << Array(Char).new(size[1], '.')
end

def print(board, positions)
  minx = positions.min_of &.x
  miny = positions.min_of &.y
  positions.each { |p| board[p.y - miny][p.x - minx] = '#' }
  puts board.map(&.join).join("\n")
end

11000.times do |i|
  positions.size.times { |i| positions[i] += velocities[i] }
  next if positions[0].dy(positions[1]) > 10

  maxdist = positions.max_of do |p1|
    positions.max_of { |p2| p1.dy(p2) }
  end
  
  if maxdist < 10
    puts "part1"
    print(board, positions)
    puts "part2"
    p i+1
  end
end

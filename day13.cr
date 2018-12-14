input =
  File.read("day13.input")

record(Pos, x : Int32, y : Int32) do
  include Comparable(self)

  def next(dir)
    case dir
    when '<' then Pos.new(x, y - 1)
    when '>' then Pos.new(x, y + 1)
    when 'v' then Pos.new(x + 1, y)
    else          Pos.new(x - 1, y)
    end
  end

  def <=>(other)
    v = x <=> other.x
    v == 0 ? y <=> other.y : v
  end
end

class Cart
  property at : Pos
  property dir : Char
  property turning : Int32

  def initialize(@at, @dir, @turning)
  end

  def unmark(cartmap)
    cartmap[at.x][at.y] = nil
  end

  def mark(collisions, cartmap)
    if other = cartmap[at.x][at.y]?
      collisions << self
      collisions << other
      cartmap[at.x][at.y] = nil
    else
      cartmap[at.x][at.y] = self
    end
  end

  def to_s
    {at.y, at.x}.join(",")
  end
end

carts = Array(Cart).new
map = Array(Array(Char)).new

input.lines.each_with_index do |l, x|
  cur = Array(Char).new
  map << cur
  l.chars.each_with_index do |r, y|
    pos = Pos.new(x, y)
    case r
    when '>', '<'
      carts << Cart.new(pos, r, 0)
      r = '-'
    when '^', 'v'
      carts << Cart.new(pos, r, 0)
      r = '|'
    end
    cur << r
  end
end

cartmap = Array(Array(Cart | Nil)).new(map.size) { Array(Cart | Nil).new(map[0].size) { nil } }

def neighbors(dir : Char)
  case dir
  when '>' then {'^', '>', 'v'}
  when '<' then {'v', '<', '^'}
  when 'v' then {'>', 'v', '<'}
  else          {'<', '^', '>'}
  end
end

def turn(n, dir, turning)
  case n
  when '+'
    dir = neighbors(dir)[turning]
    turning = (turning + 1) % 3
  when '\\'
    dir =
      case dir
      when '>' then 'v'
      when '<' then '^'
      when '^' then '<'
      else          '>'
      end
  when '/'
    dir =
      case dir
      when '>' then '^'
      when '<' then 'v'
      when '^' then '>'
      else          '<'
      end
  end
  {dir, turning}
end

first = nil
second = nil
collisions = Array(Cart).new

loop do
  carts.each_with_index do |c, i|
    next if collisions.includes?(c)
    c.unmark(cartmap)
    c.at = c.at.next(c.dir)
    c.dir, c.turning = turn(map[c.at.x][c.at.y], c.dir, c.turning)
    first ||= c.to_s unless c.mark(collisions, cartmap)
    carts[i] = c
  end
  carts -= collisions
  carts.sort_by! &.at
  if carts.size <= 1
    second = carts.map(&.to_s).join
    break
  end
end

puts "part1"
puts first
puts "part2"
puts second

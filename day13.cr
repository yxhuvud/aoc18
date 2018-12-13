input =
  File.read("day13.input")

record(Pos, x : Int32, y : Int32) do
  include Comparable(self)

  def next(dir)
    case dir
    when '<'
      Pos.new(x, y-1)
    when '>'
      Pos.new(x, y+1)
    when 'v'
      Pos.new(x+1, y)
    when '^'
      Pos.new(x-1, y)
    else
      raise "hell1"
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
      false
    else
      cartmap[at.x][at.y] = self
      true
    end
  end

  def to_s
    {at.y, at.x}.join(",")
  end
end
collisions = Array(Cart).new

carts = Array(Cart).new
map = Array(Array(Char)).new

input.lines.each_with_index do |l, x|
  cur = Array(Char).new
  map << cur
  l.chars.each_with_index do |r, y|
    pos = Pos.new(x,y)
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

cartmap = Array(Array(Cart|Nil)).new(map.size) { Array(Cart|Nil).new(map[0].size){ nil } }
carts.each { |c| c.mark(collisions, cartmap) }

def neighbors(dir : Char)
  if dir == '>'
    {'^','>','v' }
  elsif dir == '<'
    { 'v', '<', '^' }
  elsif dir == 'v'
    {'>', 'v','<' }
  elsif dir == '^'
    { '<', '^', '>' }
  else
    raise "hell3"
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
      when '>'
        'v'
      when '<'
        '^'
      when '^'
        '<'
      when 'v'
        '>'
      else
        raise "hell4"
      end
  when '/'
    dir =
      case dir
      when '>'
        '^'
      when '<'
        'v'
      when '^'
        '>'
      when 'v'
        '<'
      else
        raise "hell5"
      end
  end
  {dir, turning}
end

loop do
  carts.each_with_index do |c, i|
    next if collisions.includes?(c)
    c.unmark(cartmap)
    next_pos = c.at.next(c.dir)
    next_dir, turning = turn(map[next_pos.x][next_pos.y], c.dir, c.turning)
    c.at = next_pos
    c.dir = next_dir
    c.turning = turning
    c.mark(collisions, cartmap)
    carts[i] = c
  end
  carts -= collisions
  carts.sort_by! &.at
  if carts.size <= 1
    puts carts.map(&.to_s).join
    exit
  end
end

# fails:
# 18,58

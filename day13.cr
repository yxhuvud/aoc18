input =
  File.read("day13.input")

# input =
#   <<-EOS
# /->-\\         
# |   |  /----\\ 
# | /-+--+-\\  | 
# | | |  | v  | 
# \\-+-/  \\-+--/ 
#   \\------/    
# EOS

#raise "hell" unless input.lines.map(&.size).uniq.size == 1

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

record(Cart, at : Pos, dir : Char, turning : Int32) do
  def mark(cartmap, v)
    if v && cartmap[at.x][at.y]?
      raise "#{at.y},#{at.x}"
    else
      cartmap[at.x][at.y] = v
    end
  end
end


alias Connection = Tuple(Pos, Pos)

carts = Array(Cart).new
connections = Set(Connection).new
map = Array(Array(Char)).new

maxx, maxy = 0, 0
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
    maxx = {maxx,x}.max
    maxy = {maxy,y}.max
  end
end

cartmap = Array(Array(Bool)).new(maxx+1) { Array(Bool).new(maxy+1) {false} }
carts.each do |c| c.mark(cartmap, true) end

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
    next_pos = c.at.next(c.dir)
    c.mark(cartmap, false)
    next_dir, turning = turn(map[next_pos.x][next_pos.y], c.dir, c.turning)
    new_c = Cart.new(next_pos, next_dir, turning )
#    puts "moving cart #{c.inspect} #{new_c.inspect}"
    new_c.mark(cartmap, true)
    carts[i] = new_c
  end
  carts.sort_by &.at
end

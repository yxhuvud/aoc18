input =
  File.read("day24.input")
    .lines

# input = <<-EOS
# Immune System:
# 17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
# 989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

# Infection:
# 801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
# 4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
# EOS
#   .lines

class Unit
  property count : Int32
  property hp : Int32
  property weak : Array(String)
  property immune : Array(String)
  property damage : Int32
  property damage_type : String
  property initiative : Int32

  def initialize(@count, @hp, @weak, @immune, @damage, @damage_type, @initiative)
  end

  def to_s
    "#{count}: #{initiative}"
  end

  def effective_power
    count * damage
  end

  def power_comp
    {-effective_power, -initiative}
  end

  def attack_comp(o)
    {-damage_to(o), -o.effective_power, -o.initiative}
  end

  def damage_to(other)
    if other.weak.includes?(damage_type)
      2 * effective_power
    elsif other.immune.includes?(damage_type)
      0
    else
      effective_power
    end
  end

  def attack(other)
    deadcount = damage_to(other) // other.hp
    other.count -= deadcount
  end

  def dead?
    count <= 0
  end
end

def read_army(lines)
  name = lines.shift
  units = [] of Unit
  while line = lines.shift?
    break if line.size == 0
    m = line.match(/(\d+) units each with (\d+) hit points( \(.*\))? with an attack that does (\d+ \w+) damage at initiative (\d+)/)
    w = i = nil
    if m
      if props = m[3]?
        if m2 = props.match(/immune to ([\w, ]+)/)
          i = m2[1].split(", ")
        end
        if m2 = props.match(/weak to ([\w, ]+)/)
          w = m2[1].split(", ")
        end
      end
      w ||= [""]
      i ||= [""]
      d, t = m[4].split
      units << Unit.new m[1].to_i, m[2].to_i, w, i, d.to_i, t, m[5].to_i
    else
      raise line
    end
  end
  units
end

immune = read_army(input)
infection = read_army(input)

def select_targets(a1, a2, attacking, attacked)
  a1.each do |u|
    target = (a2 - attacked)
      .sort_by { |o| u.attack_comp(o) }
      .reject! { |o| u.damage_to(o).zero? }
      .first?
    if target
      attacking << {u, target}
      attacked << target
    end
  end
end

def fight(army1, army2)
  oa1 = army1.sort_by &.power_comp
  oa2 = army2.sort_by &.power_comp

  attacking = Array(Tuple(Unit, Unit)).new
  attacked = Array(Unit).new
  select_targets(oa1, oa2, attacking, attacked)
  select_targets(oa2, oa1, attacking, attacked)

  attacking.sort_by { |(u, _)| -u.initiative }.each do |(u1, u2)|
    next if u1.dead?

    u1.attack(u2)
  end
  army1.reject! &.dead?
  army2.reject! &.dead?
end

def calc(immune, infection, i)
  im = immune.map &.dup
  inf = infection.map &.dup
  im.each { |u| u.damage += i }
  last_counts = {0, 0}
  while last_counts != {im.map(&.count), inf.map(&.count)}
    last_counts = {im.map(&.count), inf.map(&.count)}
    fight(im, inf)
  end
  {im, inf}
end

puts "part1"
im, inf = calc(immune, infection, 0)
puts inf.sum(&.count)

sols = Hash(Int32, typeof(im)).new
index = (1..50).bsearch do |i|
  im, inf = calc(immune, infection, i)
  sols[i] = im
  inf.none?
end

puts "part2"
puts sols[index].sum(&.count)

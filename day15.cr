input =
  File.read("day15.input")

class Actor
  property t : Char
  property hp : Int32
  property att : Int32

  def initialize(@t, @hp, @att)
  end

  def to_s
    t
  end

  def enemy?(other)
    other.t != t
  end
end

alias Pos = Tuple(Int32, Int32)

def enemies(fighters, t)
  fighters.select { |_, t2| t != t2.t }
end

def neighbours(pos)
  { {pos[0] - 1, pos[1]}, {pos[0] + 1, pos[1]}, {pos[0], pos[1] - 1}, {pos[0], pos[1] + 1} }
end

def adjacent_enemies(fighters, pos : Pos, actor)
  neighbours(pos).compact_map do |p|
    (e = fighters[p]?) &&
      e.enemy?(actor) ? {p, e} : nil
  end
end

def free_neighbours(map, fighters, pos : Pos)
  neighbours(pos)
    .reject { |p| fighters[p]? }
    .select! { |p| map[p]? == '.' }
end

def pathto(map, fighters, from : Pos, targets)
  queue = Deque(Tuple(Pos, Pos, Int32))
    .new(free_neighbours(map, fighters, from).map { |n| {n, n, 1} })
  seen = Set(Tuple(Pos, Pos)).new
  options = [] of Tuple(Pos, Pos, Int32)

  while !queue.empty?
    curr, orig, dist = queue.shift
    break if !options.empty? && options.last.last != dist

    if targets.includes? curr
      options << {curr, orig, dist}
    else
      queue.concat(free_neighbours(map, fighters, curr)
        .reject! { |p| seen.includes?({p, orig}) }
        .map do |p|
          seen << {p, orig}
          {p, orig, dist + 1}
        end)
    end
  end
  if options.any?
    options = options.group_by(&.last).min[1]
    options = options.group_by(&.[0]).min[1]
    options = options.group_by(&.[1]).min[1]
    options.first[1]
  end
end

def elves(fighters)
  fighters.values.count &.t.==('E')
end

def solve(input, strength)
  map = Hash(Pos, Char).new
  fighters = Hash(Pos, Actor).new
  input.lines.each_with_index do |l, x|
    l.chars.each_with_index do |c, y|
      map[Pos.new(x, y)] = c == '#' ? '#' : '.'
      if c == 'E'
        fighters[Pos.new(x, y)] = Actor.new(c, 200, strength)
      else
        fighters[Pos.new(x, y)] = Actor.new(c, 200, 3) unless ['.', '#'].includes? c
      end
    end
  end
  original_elves = elves(fighters)

  (0..Int32::MAX).each do |i|
    fighters.to_a.sort_by(&.first).each do |pos, actor|
      next unless fighters[pos]? == actor # DEAD
      targets = adjacent_enemies(fighters, pos, actor)
      if targets.empty?
        enemies = enemies(fighters, actor.t)
        if enemies.empty?
          puts "part1 #{fighters.values.sum(&.hp) * i}" if strength == 3
          done = elves(fighters) == original_elves
          puts "part2 #{fighters.values.sum(&.hp) * i}" if done
          return done
        end
        reachable = enemies.flat_map { |p, _| free_neighbours(map, fighters, p) }
        next if targets.empty? && reachable.empty?
        if step = pathto(map, fighters, pos, reachable)
          fighters.delete pos
          fighters[step] = actor
          pos = step
          targets = adjacent_enemies(fighters, step, actor)
        end
      end
      next if targets.empty?

      targets_by_hp = targets.group_by &.last.hp
      options = targets_by_hp.min_by(&.first).last
      selected_pos, selected = options.min_by(&.[0])
      selected.hp -= actor.att
      fighters.delete selected_pos if selected.hp <= 0
    end
  end
end

solve input, 3
(4..Int32::MAX).find { |i| solve input, i }

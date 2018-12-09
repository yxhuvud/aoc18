# 424 players; last marble is worth 71144 points

def play(players, stop)
  marbles = 2..stop
  scores = [0_i64] * players
  circle = Deque(Int32).new([1, 0])
  marbles.each do |i|
    if i % 23 == 0
      current = (i % players)
      scores[current] += i
      circle.rotate!(-7)
      removed = circle.shift
      scores[current] += removed
    else
      circle.rotate!(2)
      circle.unshift i
    end
  end
  scores.max
end

puts "part1 #{play(424, 71144)}"
puts "part2 #{play(424, 7114400)}"

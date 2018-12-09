def play(players, stop)
  marbles = 2..stop
  scores = [0_i64] * players
  circle = Deque(Int32).new([1, 0])
  marbles.each do |i|
    if i % 23 == 0
      circle.rotate!(-7)
      scores[i % players] += circle.shift + i
    else
      circle.rotate!(2)
      circle.unshift i
    end
  end
  scores.max
end

puts "part1 #{play(424, 71144)}"
puts "part2 #{play(424, 7114400)}"

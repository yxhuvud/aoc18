input = "074501"
start = [3, 7, 1, 0, 1, 0] of Int8 # precalculate first to allow for % optimization.

first, second = 4, 3
receipes = Array(Int8).new(initial_capacity: 30_000_000)
start.each { |i| receipes.push i } # this preallocation gain some 30ms compared to using the start literal.

21_000_000.times do
  receipt = receipes[first] + receipes[second]
  if receipt >= 10
    receipes.push(1_i8)
    receipt -= 10
  end
  receipes.push(receipt)
  first += 1 + receipes[first]
  second += 1 + receipes[second]
  first -= receipes.size if first >= receipes.size # manual % because speed.
  second -= receipes.size if second >= receipes.size
end

times = input.to_i
puts "part1"
puts receipes[times..(times + 9)].join

puts "part2"
needle = input.split(//).map(&.to_i)
receipes.each_cons(needle.size, reuse = true).with_index do |a, i|
  if a == needle # should really use a more efficient algo.
    p i
    exit
  end
end

input = "074501"
target = input.to_i
target_size = input.size
exp = 10 ** (target_size - 1)

start = [3, 7, 1, 0, 1, 0] of Int8 # precalculate first to allow for % optimization.
first, second = 4, 3
receipes = Array(Int8).new(initial_capacity: 30_000_000)
start.each { |i| receipes.push i } # this preallocation gain some 30ms compared to using the start literal.
cur = start.last(input.size).join.to_i

loop do
  receipt = receipes[first] + receipes[second]
  if receipt >= 10
    cur = (cur - exp * receipes[-target_size]) * 10 + 1
    receipes.push(1_i8)
    break if cur == target
    receipt -= 10
  end
  cur = (cur - exp * receipes[-target_size]) * 10 + receipt
  receipes.push(receipt)
  break if cur == target
  first += 1 + receipes[first]
  second += 1 + receipes[second]
  first -= receipes.size if first >= receipes.size # manual % because speed.
  second -= receipes.size if second >= receipes.size
end

puts "part1"
puts receipes[target..(target + 9)].join

puts "part2"
p receipes.size - target_size

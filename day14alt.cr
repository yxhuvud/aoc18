input = "074501"
start = [3, 7, 1, 0, 1, 0] of Int8 # precalculate first to allow for % optimization.
target = input.to_i

first, second = 4, 3
receipes = Array(Int8).new(initial_capacity: 30_000_000)
start.each { |i| receipes.push i } # this preallocation gain some 30ms compared to using the start literal.
cur = start.last(input.size).join.to_i
target_size = input.size
exp = 10 ** (target_size - 1)

def calc(cur, n, receipes, size, exp) : Int32
  (cur - exp * receipes[-size]) * 10 + n
end

21_000_000.times do
  receipt = receipes[first] + receipes[second]
  if receipt >= 10
    cur = calc(cur, 1, receipes, target_size, exp)
    receipes.push(1_i8)
    break if cur == target
    receipt -= 10
  end
  cur = calc(cur, receipt, receipes, target_size, exp)
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

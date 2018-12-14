input = "074501"
start = [3i8, 7i8, 1i8, 0i8, 1i8, 0i8]

first, second = 4, 3
receipes = Array(Int8).new(initial_capacity: 35_000_000)

start.each { |i| receipes.push i.to_i8 }
needle = input
times = input.to_i

21_000_000.times do
  receipt = receipes[first] + receipes[second]
  if receipt >= 10
    receipes.push(1_i8)
    receipes.push((receipt - 10).to_i8)
  else
    receipes.push(receipt.to_i8)
  end
  first += 1 + receipes[first].to_i32
  second += 1 + receipes[second].to_i32
  first -= receipes.size if first >= receipes.size
  second -= receipes.size if second >= receipes.size
end

puts "part1"
puts receipes[times..(times + 9)].join

puts "part2"
needle = needle.split(//).map(&.to_i8)
receipes.each_cons(needle.size, reuse = true).with_index do |a, i|
  if a == needle # should really use a more efficient algo.
    p i
    exit
  end
end

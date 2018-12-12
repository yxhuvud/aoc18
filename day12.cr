input =
  File.read("day12.input")
    .lines

initial_state = input.shift.match(/([#.]+)/).not_nil![1].chars
input.shift
patterns =
  input
    .map(&.split(" => "))
    .map { |l| {l[0].chars, l[1].chars.first} }
    .to_h

state = Hash(Int32, Char).new { '.' }
initial_state.each_with_index { |c, index| state[index] = c }

min_size = 0
max_size = initial_state.size
last = 0
dcount = 0

200.times do |j|
  if j == 20
    puts "part1"
    puts state.sum { |i, c| c == '.' ? 0 : i }
  end

  new_state = Hash(Int32, Char).new { '.' }
  new_min, seen_min = 0, false
  new_max = Int32::MIN

  ((min_size - 2)..(max_size + 2)).each do |i|
    v = patterns[[state[i - 2], state[i - 1], state[i], state[i + 1], state[i + 2]]]
    if v != '.'
      new_state[i] = v
      new_min = i unless seen_min
      seen_min = true
      new_max = i
    end
  end

  min_size, max_size = new_min, new_max
  state = new_state
  cur = state.sum { |i, c| c == '.' ? 0 : i }
  dcount = cur - last
  last = cur
end

puts "part2"
puts (50000000000 - 200) * dcount + last

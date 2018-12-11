input = 5153
SIZE = 300

def calc(x, y, input)
  rack_id = x + 10
  power_level = rack_id * y
  power_level += input
  power_level *= rack_id
  power_level = power_level.to_s.chars[-3].to_i || 0
  power_level -= 5
end

def calcsize(i, j, s, levels, sums)
  case {s, i, j}
  when {1, _, _}
    levels[i][j]
  when {_, 0, 0}
    sums[i][j]
  when {_, 0, _}
    sums[i + s - 1][j + s - 1] - sums[i + s - 1][j - 1]
  when {_, _, 0}
    sums[i + s - 1][j + s - 1] - sums[i - 1][j + s - 1]
  else
    sums[i + s - 1][j + s - 1] - sums[i - 1][j + s - 1] - sums[i + s - 1][j - 1] + sums[i - 1][j - 1]
  end
end

levels = Array(Array(Int32)).new(SIZE) { |i| Array(Int32).new(SIZE) { |j| calc(i, j, input) } }

# https://en.wikipedia.org/wiki/Summed-area_table
sums = Array(Array(Int32)).new
SIZE.times do |i|
  sums << Array(Int32).new
  SIZE.times do |j|
    sums[i] << levels[i][j] +
      case {i, j}
      when {0, 0}
        0
      when {0, _}
        sums[0][j - 1]
      when {_, 0}
        sums[i - 1][0]
      else
        sums[i - 1][j] + sums[i][j - 1] - sums[i - 1][j - 1]
      end
  end
end

max3 = {-1, -1, 0, -Int32::MAX}
max = {-1, -1, 0, -Int32::MAX}

(1..SIZE).each do |s|
  size = SIZE - s + 1
  size.times do |i|
    size.times do |j|
      sum = calcsize(i, j, s, levels, sums)
      max3 = {i, j, s, sum} if sum > max3.last && s == 3
      max = {i, j, s, sum} if sum > max.last
    end
  end
end

puts "part1"
puts max3.values_at(0, 1).join(",")
puts "part2"
puts max.values_at(0, 1, 2).join(",")

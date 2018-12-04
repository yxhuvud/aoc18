input =
  File.read("day4.input")
    .lines
    .sort

sleep_times = Hash(Int32, Int32).new { 0 }
sleeping_at = Hash(Int32, Hash(Int32, Int32)).new { |h, k| h[k] = Hash(Int32, Int32).new { 0 } }
current = 0
sleep_start = 0
input.each do |line|
  if m = line.match(/:(\d\d)/)
    time = m[1].to_i
    case line
    when /Guard/
      current = line.match(/#(\d+)/).not_nil![1].to_i
    when /asleep/
      sleep_start = time
    when /wakes/
      sleep_times[current] += time - sleep_start
      (sleep_start..time).each { |t| sleeping_at[current][t] += 1 }
    end
  end
end

def most_time_at(hours)
  hours.to_a.max_by &.[1]
end

most_sleeping = sleep_times.max_by { |k, v| v }[0]
hour = most_time_at(sleeping_at[most_sleeping])[0]
puts "part1"
puts most_sleeping * hour

max_minutes = sleeping_at.transform_values { |v| most_time_at(v) }
g, hours = max_minutes.max_by { |x, (y, z)| z }
puts "part2"
puts g * hours[0]

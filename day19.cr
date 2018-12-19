input = File.read "day19.input"
program = input
  .lines[1..-1]
  .map(&.split)
  .map { |row| {row[0], row[1].to_i, row[2].to_i, row[3].to_i} }

Instructions = %w(addr addi mulr muli banr bani borr bori setr seti gtir gtri gtrr eqir eqri eqrr)
macro addr(reg) {{reg}}[op[1]] + {{reg}}[op[2]] end
macro addi(reg) {{reg}}[op[1]] + op[2] end
macro mulr(reg) {{reg}}[op[1]] * {{reg}}[op[2]] end
macro muli(reg) {{reg}}[op[1]] * op[2] end
macro banr(reg) {{reg}}[op[1]] & {{reg}}[op[2]] end
macro bani(reg) {{reg}}[op[1]] & op[2] end
macro borr(reg) {{reg}}[op[1]] | {{reg}}[op[2]] end
macro bori(reg) {{reg}}[op[1]] | op[2] end
macro setr(reg) {{reg}}[op[1]] end
macro seti(reg) op[1] end
macro gtir(reg) bti op[1] > {{reg}}[op[2]] end
macro gtri(reg) bti {{reg}}[op[1]] > op[2] end
macro gtrr(reg) bti {{reg}}[op[1]] > {{reg}}[op[2]] end
macro eqir(reg) bti op[1] == {{reg}}[op[2]] end
macro eqri(reg) bti {{reg}}[op[1]] == op[2] end
macro eqrr(reg) bti {{reg}}[op[1]] == {{reg}}[op[2]] end

def bti(b)
  b ? 1 : 0
end

ip = 1
regs = [0, 0, 0, 0, 0, 0]
def run(program, regs, ip)
  while regs[ip] < program.size
    op = program[regs[ip]]
    {% begin %}
      case op[0]
          {% for ins in Instructions %}
          when {{ins}}
            regs[op[3]] = {{ ins.id }}(regs)
          {% end %}
      end
    {% end %}
    regs[ip] += 1
  end
end

puts "part1"
run(program, regs, ip)
p regs[0]
puts "part2"
# So I figured it out by inspecting the inner loop of the code that
# was run. Thankfully, reg0 is only ever assigned in one place, and
# reg5 (ie the large number) can be found by just printing the
# register variables on each iteration
p (1..10551350).sum { |i| (10551350 % i == 0) ? i : 0 }

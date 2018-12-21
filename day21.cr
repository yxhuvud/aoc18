input = File.read "day21.input"
program = input
  .lines[1..-1]
  .map(&.split)
  .map { |row| {Instructions.index(row[0]), row[1].to_i, row[2].to_i, row[3].to_i} }

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

macro eqrr(reg) 
  return seen if seen.includes?({{reg}}[op[1]])
  seen << {{reg}}[op[1]]
  bti {{reg}}[op[1]] == {{reg}}[op[2]]
end

def bti(b)
  b ? 1 : 0
end

ip = 4

def run(program, regs, ip)
  seen = Set(Int32).new
  prev = -1
  while true
    op = program[regs[ip]]
    {% begin %}
      case op[0]
          {% for ins, index in Instructions %}
          when {{index}}
            regs[op[3]] = {{ ins.id }}(regs)
          {% end %}
      end
    {% end %}
    regs[ip] += 1
  end
end

regs = [0, 0, 0, 0, 0, 0] 
opts = run(program, regs, ip)
# Abusing the fact that sets are built with hash tables, and that
# crystal hash tables have are sorted in insertion order:
vals = opts.to_a
puts "part1: #{vals[0]}"
puts "part2: #{vals[-1]}"

defmodule Day12 do
  def real_input do
    Utils.get_input(12, 1)
  end

  def sample_input do
    """
    cpy 41 a
    inc a
    inc a
    dec a
    jnz a 2
    dec a
    """
  end

  def sample_input2 do
    """
    """
  end

  def sample do
    sample_input
    |> parse_input1
    |> solve1
  end

  def part1 do
    real_input1
    |> parse_input1
    |> solve1
  end


  def sample2 do
    sample_input2
    |> parse_input2
    |> solve2
  end

  def part2 do
    real_input2
    |> parse_input2
    |> solve2
  end

  def real_input1, do: real_input()
  def real_input2, do: real_input()

  def parse_input1(input), do: parse_input(input)
  def parse_input2(input), do: parse_input(input)

  def solve1(input), do: solve(input)
  def solve2(input) do
    input
    |> perform_instructions(1)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(instruction) do
    instruction
    |> String.split
    |> Enum.map(&to_int_or_atom/1)
    |> List.to_tuple
  end

  def to_int_or_atom(string) do
    case Integer.parse(string) do
      :error -> String.to_atom(string)
      {val, _} -> val
    end
  end

  def solve(input) do
    input
    |> perform_instructions(0)
  end

  def perform_instructions(instructions, c_value) do
    do_perform_instructions(instructions, 0, %{a: 0, b: 0, c: c_value, d: 0})
  end

  defp do_perform_instructions(instructions, ip, registers) do
    current = Enum.at(instructions, ip)
    {new_ip, new_registers} = execute_instruction(current, ip, registers)
    case new_ip < length(instructions) do
      true -> do_perform_instructions(instructions, new_ip, new_registers)
      false -> new_registers
    end
  end

  def get_value(registers, source) do
    case is_number(source) do
      true -> source
      false -> Map.get(registers, source)
    end
  end

  def set_value(value, dest, registers) do
    Map.put(registers, dest, value)
  end

  def execute_instruction({:cpy, source, dest}, ip, registers) do
    new_value = get_value(registers, source)
    {
      ip + 1,
      set_value(new_value, dest, registers)
    }
  end

  def execute_instruction({:jnz, check, source}, ip, registers) do
    new_ip = case get_value(registers, check) do
      0 -> ip + 1
      _ -> ip + get_value(registers, source)
    end

    {
      new_ip,
      registers
    }

  end

  def execute_instruction({:inc, source}, ip, registers) do
    new_value = get_value(registers, source) + 1
    {
      ip + 1,
      set_value(new_value, source, registers)
    }
  end

  def execute_instruction({:dec, source}, ip, registers) do
    new_value = get_value(registers, source) - 1
    {
      ip + 1,
      set_value(new_value, source, registers)
    }
  end

end

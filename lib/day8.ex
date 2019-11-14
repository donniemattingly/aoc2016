defmodule Day8 do
  def real_input do
    Utils.get_input(8, 1)
  end

  def sample_input do
    """
    rect 3x2
    rotate column x=1 by 1
    rotate row y=0 by 4
    rotate column x=1 by 1
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
    |> Matrex.sum
  end


  def sample2 do
    sample_input2
    |> parse_input2
    |> solve2
  end

  def part2 do
    result = real_input2
    |> parse_input2
    |> solve2

    0..9
    |> Enum.map(&(&1*5))
    |> Enum.map(&Matrex.submatrix(result, 1..6, &1 + 1..&1+5))
    |> Enum.map(&IO.inspect/1)
    |> Enum.count

  end

  def real_input1, do: real_input()
  def real_input2, do: real_input()

  def parse_input1(input), do: parse_input(input)
  def parse_input2(input), do: parse_input(input)

  def solve1(input), do: solve(input)
  def solve2(input), do: solve(input)

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_command/1)
  end

  def parse_command(row) do
    row
    |> String.split
    |> do_parse_command
  end

  defp do_parse_command(["rect", size | _]) do
    [x, y | _ ] = String.split(size, "x") |> Enum.map(&String.to_integer/1)
    {:fill_rect, x, y}
  end

  defp do_parse_command(["rotate", "column", "x=" <> x, "by", amount | _]) do
    {:rotate, :col, String.to_integer(x), String.to_integer(amount)}
  end

  defp do_parse_command(["rotate", "row", "y=" <> y, "by", amount | _]) do
    {:rotate, :row, String.to_integer(y), String.to_integer(amount)}
  end

  def apply_command(matrix, {:fill_rect, x, y}) do
    MatrixUtils.apply_to_sub_rect(matrix, 0, 0, y, x, fn _ -> 1 end)
  end

  def apply_command(matrix, {:rotate, :row, y, amount}) do
    MatrixUtils.shift_row(matrix, y, amount)
  end

  def apply_command(matrix, {:rotate, :col, x, amount}) do
    MatrixUtils.shift_col(matrix, x, amount)
  end

  def solve(input) do
    input |> Enum.reduce(Matrex.zeros(6, 50), fn x, acc ->
      apply_command(acc, x)
    end)
  end

end

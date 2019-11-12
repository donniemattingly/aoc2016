defmodule Day6 do
  def real_input do
    Utils.get_input(6, 1)
  end

  def sample_input do
    """
    eedadn
    drvtee
    eandsr
    raavrd
    atevrs
    tsrnev
    sdttsa
    rasrtv
    nssdts
    ntnada
    svetve
    tesnvt
    vntsnd
    vrdear
    dvrsen
    enarar
    """
  end

  def sample do
    sample_input
    |> parse_input
    |> solve(&get_most_common_letter/1)
  end

  def part1 do
    real_input
    |> parse_input
    |> solve(&get_most_common_letter/1)
  end

  def part2 do
    real_input
    |> parse_input
    |> solve(&get_least_common_letter/1)
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.filter(&(length(&1) != 0))
  end

  def get_letter_to_count_map(letters) do
    Enum.reduce(letters, %{}, fn x, acc ->
      Map.update(acc, x, 1, & &1 + 1)
    end)
  end

  def get_most_common_letter(letters) do
    letters
    |> get_letter_to_count_map
    |> Map.to_list
    |> Enum.max_by(&elem(&1, 1))
  end

  def get_least_common_letter(letters) do
    letters
    |> get_letter_to_count_map
    |> Map.to_list
    |> Enum.min_by(&elem(&1, 1))
  end

  def solve(parsed_input, comparator) do
    parsed_input
    |> Enum.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&(comparator.(&1)))
    |> Enum.map(&elem(&1, 0))
    |> Enum.join("")
  end

end
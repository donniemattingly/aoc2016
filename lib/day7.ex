defmodule Day7 do
  def real_input do
    Utils.get_input(7, 1)
  end

  def sample_input do
    """
    abba[mnop]qrst
    abcd[bddb]xyyx
    aaaa[qwer]tyui
    ioxxoj[asdfgh]zxcvbn
    """
  end

  def sample do
    sample_input()
    |> parse_input
    |> solve
  end

  def part1 do
    real_input()
    |> parse_input
    |> solve
  end

  def part2 do
    real_input()
    |> parse_input
    |> solve
  end

  def parse_input(input) do
    input
    |> String.split
  end

  def has_abba_seq(segment) do
    String.graphemes(segment)
    |> Enum.chunk_every(4, 1)
    |> Enum.filter(& length(&1) == 4)
    |> Enum.any?(&is_seq_abba?/1)
  end

  def is_seq_abba?([a, b, c, d]) do
    a == d and b == c and a != b
  end

  def do_confirms_confirm?(segments) do
    segments.confirms
    |> Enum.any?(&has_abba_seq/1)
  end

  def do_rejects_reject?(segments) do
    segments.rejects
    |> Enum.any?(&has_abba_seq/1)
  end

  def get_confirm_and_reject_segments(ip) do
    Regex.scan(~r/\[.*?\]|([a-z]+)/, ip)
    |> Enum.map(&hd/1)
    |> Enum.group_by(fn x ->
      case String.contains?(x, "[") do
        true -> :rejects
        false -> :confirms
      end
    end, &String.replace(&1, ~r"[\[\]]", ""))
  end

  def supports_tls?(ip) do
    segments = get_confirm_and_reject_segments(ip)
    do_confirms_confirm?(segments) && !do_rejects_reject?(segments)
  end

  def solve(parsed_input) do
    parsed_input
    |> Enum.map(&supports_tls?/1)
    |> Enum.filter(& &1)
    |> Enum.count
  end

end
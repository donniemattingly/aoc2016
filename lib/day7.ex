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

  def sample_input_2 do
    """
    aba[bab]xyz
    xyx[xyx]xyx
    aaa[kek]eke
    zazbz[bzb]cdb
    """
  end

  def sample do
    sample_input()
    |> parse_input
    |> solve(&supports_tls?/1)
  end

  def part1 do
    real_input()
    |> parse_input
    |> solve(&supports_tls?/1)
  end

  def sample2 do
    sample_input_2()
    |> parse_input
    |> solve(&supports_ssl?/1)
  end

  def part2 do
    real_input()
    |> parse_input
    |> solve(&supports_ssl?/1)
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

  def is_seq_abba?([a, b, b, a]) when a != b do
    true
  end

  def is_seq_abba?(_) do
    false
  end

  def get_canidate_abas(segments) do
    chunk_strings(segments, 3, 1)
    |> Enum.filter(&is_seq_aba?/1)
  end

  def chunk_strings(strings, size, step) do
    strings |> Enum.flat_map(fn string ->
      String.graphemes(string)
      |> Enum.chunk_every(size, step)
      |> Enum.filter(& length(&1) == 3)
    end)
  end

  def has_matching_bab?(segments, abas) do
    converted = Enum.map(abas, &convert_to_bab/1)
    chunk_strings(segments, 3, 1)
    |> Enum.any?(& &1 in converted)
  end

  def is_seq_aba?([a, b, a]) when a != b do
    true
  end

  def is_seq_aba?(_) do
    false
  end

  def convert_to_bab([a, b, a]) do
    [b, a, b]
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

  def supports_ssl?(ip) do
    segments = get_confirm_and_reject_segments(ip)
    abas = segments.confirms |> get_canidate_abas
    has_matching_bab?(segments.rejects, abas)
  end

  def solve(parsed_input, comparator) do
    parsed_input
    |> Enum.map(&(comparator.(&1)))
    |> Enum.filter(& &1)
    |> Enum.count
  end



end
defmodule Day6 do
  defp detect_marker(path, marker_len) do
    [{_, start_of_marker}] =
      File.read!(path)
      |> to_charlist()
      |> Enum.chunk_every(marker_len, 1)
      |> Enum.with_index()
      |> Enum.filter(fn {chunk, _idx} -> length(Enum.uniq(chunk)) == length(chunk) end)
      |> Enum.take(1)

    start_of_marker + marker_len
  end

  def solve_part_one(path) do
    detect_marker(path, 4)
  end

  def solve_part_two(path) do
    detect_marker(path, 14)
  end
end

defmodule Day1 do
  defp is_empty?(str), do: String.at(str, 0) == "\n"

  defp total_callories_per_elf(enumerable) do
    enumerable
    |> Enum.chunk_by(&is_empty?/1)
    |> Enum.filter(fn list -> Enum.all?(list, fn s -> !is_empty?(s) end) end)
    |> Enum.map(fn list ->
      list
      |> Enum.reduce(0, fn elem, acc ->
        {i, _} = Integer.parse(elem, 10)
        acc + i
      end)
    end)
    |> Enum.sort(:desc)
  end

  def solve_part1(path) do
    File.stream!(path, [:utf8])
    |> total_callories_per_elf()
    |> Enum.max()
  end

  def solve_part2(path) do
    File.stream!(path, [:utf8])
    |> total_callories_per_elf()
    |> Enum.take(3)
    |> Enum.sum()
  end
end

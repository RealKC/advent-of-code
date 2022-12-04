defmodule Day4 do
  def solve_part_one(path) do
    File.stream!(path, [:utf8])
    |> Enum.map(fn line ->
      line = String.trim(line)
      [first, second] = String.split(line, ",")
      [a, b] = String.split(first, "-")
      [c, d] = String.split(second, "-")

      a = String.to_integer(a)
      b = String.to_integer(b)

      c = String.to_integer(c)
      d = String.to_integer(d)

      cond do
        a <= c && d <= b -> 1
        c <= a && b <= d -> 1
        true -> 0
      end
    end)
    |> Enum.sum()
  end

  def solve_part_two(path) do
    File.stream!(path, [:utf8])
    |> Enum.map(fn line ->
      line = String.trim(line)
      [first, second] = String.split(line, ",")
      [a, b] = String.split(first, "-")
      [c, d] = String.split(second, "-")

      a = String.to_integer(a)
      b = String.to_integer(b)

      c = String.to_integer(c)
      d = String.to_integer(d)

      case Range.disjoint?(a..b, c..d) do
        true -> 0
        false -> 1
      end
    end)
    |> Enum.sum()
  end
end

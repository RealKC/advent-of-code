defmodule Ex do
  defp get_stacks(crates) do
    File.stream!(crates, [:utf8])
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line ->
      [_length, stack] = String.split(line)
      to_charlist(stack)
    end)
  end

  defp parse_instructions(instructions) do
    File.stream!(instructions)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line ->
      Regex.named_captures(~r/move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/i, line)
    end)
    |> Enum.reject(&(&1 == nil))
  end

  def solve_part_one(crates, instructions) do
    crates = get_stacks(crates)
    instructions = parse_instructions(instructions)

    crates =
      instructions
      |> Enum.reduce(crates, fn insn, crates ->
        count = String.to_integer(insn["count"])
        from = String.to_integer(insn["from"]) - 1
        to = String.to_integer(insn["to"]) - 1

        from_list = Enum.at(crates, from)
        to_list = Enum.at(crates, to)

        to_list = Enum.reverse(Enum.take(from_list, count)) ++ to_list
        from_list = Enum.drop(from_list, count)
        crates = List.update_at(crates, from, fn _ -> from_list end)
        crates = List.update_at(crates, to, fn _ -> to_list end)

        crates
      end)

    crates |> Enum.map(fn crate -> List.first(crate) end)
  end

  # NOTE: I tried avoid code duplications but the naive solution led to me OOMing
  def solve_part_two(crates, instructions) do
    crates = get_stacks(crates)
    instructions = parse_instructions(instructions)

    crates =
      instructions
      |> Enum.reduce(crates, fn insn, crates ->
        count = String.to_integer(insn["count"])
        from = String.to_integer(insn["from"]) - 1
        to = String.to_integer(insn["to"]) - 1

        from_list = Enum.at(crates, from)
        to_list = Enum.at(crates, to)

        to_list = Enum.take(from_list, count) ++ to_list
        from_list = Enum.drop(from_list, count)
        crates = List.update_at(crates, from, fn _ -> from_list end)
        crates = List.update_at(crates, to, fn _ -> to_list end)

        crates
      end)

    crates |> Enum.map(fn crate -> List.first(crate) end)
  end
end

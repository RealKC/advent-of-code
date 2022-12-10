defmodule Day10 do
  defp execute_insn(insn, x) do
    if String.starts_with?(insn, "noop") do
      {1, x}
    else
      [_, dx] = String.split(insn)
      {2, x + String.to_integer(dx)}
    end
  end

  def solve_part_one(path \\ "input.in") do
    {_, _, _, signal_strength} =
      File.stream!(path, [:utf8])
      |> Enum.reduce({0, 20, 1, 0}, fn insn, {cycle, interesting_cycle, x, signal_strength} ->
        {interesting_cycle, signal_strength} =
          if cycle == interesting_cycle or cycle == interesting_cycle - 1 or
               cycle == interesting_cycle - 2 do
            {interesting_cycle + 40, signal_strength + interesting_cycle * x}
          else
            {interesting_cycle, signal_strength}
          end

        {dcycle, x} = execute_insn(insn, x)

        {cycle + dcycle, interesting_cycle, x, signal_strength}
      end)

    signal_strength
  end

  def solve_part_two(inpath \\ "input.in", outpath \\ "output.out") do
    out = File.open!(outpath, [:utf8, :write])

    File.stream!(inpath, [:utf8])
    |> Enum.reduce({0, 1}, fn insn, {cycle, x} ->
      {dcycle, new_x} = execute_insn(insn, x)
      sprite = (x - 1)..(x + 1)

      cycle =
        if dcycle == 1 do
          if cycle != 0 and rem(cycle, 40) == 0 do
            IO.write(out, "\n")
          end

          if rem(cycle, 40) in sprite do
            IO.write(out, "#")
          else
            IO.write(out, ".")
          end

          cycle + 1
        else
          wrote_nl =
            if cycle != 0 and rem(cycle, 40) == 0 do
              IO.write(out, "\n")
              true
            else
              cycle == 0
            end

          if rem(cycle, 40) in sprite do
            IO.write(out, "#")
          else
            IO.write(out, ".")
          end

          if not wrote_nl and rem(cycle + 1, 40) == 0 do
            IO.write(out, "\n")
          end

          if rem(cycle + 1, 40) in sprite do
            IO.write(out, "#")
          else
            IO.write(out, ".")
          end

          cycle + 2
        end

      {cycle, new_x}
    end)
  end
end

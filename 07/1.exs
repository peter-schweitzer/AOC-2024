#!/bin/elixir

{:ok, text} = File.read("test.txt")
# {:ok, text} = File.read("input.txt")

defmodule Day7_Part1 do
  import Bitwise

  defp get_op_map_str(map, len),
    do:
      len..0//-1
      |> Enum.map(&((map &&& 1 <<< &1) >>> &1))
      |> Enum.map(&Integer.to_string/1)
      |> Enum.join()

  def is_solvable({result, numbers}) do
    op_map = 1 <<< length(numbers)

    IO.puts(
      "result: #{result}, #numbers: #{length(numbers)}, op_map: #{get_op_map_str(op_map, length(numbers))} (#{op_map})"
    )

    solve(result, numbers, op_map, op_map * 2)
  end

  defp solve(_, _, op_map, max) when op_map === max, do: false

  defp solve(result, numbers, op_map, max) when op_map < max do
    # IO.puts(get_op_map_str(op_map, length(numbers)))

    [acc_init | rest] = numbers

    calc_result =
      for {number, idx} <- rest |> Enum.with_index(), reduce: acc_init do
        acc ->
          case band(op_map, bsr(1, idx)) do
            0 -> acc + number
            _ -> acc * number
          end
      end

    if calc_result == result do
      "#{result} = [#{numbers |> Enum.map(&Integer.to_string/1) |> Enum.join(", ")}], #{get_op_map_str(op_map, length(numbers) + 1) |> String.replace("1", "*") |> String.replace("0", "+")}"
      |> IO.puts()

      true
    else
      solve(result, numbers, op_map + 1, max)
    end
  end
end

text
|> String.split("\n")
|> Enum.map(&String.split(&1, ": "))
|> Enum.map(fn [result, numbers] ->
  {String.to_integer(result), String.split(numbers, " ") |> Enum.map(&String.to_integer/1)}
end)
|> Enum.filter(&Day7_Part1.is_solvable/1)
|> Enum.map(&elem(&1, 0))
|> Enum.sum()
|> IO.inspect()

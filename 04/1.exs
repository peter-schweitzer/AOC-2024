#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

defmodule Checker do
  def chars(), do: ["X", "M", "A", "S"] |> Enum.with_index |> tl

  def get_char(dir, matrix, row, col, i) when dir == 0, do: matrix |> Enum.at(row)     |> Enum.at(col+i)
  def get_char(dir, matrix, row, col, i) when dir == 1, do: matrix |> Enum.at(row + i) |> Enum.at(col+i)
  def get_char(dir, matrix, row, col, i) when dir == 2, do: matrix |> Enum.at(row + i) |> Enum.at(col)
  def get_char(dir, matrix, row, col, i) when dir == 3, do: matrix |> Enum.at(row + i) |> Enum.at(col-i)
  def get_char(dir, matrix, row, col, i) when dir == 4, do: matrix |> Enum.at(row)     |> Enum.at(col-i)
  def get_char(dir, matrix, row, col, i) when dir == 5, do: matrix |> Enum.at(row - i) |> Enum.at(col-i)
  def get_char(dir, matrix, row, col, i) when dir == 6, do: matrix |> Enum.at(row - i) |> Enum.at(col)
  def get_char(dir, matrix, row, col, i) when dir == 7, do: matrix |> Enum.at(row - i) |> Enum.at(col+i)

  def check(row, col, dir, matrix), do: Enum.reduce_while(Checker.chars, true, fn {c, i}, t -> if Checker.get_char(dir, matrix, row, col, i) == c, do: {:cont, t}, else: {:halt, false} end)
end

matrix = text |> String.split("\n") |> Enum.map(&String.graphemes &1) |> IO.inspect

{max_y, max_x} = {length(matrix), matrix |> hd |> length} |> IO.inspect

x_poses = matrix
  |> Enum.map(fn r -> r
    |> Enum.with_index
    |> Enum.filter(&(elem(&1, 0) == "X"))
    |> Enum.map(&(elem(&1, 1)))
  end)
  |> Enum.with_index
  |> Enum.map(fn {cols, row} -> cols
    |> Enum.map(&({row, &1}))
  end)
  |> List.flatten

for {y, x} <- x_poses do
  for dir <- 0..7, do: {y, x, dir}
end
|> List.flatten
|> Enum.filter(fn {y, x, dir} ->
  case dir do
    0 -> (max_x - x) > 3
    1 -> (max_x - x) > 3 and (max_y - y) > 3
    2 -> (max_y - y) > 3
    3 -> (max_y - y) > 3 and x >= 3
    4 -> x >= 3
    5 -> x >= 3 and y >= 3
    6 -> y >= 3
    7 -> y >= 3 and (max_x - x) > 3
  end
end)
|> Enum.reduce(0, fn {row, col, dir}, acc -> if(Checker.check(row, col, dir, matrix), do: acc + 1, else: acc) end)
|> IO.inspect

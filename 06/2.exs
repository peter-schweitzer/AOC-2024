#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

defmodule Day6_Part2 do
  def turn(x, y, dir) do
    case dir do
        0 -> {x - 1, y + 1}
        1 -> {x - 1, y - 1}
        2 -> {x + 1, y - 1}
        3 -> {x + 1, y + 1}
      end
  end

  def step(x, y, dir) do
    case dir do
      0 -> {x + 1, y}
      1 -> {x, y + 1}
      2 -> {x - 1, y}
      3 -> {x, y - 1}
    end
  end

  def visit(visited_map, x, y, dir), do: Map.put(visited_map, {x, y, dir}, true)

  def walk(_, {x, y}, max_x, max_y, _, _) when x > max_x or x < 0 or y > max_y or y < 0, do: false

  def walk(map, {x, y}, max_x, max_y, dir, visited_map) when x <= max_x and x >= 0 and y <= max_y and y >= 0 do
    cond do
      Map.get(map, {x, y}) == "#" -> walk(map, turn(x, y, dir), max_x, max_y, rem(dir + 1, 4), visited_map)
      Map.get(visited_map, {x, y, dir}, false) -> true
      true -> walk(map, step(x, y, dir), max_x, max_y, dir, visit(visited_map, x, y, dir))
    end
  end
end

raw_map = text
  |> String.split("\n") |> Enum.map(&String.graphemes(&1))


[{[start_x],  start_y}] = raw_map |> Enum.map(fn row -> row
    |> Enum.with_index
    |> Enum.filter(&(elem(&1, 0) == "^"))
    |> Enum.map(&elem(&1, 1))
  end)
  |> Enum.with_index
  |> Enum.filter(&(length(elem(&1, 0)) > 0))

max_y = (raw_map |> length) - 1
max_x = (raw_map |> hd |> length) - 1

map = for x <- 0..max_x, y <- 0..max_y, reduce: %{} do acc ->
  value = raw_map |> Enum.at(y) |> Enum.at(x)
  acc |> Map.put({x, y}, value)
end

for x <- 0..max_x, y <- 0..max_y, reduce: 0 do acc ->
  IO.puts "x: #{x}, y: #{y}"
  cond do
    x == start_x and y == start_y -> acc
    Map.get(map, {x, y}) == "#" -> acc
    true -> cond do
      map |> Map.put({x, y}, "#") |> Day6_Part2.walk({start_x, start_y}, max_x, max_y, 3, %{}) -> acc + 1
      true -> acc
    end
  end
end |> IO.inspect

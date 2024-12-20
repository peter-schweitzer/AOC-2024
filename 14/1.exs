#!/bin/elixir

defmodule Vec2 do
  defmacro __using__(_) do
    quote do
      def {x1, y1} +++ {x2, y2}, do: {x1 + x2, y1 + y2}
      def {x1, y1} --- {x2, y2}, do: {x1 - x2, y1 - y2}
      def {x1, y1} <~> {x2, y2}, do: x1 === x2 and y1 === y2
      def {x, y} ~>> λ, do: {x * λ, y * λ}

      def {x, y} &&& a do
        case(a) do
          :x -> x
          :y -> y
          _ -> nil
        end
      end
    end
  end
end

defmodule Day14Part1 do
  use Vec2

  def walk([p, v], w, h) do
    {total_x, total_y} = p +++ (v ~>> 100)

    x = rem(total_x, w) |> (&if(&1 >= 0, do: &1, else: &1 + w)).()
    y = rem(total_y, h) |> (&if(&1 >= 0, do: &1, else: &1 + h)).()

    {x, y}
  end
end

# {:ok, text} = File.read("test.txt")
# width = 11
# height = 7
{:ok, text} = File.read("input.txt")
width = 101
height = 103

w_mid = div(width, 2)
h_mid = div(height, 2)

text
|> String.split("\n")
|> Enum.map(fn line ->
  line
  |> String.split(" ")
  |> Enum.map(fn part ->
    part
    |> String.split("=")
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end)
end)
|> Enum.map(&Day14Part1.walk(&1, width, height))
|> Enum.filter(fn {x, y} -> x !== w_mid and y !== h_mid end)
|> Enum.group_by(fn {x, y} ->
  cond do
    x < w_mid and y < h_mid -> 0
    x < w_mid and y > h_mid -> 1
    x > w_mid and y < h_mid -> 2
    x > w_mid and y > h_mid -> 3
  end
end)
|> Map.to_list()
|> Enum.map(&(elem(&1, 1) |> length))
|> Enum.product()
|> IO.inspect()

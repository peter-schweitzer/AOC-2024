#!/bin/elixir

import(Bitwise)

defmodule Day11Part1 do
  def split(stone) do
    sub_len = String.length(stone) >>> 1
    a = String.slice(stone, 0, sub_len)

    b_prefix = String.slice(stone, sub_len, sub_len - 1) |> String.trim_leading("0")
    b_last = String.last(stone)

    [a, b_prefix <> b_last]
  end

  def blink(stones, 0), do: stones

  def blink(stones, blinks) do
    stones
    |> Enum.map(fn stone ->
      cond do
        stone === "0" ->
          "1"

        rem(String.length(stone), 2) == 0 ->
          split(stone)

        true ->
          "#{String.to_integer(stone) * 2024}"
      end
    end)
    |> List.flatten()
    |> blink(blinks - 1)
  end
end

# {:ok, text} = File.read("test.txt")
# {:ok, text} = File.read("test2.txt")
{:ok, text} = File.read("input.txt")

stones =
  text
  |> String.split(" ")
  |> Day11Part1.blink(25)

IO.puts("you have #{length(stones)} stones after blinking 25 times")

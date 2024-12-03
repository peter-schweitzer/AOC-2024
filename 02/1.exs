#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

all_levels = text |> String.split("\n") |> Enum.map(fn l -> l |> String.split(" ") |> Enum.map(&String.to_integer(&1)) end) |> Enum.map(fn [init | rest] -> {init, rest} end)

for {init, levels} <- all_levels do
  dir = (hd levels) > init
  for level <- levels, reduce: {init, true} do {prev, safe} ->
    dif = case dir do
      true -> level - prev
      false  -> prev - level
    end

  {level, safe and dif > 0 and dif < 4}
  end
end |> Enum.map(fn {_, safe} -> safe end) |> Enum.filter(&(&1)) |> Enum.count |> IO.inspect


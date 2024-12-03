#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

for line <- text |> String.split("\n"), reduce: {[], []} do {list1, list2} ->
  [entry1 | [entry2]] = line |> String.split("   ") |> Enum.map(&String.to_integer(&1))
  {[entry1 | list1], [entry2 | list2]}
end
  |> Tuple.to_list
  |> Enum.map(&Enum.sort(&1))
  |> Enum.zip
  |> Enum.map(fn {a, b} -> abs(a-b) end)
  |> Enum.sum
  |> IO.inspect

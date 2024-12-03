#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

~r/mul\(\d{1,3},\d{1,3}\)/ |> Regex.scan(text)
|> Enum.map(fn [mul] -> Regex.named_captures(~r/(?<n1>\d{1,3}),(?<n2>\d{1,3})/, mul) end)
|> Enum.map(fn map -> {Map.get(map, "n1") |> String.to_integer, Map.get(map, "n2") |> String.to_integer} end)
|> Enum.map(fn {a, b} -> a*b end) |> Enum.sum
|> IO.inspect

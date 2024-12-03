#!/bin/elixir

# {:ok, text} = File.read("test2.txt")
{:ok, text} = File.read("input.txt")

all_matches = Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/, text) |> Enum.map(&(hd &1))

for match <- all_matches, reduce: {0, true} do {acc, is_do} ->
  case match do
    "do()" -> {acc, true}
    "don't()" -> {acc, false}
    _ -> if is_do do
        mul_res = Regex.named_captures(~r/(?<a>\d{1,3}),(?<b>\d{1,3})/, match)
          |> Enum.map(&(&1 |> elem(1) |> String.to_integer))
          |> Enum.product
          {acc + mul_res, is_do}
      else
        {acc, is_do}
      end
  end
end |> elem(0)
|> IO.inspect

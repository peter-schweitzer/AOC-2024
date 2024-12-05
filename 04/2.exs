#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

matrix = text |> String.split("\n") |> Enum.map(&String.graphemes &1) |> IO.inspect

{max_y, max_x} = {length(matrix), matrix |> hd |> length} |> IO.inspect

valid_a_poses = matrix
  |> Enum.map(fn r -> r
    |> Enum.with_index
    |> Enum.filter(&(elem(&1, 0) == "A"))
    |> Enum.map(&(elem(&1, 1)))
  end)
  |> Enum.with_index
  |> Enum.map(fn {cols, row} -> cols
    |> Enum.map(&({row, &1}))
  end)
  |> List.flatten
  |> Enum.filter(fn {y, x} -> y > 0 and y < max_y-1 and x > 0 and x < max_x-1 end)
  |> IO.inspect

for {y, x} <- valid_a_poses, reduce: 0 do acc ->
 case (case matrix |> Enum.at(y-1) |> Enum.at(x-1) do
    "M" -> if(matrix |> Enum.at(y+1) |> Enum.at(x+1) == "S", do: true, else: false)
    "S" -> if(matrix |> Enum.at(y+1) |> Enum.at(x+1) == "M", do: true, else: false)
    _ -> false
  end and case matrix |> Enum.at(y+1) |> Enum.at(x-1) do
    "M" -> if(matrix |> Enum.at(y-1) |> Enum.at(x+1) == "S", do: true, else: false)
    "S" -> if(matrix |> Enum.at(y-1) |> Enum.at(x+1) == "M", do: true, else: false)
    _ -> false
  end) do
    true -> acc+1
    false -> acc
  end
end |> IO.inspect


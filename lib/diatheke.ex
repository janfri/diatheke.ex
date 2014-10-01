defmodule Diatheke do

  def mods do
    exec(~w(-b system -k modulelistnames)) |> String.split(~r/\n/) |> Enum.reject(&(&1 == ""))
  end

  defp exec(args) do
    System.cmd("diatheke", args, []) |> parse_res
  end

  defp parse_res({res, 0}) do
    res
  end

  defp parse_res(_) do
    raise "Error"
  end

end

defmodule Diatheke do

  def mods do
    call("system", "modulelistnames") |> String.split(~r/\n/) |> Enum.reject(&(&1 == ""))
  end

  def passage(mod, key) do
    call(mod, key) |> parse_passage
  end

  defp call(mod, key) do
    System.cmd("diatheke", ["-b", mod, "-k", key], []) |> parse_res
  end

  defp parse_res({res, 0}) do
    res
  end

  defp parse_res(_) do
    raise "Error"
  end

  defp parse_passage(str) do
    l = String.split(str, ~r/\n\n+/) |> Enum.drop(-1)
    Enum.map(l, &(gen_verse(&1)))
  end

  defp gen_verse(line) do
    [k, t] = String.split(line, ": ", parts: 2)
    %{key: k, text: t}
  end

end

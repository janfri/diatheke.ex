defmodule DiathekeTest do
  use ExUnit.Case

  test "mods" do
    assert Enum.member?(Diatheke.mods, "KJV")
    assert ! Enum.member?(Diatheke.mods, "")
  end

  test "passage" do
    res = Diatheke.passage("KJV", "Joh 1:1-3")
    assert ["John 1:1", "John 1:2", "John 1:3"] = (Enum.map(res, &(Dict.get(&1, :key))) |> Enum.sort)
    {:ok, %{text: text}} = Enum.fetch(res, 0)
    assert text =~ ~r/^In the beginning was the Word/
  end

end

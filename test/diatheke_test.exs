defmodule DiathekeTest do
  use ExUnit.Case

  test "mods" do
    assert Enum.member?(Diatheke.mods, "KJV")
    assert ! Enum.member?(Diatheke.mods, "")
  end
end

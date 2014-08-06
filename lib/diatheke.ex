defmodule Diatheke do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Diatheke.Supervisor.start_link
  end

  def mods do
    System.cmd("diatheke -b system -k modulelistnames") |> String.split(~r/\n/) |> Enum.reject(&(&1 == ""))
  end
end

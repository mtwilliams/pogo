defmodule CtlTest do
  use ExUnit.Case

  teardown do
    cmd("stop")
    :ok
  end

  test :cmds do
    path = "test/tmp/bin/ctl"
    if File.exists?(path), do: File.rm!(path)
    Pogo.Ctl.write(path, :pogo)

    assert "pogo could not be reached\n" == cmd("status")

    case cmd("start") do
      "pogo started as pogo@" <> _ ->
        assert true
      other ->
        IO.puts other
        assert false
    end

    assert "pogo is already running\n" == cmd("start")
    assert "pogo is running\n" == cmd("status")
  end

  defp cmd(args) do
    System.cmd("test/tmp/bin/ctl #{args}")
  end
end
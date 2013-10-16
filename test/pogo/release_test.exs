defmodule Pogo.ReleaseTest do
  use ExUnit.Case

  @script_path Path.expand("../tmp/bin/pogo", __DIR__)

  setup do
    if File.exists?(@script_path), do: File.rm!(@script_path)
    Pogo.Release.write(:pogo, @script_path)
    :ok
  end

  teardown(_) do
    cmd("stop")
    :ok
  end

  test :cmds do
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
    System.cmd("#{@script_path} #{args}")
  end
end

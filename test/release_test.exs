defmodule ReleaseTest do
	use ExUnit.Case

	defmodule MockRelease do
		def name(_), do: "mock"
	end

	test :write_ctl do
		mock_bin = "test/tmp/mock/bin/mock"
		if File.exists?(mock_bin), do: File.rm!(mock_bin)
		Pogo.Release.write_ctl(MockRelease, [path: "test/tmp"])
		assert File.exists?(mock_bin)
		assert "SERVER_NAME=mock\n" == System.cmd("cat test/tmp/mock/bin/mock | grep SERVER_NAME=")
	end
end
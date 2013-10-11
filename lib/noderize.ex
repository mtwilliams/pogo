defmodule Noderize do
	def alive?(node) do
		unless is_alive?(node) do
			IO.puts node_down(node)
			halt(1)
		end
		IO.puts "#{node} is alive"
		halt(0)
	end

	defp halt(status), do: :erlang.halt status

	def stop(node, timeout // 2000) do
		unless is_alive?(node) do
			IO.puts node_down(node)
			halt(1)
		end
		stop_node(node, timeout)
	end

	def stop_node(node, timeout) do
		case :rpc.call(node, :init, :stop, []) do
			:ok ->
				wait_for_node(node, timeout)
				halt(0)
			{ :badrpc, :nodedown } ->
				IO.puts node_down(node)
				halt(1)
		end
	end

	defp is_alive?(node) do
		:pong == :net_adm.ping(node)
	end

	defp wait_for_node(node, timeout) do
		wait_for_node(node, 1, 0, timeout)
	end

	defp wait_for_node(node, _, acc_wait, timeout) when acc_wait >= timeout do
		IO.puts "#{node} timed out"
		halt(1)
	end

	defp wait_for_node(node, interval, acc_wait, timeout) do
		if is_alive?(node) do
			ref = :erlang.make_ref
			self = Process.self
			:erlang.send_after(interval, self, { self, ref })
			receive do
				{ ^self, ^ref } ->
					acc_wait = acc_wait + interval
					wait_for_node(node, interval, acc_wait, timeout)
			end
		else
			IO.puts "#{node} stopped"
		end
	end

	defp node_down(node) do
		"#{node} is unreachable"
	end
end

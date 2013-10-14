defmodule Noderize do
	def alive?(node) when is_binary(node) do
		node |> binary_to_atom |> alive?
	end
	def alive?(node) do
		:pong == :net_adm.ping(node)
	end

	def alive!(node) do
		unless alive?(node), do: exit(1)
		exit(0)
	end

	def stop(node) when is_binary(node) do
		stop(node, 2000)
	end
	def stop(node, timeout) when is_binary(node) do
		node |> binary_to_atom |> stop(timeout)
	end
	def stop(node, timeout) do
		case :rpc.call(node, :init, :stop, []) do
			:ok ->
				wait_for_node(node, timeout)
				halt(0)
			{ :badrpc, :nodedown } ->
				halt(1)
		end
	end

	defp halt(status), do: :erlang.halt status

	defp wait_for_node(node, timeout) do
		wait_for_node(node, 1, 0, timeout)
	end

	defp wait_for_node(_, _, acc_wait, timeout) when acc_wait >= timeout do
		halt(1)
	end

	defp wait_for_node(node, interval, acc_wait, timeout) do
		if alive?(node) do
			ref = :erlang.make_ref
			self = Process.self
			:erlang.send_after(interval, self, { self, ref })
			receive do
				{ ^self, ^ref } ->
					acc_wait = acc_wait + interval
					wait_for_node(node, interval, acc_wait, timeout)
			end
		end
	end
end

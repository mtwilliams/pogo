defmodule Pogo do
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

  def stop(node, timeout // 2000) do
    rpc(node, :init, :stop, timeout)
  end

  def restart(node, timeout // 10000) do
    rpc(node, :init, :restart, timeout)
  end

  def reboot(node, timeout // 10000) do
    rpc(node, :init, :reboot, timeout)
  end

  defp halt(status), do: :erlang.halt status

  defp rpc(node, mod, fun, timeout) do
    rpc(node, mod, fun, [], timeout)
  end

  defp rpc(node, mod, fun, args, timeout) when is_binary(node) do
    node 
    |> binary_to_atom
    |> rpc(mod, fun, args, timeout)
  end
  defp rpc(node, mod, fun, args, timeout) do
    case :rpc.call(node, mod, fun, args, timeout) do
      :ok ->
        wait_for_node(node, timeout)
        halt(0)
      { :badrpc, :nodedown } ->
        halt(1)
    end
  end

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

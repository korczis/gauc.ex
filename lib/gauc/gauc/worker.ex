defmodule Gauc.Worker do
  @moduledoc """
  Gauc Worker - Poolboy Worker
  """

  use GenServer

  require Logger

  alias Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    {:ok, handle} = Client.connect("couchbase://localhost/default")
    {:ok, [handle: handle]}
  end

  def handle_call({:add, id, doc}, _from, state) do
    {:reply, Client.add(state[:handle], id, doc), state}
  end

  def handle_call({:append, id, doc}, _from, state) do
    {:reply, Client.append(state[:handle], id, doc), state}
  end

  def handle_call({:get, id}, _from, state) do
    {:reply, Client.get(state[:handle], id), state}
  end

  def handle_call({:prepend, id, doc}, _from, state) do
    {:reply, Client.prepend(state[:handle], id, doc), state}
  end

  def handle_call({:replace, id, doc}, _from, state) do
    {:reply, Client.replace(state[:handle], id, doc), state}
  end

  def handle_call({:set, id, doc}, _from, state) do
    {:reply, Client.set(state[:handle], id, doc), state}
  end

  def handle_call({:upsert, id, doc}, _from, state) do
    {:reply, Client.upsert(state[:handle], id, doc), state}
  end

  def handle_call({:stop, reason, new_state}, from, state) do
    IO.puts("Stopping")
    {:stop, reason, new_state}
  end

  def handle_info({:EXIT, _pid, _reason}, state) do
    IO.puts "exit"
    {:noreply, state}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    IO.puts "down"
    {:noreply, state}
  end

  def handle_info(msg, from, state) do
    Logger.debug(msg)

    {:noreply, state}
  end

  def handle_cast(msg, from, state) do
    Logger.debug(msg)
    {:noreply, state}
  end

  def terminate(reason, state) do
    IO.puts("Terminating ...")
    Logger.debug(reason)
    Logger.debug(state)

    Client.disconnect(state[:handle])
  end
end

#defmodule PoolboyApp.Test do
#  @timeout 60000
#
#  def start do
#    1..10_000
#    |> Enum.each(fn(i) -> async_call_insert(i) end)
#    # |> Enum.each(fn(task) -> await_and_inspect(task) end)
#
#    :ok
#  end
#
#  defp async_call_insert(i) do
#    Task.async(fn ->
#      :poolboy.transaction(:worker,
#        fn(pid) ->
#          GenServer.call(pid, {:upsert, "#{i - i}", "{}"})
#        end,
#        @timeout
#      )
#    end)
#  end
#
#  defp await_and_inspect(task) do
#    task
#    |> Task.await(@timeout)
#    |> IO.inspect()
#  end
#end

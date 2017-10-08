defmodule Gauc.NativeTest do
  use ExUnit.Case
  doctest Gauc

  @host "couchbase://localhost/default"

  describe "clients/0" do
    test "returns clients" do
      clients = Gauc.Native.clients
      assert {:ok, _} = clients
    end
  end

  describe "connect/1" do
    test "connects to server" do
      assert {:ok, {_, _}} = Gauc.Native.connect(@host)
    end
  end

  describe "disconnect/1" do
    test "disconnects from server" do
      assert {:ok, handle} = Gauc.Native.connect(@host)
      assert {:ok, handle} = Gauc.Native.disconnect(handle)
    end

    test "returns error when using invalid handle" do
      handle = {1, 2}
      assert {:error, {:invalid_handle, handle}} = Gauc.Native.disconnect(handle)
    end
  end
end

defmodule Gauc.NativeTest do
  use ExUnit.Case
  doctest Gauc

  @host "couchbase://localhost/default"
  @username "Administrator"
  @password "Administrator"

  describe "clients/0" do
    test "returns list of clients" do
      assert {:ok, clients} = Gauc.Native.clients
      assert is_list(clients)
    end
  end

  describe "connect/3" do
    test "connects to server" do
      assert {:ok, {_, _}} = Gauc.Native.connect(@host, @username, @password)
    end
  end

  describe "disconnect/1" do
    test "disconnects from server" do
      assert {:ok, handle} = Gauc.Native.connect(@host)
      assert {:ok, _handle} = Gauc.Native.disconnect(handle)
    end

    test "returns error when using invalid handle" do
      handle = {1, 2}
      assert {:error, {:invalid_handle, _handle}} = Gauc.Native.disconnect(handle)
    end
  end
end

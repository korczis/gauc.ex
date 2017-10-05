defmodule Gauc.Native do
  @moduledoc """
  Native extensions (using rustler)
  """

  use Rustler, otp_app: :gauc, crate: :gauc

  def connect(), do: throw :nif_not_loaded

  def add(_a, _b), do: throw :nif_not_loaded
  def append(_a, _b), do: throw :nif_not_loaded
  def get(_a), do: throw :nif_not_loaded
  def prepend(_a, _b), do: throw :nif_not_loaded
  def replace(_a, _b), do: throw :nif_not_loaded
  def set(_a, _b), do: throw :nif_not_loaded
  def upsert(_a, _b), do: throw :nif_not_loaded

  def test do
    upsert("a", "{}")
    test()
  end
end

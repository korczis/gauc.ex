defmodule Gauc.Native do
  @moduledoc """
  Native extensions (using rustler)
  """

  use Rustler, otp_app: :gauc, crate: :gauc

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: throw :nif_not_loaded
  def sub(_a, _b), do: throw :nif_not_loaded
end

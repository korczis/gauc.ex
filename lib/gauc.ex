defmodule Gauc do
  @moduledoc """
  Gauc OTP Application
  """

  use Application

  @config Application.get_env(:gauc, __MODULE__)

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    poolboy_config = [
      {:name, {:local, pool_worker_module()}},
      {:worker_module, pool_worker_module()},
      {:size, @config[:pool][:size]},
      {:max_overflow, @config[:pool][:max_overflow]}
    ]

    url = @config[:url]

    # Define workers and child supervisors to be supervised
    children = [
      :poolboy.child_spec(pool_worker_module(), poolboy_config, [url: url])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [
      strategy: :one_for_one,
      name: Gauc.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end

  defp pool_worker_module do
    @config[:pool][:worker] || Gauc.Worker
  end
end

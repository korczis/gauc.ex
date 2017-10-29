defmodule Gauc.Mixfile do
  use Mix.Project

  def project do
    [
      app: :gauc,
      version: "0.11.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      compilers: [:rustler] ++ Mix.compilers,
      rustler_crates: rustler_crates(),
      description: description(),
      package: package(),
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      dialyzer: [plt_add_deps: :transitive]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [
        :poolboy
      ],
      extra_applications: [
        :logger
      ],
      mod: {Gauc, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 0.9", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:poison, "~> 3.1"},
      {:poolboy, "~> 1.5"},
      {:rustler, "~> 0.10"},
    ]
  end

  defp docs do
    [
      source_ref: "master",
      main: "Gauc",
      canonical: "http://hexdocs.pm/gauc",
      source_url: "https://github.com/korczis/gauc",
      extras: [
        "README.md"
      ]
    ]
  end

  def rustler_crates do
    [
      gauc: [
        path: "native/gauc",
        mode: :release
      ]
    ]
  end

  defp description() do
    "Elxir Wrapper for Gauc - Rust Wrapper for Couchbase"
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "gauc",
      # These are the default files included in the package
      files:
        [
        "lib",
        "mix.exs",
        "native",
        "README*",
        "LICENSE*"
      ],
      maintainers:
        [
        "Tomas Korcak <korczis@gmail.com>"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/korczis/gauc.ex"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "check": [
        "test --trace",
        "credo --strict --all",
        "hex.audit",
        "hex.outdated",
        # "escript.build",
        "app.tree"
      ]
    ]
  end
end

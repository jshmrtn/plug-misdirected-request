defmodule PlugMisdirectedRequest.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :plug_misdirected_request,
      version: "1.0.1",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Yield 421 Error on HTTP/2 wrong host in connection.
    """
  end

  defp package do
    # These are the default files included in the package
    [
      name: :plug_misdirected_request,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Jonatan Männchen"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jshmrtn/plug-misdirected-request"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mock, "~> 0.3", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:plug, "~> 1.6"},
      {:phoenix, "~> 1.3", optional: true}
    ]
  end
end

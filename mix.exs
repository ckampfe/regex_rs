defmodule RegexRs.MixProject do
  use Mix.Project

  def project do
    [
      app: :regex_rs,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod || Mix.env() == :bench,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 1.0", only: [:dev, :bench]},
      {:rustler, "~> 0.22.0-rc.1"}
    ]
  end
end

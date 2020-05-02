defmodule Joy.MixProject do
  use Mix.Project

  def project do
    [
      app: :joy,
      version: String.trim(File.read!("VERSION")),
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [main_module: Joy.REPL, path: Path.expand("~/bin/joy")]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:eliver, "~> 2.0", only: :dev}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

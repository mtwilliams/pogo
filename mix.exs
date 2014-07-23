defmodule Pogo.Mixfile do
  use Mix.Project

  def project do
    [ app: :pogo,
      version: version,
      name: "Pogo",
      description: "A simple Elixir release controller.",
      source_url: "https://github.com/mtwilliams/pogo",
      elixir: "~> 0.14.3",
      homepage_url: "https://github.com/mtwilliams/pogo",
      package: [links: %{"Website" => "https://github.com/mtwilliams/pogo",
                         "Source" => "https://github.com/mtwilliams/pogo"},
                contributors: ["Kurt Williams", "Michael Williams"],
                licenses: ["MIT"]],
      deps: deps(Mix.env),
      docs: docs
    ]
  end

  def application do
    []
  end

  def version do
    String.strip(File.read!("VERSION"))
  end

  defp deps(_) do
    []
  end

  defp docs do
    {ref, 0} = System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])
    [source_ref: ref,
     readme: true,
     main: "README.md"]
  end
end

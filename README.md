# Pogo: Simple Elixir release controller

Pogo provides your Elixir project with a module and companion shell script
that you can use to start and stop (and a few other commands) an Elixir
application packaged as an Erlang release.

## Including it in your release

The best way to use Pogo is in conjunction with [Relex][2]. All you need to do is include Pogo in
your deps and create a release like this in your Mix project:

```elixir
defmodule Release do
  use Relex.Release
  use Pogo.Release

  def applications do
  	[:pogo, Mix.project[:app]]
  end
end
```

**Note** Don't forget to add `:pogo` to the list of applications in your release.

## Starting your release

Once you've got that in-place, just run `mix relex.assemble`. Pogo will dump
an executable to `/path/to/release/bin/<Release.name>` that you can use to
start your release. If you've got a `.erlang.cookie` file in your path,
running `/path/to/release/bin/<Release.name> start` will boot your app.
Any arguments passed to the script will be fed to the `erl` executable.

## Other commands

- **start**: calls `:init.start` on your node
- **stop**: calls `:init.stop` on your node
- **restart**: calls `:init.restart` on our node
- **reboot**: calls `:init.reboot` on your node. *Notice*: If heartbeat isn't
  enabled, running this command will result in your node stopping,
  but not arestarting
- **console**: loads up your node in `iex`. When `iex` quits, your node does too
- **attach**: `iex --remsh` onto your node. Quiting this does not affect your node
- **status**: checks if your node is reachable and responding to pings (probably
  should check if your app is running via `:application.which_applications`, too)

[1]: https://github.com/interline/relex "Interline's fork of yrashk/relex"
[2]: https://github.com/yrashk/relex

# Pogo: Simple elixir release up and down

Pogo provides your project with an elixir module and companion shell script
that you can use to start and stop (and a few other cmds) an elixir
application packaged as an erlang release.

## Including it in your release

The best way to use pogo is in conjunction with interline's [fork][1] of
[Relex][2]. All you need to do is include pogo in your deps and create a
release like this in your mix project:

```elixir
def Release do
	use Relex.Release

	@after_bundle :write_script

	def name, do: "myapp"
	# this is the default, but elixir MUST to be included
	def include_elixir?, do: true
	# you *can* include elixir without erts, but elixir won't run...
	def include_erts?, do: true
	# pogo needs these to run properly
	def default_release?, do: false
	def include_start_clean?, do: true
	def write_script(options) do
		Pogo.Ctl.write_script(__MODULE__, options)
	end
end
```

## Starting your release

Once you've got that in-place, just run `mix relex.assemble`. Pogo will dump
an executable to `/path/to/release/bin/<Release.name>` you can use to
start your release. If you've got a .erlang.cookie file in your path, running
`/path/to/release/bin/<Release.name> start` will boot your app. Any arguments
passed to the script will be feed to the `erl` executable

## Other Commands

- *stop*: calls `:init.stop` on your node
- *restart*: calls `:init.restart` on our node
- *reboot*: calls `:init.reboot` on your node. *Notice* if heartbeat isn't enabled
	running this command will result in your node stopping, but not restarting
- *console*: loads up your node in iex. When iex quits, your node does, too
- *attach*: `iex --remsh` onto your node. Quiting this does not affect your node
- *status*: checks if your node is reachable and responding to pings (probably
	should check if your app is running via `:application.which_applications, too)

[1]: https://github.com/interline/relex "Interline's fork of yrashk/relex"
[2]: https://github.com/yrashk/relex

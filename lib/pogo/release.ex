defmodule Pogo.Release do
	def make_ctl(release, options) do
		app  = release.name(options)
    path = Path.join([ options[:path] || File.cwd!, release.name(options), "bin", app ])
    file = Path.join([ File.cwd!, "deps", "pogo", "bin", "ctl.eex" ])
		File.write(path, EEx.eval_file(file, app: app))
		File.chmod(path, 0544)
	end
end
defmodule Pogo.Release do
	def write_ctl(release, options) do
		app  = release.name(options)
    path = Path.join([ options[:path] || File.cwd!, app, "bin", app ])
    tmpl = Path.join([ :code.priv_dir(:pogo), "bin", "ctl.eex" ])
    
    unless File.exists?(bin_path = Path.dirname(path)), do: File.mkdir_p!(bin_path)
		
		File.write(path, EEx.eval_file(tmpl, app: app))
		File.chmod(path, 0544)
	end
end
defmodule Pogo.Release do
  def write_ctl(release, options) do
    app  = release.name(options)
    path = Path.join([ options[:path] || File.cwd!, app, "bin", app ])
    Pogo.Ctl.write(path, app)
  end
end
defmodule Pogo.Ctl do
  def write(path, app) do
    tmpl = Path.join([ :code.priv_dir(:pogo), "bin", "ctl.eex" ])
    unless File.exists?(bin_path = Path.dirname(path)), do: File.mkdir_p!(bin_path)
    File.write(path, EEx.eval_file(tmpl, app: app))
    File.chmod(path, 0544)
  end
end
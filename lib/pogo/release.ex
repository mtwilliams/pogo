defmodule Pogo.Release do
  defmacro __using__(_) do
    quote do
      @after_bundle :pogo_write_script!

      def include_elixir?, do: true
      def include_erts?, do: true
      def default_release?, do: false
      def include_start_clean?, do: true

      def pogo_write_script!(options) do
        app  = name(options)
        path = Path.join([ options[:path] || File.cwd!, app, "bin", app ])
        Pogo.Release.write(app, path)
      end
    end
  end

  def write(app, path) do
    tmpl = Path.join([ :code.priv_dir(:pogo), "bin", "script.eex" ])
    unless File.exists?(bin_path = Path.dirname(path)), do: File.mkdir_p!(bin_path)
    File.write(path, EEx.eval_file(tmpl, app: app))
    File.chmod(path, 0755)
  end
end

defmodule ElixirJsonWeb.PageController do
  use ElixirJsonWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home)
  end

  def create(conn, params) do
    if upload = params["file"] do
      csv_file = File.stream!(upload.path)
      csv_content = CSV.decode(csv_file)
                    |> Enum.map(fn {:ok, val} -> val end)
      content = to_json(csv_content)
                |>Jason.encode!()
      file = File.write("media/pokemon.json", content)
      IO.inspect(upload)
    end
    render(conn, :home)
  end

  defp to_json(data) do
    headers = Enum.map(Enum.at(data, 0), &String.to_atom/1)
    val = Enum.map(Enum.slice(data, 1, length(data) - 1), fn row ->
      Enum.zip(headers, row) |> Enum.into(%{})
    end)
  end
end

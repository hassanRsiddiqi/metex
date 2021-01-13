defmodule Metex.Worker do

  def loop do
    receive do
      {sender, location} ->
        send(sender, {:ok, temp(location)})
      _ ->
        IO.puts("Don't know what to do.")
    end
    loop()
  end
  def temp(location) do
    temp = location
    |>get_url
    |>HTTPoison.get
    |>parse
    case temp do
      {:ok, result} ->
        "#{location} #{result}"
      _ ->
        "#{location} not found"
    end
  end
  defp parse({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body
    |>JSON.decode!
    |>get_temp
  end
  defp parse(_), do: :error
  defp get_temp(data) do
    try do
    temp = data["main"]["temp"] - 273.15
    {:ok, temp}
    rescue
      _ -> :error
    end
  end
  defp get_url(location) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
  end
  def apikey(), do: "1859b4fbf0af1712a060a40a6f244e3b"
end

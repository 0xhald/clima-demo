defmodule Clima.OpenWeatherMap do
  @moduledoc """
  Weather context module for interacting with OpenWeatherMap API
  """

  @day_in_3h_intervals 8

  @doc """
  Searches for cities matching the given query using OpenWeatherMap Geocoding API.
  Returns a list of city matches with name, country, coordinates.
  """
  def search_cities(query) when is_binary(query) and query != "" do
    case geocoding_request(query) do
      {:ok, cities} -> {:ok, format_city_results(cities)}
      {:error, reason} -> {:error, reason}
    end
  end

  def search_cities(_), do: {:ok, []}

  @doc """
  Fetches current weather for a city using coordinates.
  Returns current temperature, min/max, and conditions.
  """
  def get_current_weather(lat, lon) do
    case current_weather_request(lat, lon) do
      {:ok, weather_data} -> {:ok, format_current_weather(weather_data)}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Fetches 24-hour forecast for a city using coordinates.
  Returns hourly temperature data for the next 24 hours.
  """
  def get_hourly_forecast(lat, lon) do
    case forecast_request(lat, lon) do
      {:ok, forecast_data} -> {:ok, format_hourly_forecast(forecast_data)}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Fetches 7-day forecast for a city using coordinates.
  Returns daily min/max temperatures for the next 7 days.
  """
  def get_daily_forecast(lat, lon) do
    case forecast_request(lat, lon) do
      {:ok, forecast_data} -> {:ok, format_daily_forecast(forecast_data)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp make_api_request(endpoint, params) do
    url = "#{base_url()}#{endpoint}"

    case Req.get(url, params: Map.put(params, :appid, api_key())) do
      {:ok, %{status: 200, body: body}} -> {:ok, body}
      {:ok, %{status: status}} -> {:error, "API request failed with status #{status}"}
      {:error, reason} -> {:error, "Network error: #{inspect(reason)}"}
    end
  end

  defp geocoding_request(query) do
    make_api_request("/geo/1.0/direct", %{q: query, limit: 5})
  end

  defp current_weather_request(lat, lon) do
    make_api_request("/data/2.5/weather", %{lat: lat, lon: lon, units: "metric"})
  end

  defp forecast_request(lat, lon) do
    make_api_request("/data/2.5/forecast", %{lat: lat, lon: lon, units: "metric"})
  end

  defp format_city_results(cities) when is_list(cities) do
    Enum.map(cities, fn city ->
      %{
        name: city["name"],
        country: city["country"],
        state: city["state"],
        lat: city["lat"],
        lon: city["lon"]
      }
    end)
  end

  defp format_current_weather(weather_data) do
    main = weather_data["main"] || %{}
    weather_info = weather_data["weather"] |> List.first() || %{}

    %{
      temperature: safe_round(main["temp"]),
      feels_like: safe_round(main["feels_like"]),
      temp_min: safe_round(main["temp_min"]),
      temp_max: safe_round(main["temp_max"]),
      humidity: main["humidity"],
      description: weather_info["description"],
      icon: weather_info["icon"]
    }
  end

  defp format_hourly_forecast(forecast_data) do
    forecast_data["list"]
    |> Enum.take(@day_in_3h_intervals)
    |> Enum.map(fn item ->
      main = item["main"] || %{}
      weather_info = item["weather"] |> List.first() || %{}

      %{
        datetime: DateTime.from_unix!(item["dt"]),
        temperature: safe_round(main["temp"]),
        description: weather_info["description"],
        icon: weather_info["icon"]
      }
    end)
  end

  defp format_daily_forecast(forecast_data) do
    forecast_data["list"]
    |> group_by_date()
    |> create_daily_summaries()
    |> Enum.take(7)
  end

  defp group_by_date(forecast_list) do
    Enum.group_by(forecast_list, fn item ->
      DateTime.from_unix!(item["dt"]) |> DateTime.to_date()
    end)
  end

  defp create_daily_summaries(grouped_data) do
    Enum.map(grouped_data, fn {date, items} ->
      temps =
        Enum.map(items, fn item ->
          get_in(item, ["main", "temp"]) || 0
        end)

      first_item = List.first(items) || %{}
      weather_info = get_in(first_item, ["weather", Access.at(0)]) || %{}

      %{
        date: date,
        temp_min: safe_round(Enum.min(temps)),
        temp_max: safe_round(Enum.max(temps)),
        description: weather_info["description"],
        icon: weather_info["icon"]
      }
    end)
  end

  defp safe_round(nil), do: 0
  defp safe_round(value), do: round(value)

  defp api_key do
    Application.get_env(:clima, __MODULE__)[:api_key] ||
      config_error("OpenWeatherMap API key", "OPENWEATHERMAP_API_KEY environment variable")
  end

  defp base_url do
    Application.get_env(:clima, __MODULE__)[:base_url] ||
      config_error("OpenWeatherMap base URL", "config files")
  end

  defp config_error(setting, location) do
    raise "#{setting} not configured. Check #{location}."
  end
end

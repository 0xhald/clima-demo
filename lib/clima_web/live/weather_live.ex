defmodule ClimaWeb.WeatherLive do
  alias Clima.OpenWeatherMap

  import ClimaWeb.Components.SearchComponent
  import ClimaWeb.Components.FooterComponent
  import ClimaWeb.Components.ForecastComponent

  use ClimaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, results: [], search_query: "", city_forecast: %{})
    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"query" => ""}, socket) do
    socket = assign(socket, results: [], search_query: "")
    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {:ok, results} = OpenWeatherMap.search_cities(query)
    socket = assign(socket, results: results, search_query: query)
    {:noreply, socket}
  end

  @impl true
  def handle_event("detalles", %{"lat" => lat, "lon" => lon}, socket) do
    {:ok, current_weather} = OpenWeatherMap.get_current_weather(lat, lon)
    {:ok, hourly_forecast} = OpenWeatherMap.get_hourly_forecast(lat, lon)
    {:ok, daily_forecast} = OpenWeatherMap.get_daily_forecast(lat, lon)

    socket =
      assign(socket,
        city_forecast: %{
          current: current_weather,
          hourly: hourly_forecast,
          daily: daily_forecast
        },
        results: []
      )

    {:noreply, socket}
  end
end

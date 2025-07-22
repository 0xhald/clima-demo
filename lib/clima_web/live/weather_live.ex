defmodule ClimaWeb.WeatherLive do
  alias Clima.OpenWeatherMap

  import ClimaWeb.Components.{
    HeroComponent,
    SearchComponent,
    ForecastComponent
  }

  use ClimaWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.hero>
      <.search on_search="search" search_value={@search_query} search_placeholder="Buscar ciudad" />
    </.hero>
    <%= if Enum.any?(@results) do %>
      <.search_results results={@results} />
    <% end %>
    <%= if Enum.any?(@city_forecast) do %>
      <.forecast_details forecast_data={@city_forecast} />
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, results: [], search_query: "", city_forecast: %{})
    IO.inspect(socket)
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
  def handle_event("details", %{"lat" => lat, "lon" => lon}, socket) do
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

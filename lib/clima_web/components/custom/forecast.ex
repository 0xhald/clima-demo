defmodule ClimaWeb.Components.ForecastComponent do
  use Phoenix.Component

  def forecast_details(assigns) do
    ~H"""
    <.current_weather data={@forecast_data.current} />
    <.hourly_forecast data={@forecast_data.hourly} />
    """
  end

  def current_weather(assigns) do
    ~H"""
    <div class="card lg:card-side bg-base-100 shadow-sm">
      <figure>
        <img src={"https://openweathermap.org/img/wn/#{@data.icon}@2x.png"} alt={@data.description} />
        <figcaption>{@data.description}</figcaption>
      </figure>
      <div class="card-body">
        <h2 class="card-title">Current weather</h2>
        <p>{@data.temperature}°C</p>
        <p>Feels like {@data.feels_like}°C</p>
        <p>Max {@data.temp_max}°C</p>
        <p>Min {@data.temp_min}°C</p>
        <p>Humidity {@data.humidity}%</p>
      </div>
    </div>
    """
  end

  def hourly_forecast(assigns) do
    ~H"""
    <div class="carousel rounded-box">
      <%= for hour <- @data do %>
        <div class="carousel-item">
          <.hourly_card data={hour} />
        </div>
      <% end %>
    </div>
    """
  end

  def hourly_card(assigns) do
    ~H"""
    <div class="card w-96 bg-base-100 card-sm shadow-sm">
      <div class="card-body items-center text-center">
        <h2 class="card-title">{@data.datetime.hour}:00</h2>
        <figure>
          <img src={"https://openweathermap.org/img/wn/#{@data.icon}.png"} alt={@data.description} />
        </figure>
        <p>{@data.description}</p>
        <p>{@data.temperature}°C</p>
      </div>
    </div>
    """
  end
end

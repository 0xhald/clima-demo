defmodule ClimaWeb.Components.SearchComponent do
  use Phoenix.Component

  attr :on_search, :any, default: nil
  attr :search_value, :string, default: ""
  attr :search_placeholder, :string, default: ""

  def search(assigns) do
    ~H"""
    <form phx-submit={@on_search} class="join">
      <div>
        <label class="input validator join-item">
          <svg class="h-[1em] opacity-50" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <g
              stroke-linejoin="round"
              stroke-linecap="round"
              stroke-width="2.5"
              fill="none"
              stroke="currentColor"
            >
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.3-4.3"></path>
            </g>
          </svg>
          <input
            type="text"
            name="query"
            placeholder={@search_placeholder}
            value={@search_value}
            required
          />
        </label>
        <div class="validator-hint hidden">Escribe algo</div>
      </div>
      <button class="btn btn-primary join-item">Buscar</button>
    </form>
    """
  end

  def search_results(assigns) do
    ~H"""
    <table class="table">
      <!-- head -->
      <thead>
        <tr>
          <th></th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <!-- row 1 -->
        <%= for result <- @results do %>
          <tr>
            <td>
              {result.name}, {result.state}, {result.country}
            </td>
            <th>
              <button
                phx-click="detalles"
                phx-value-lat={result.lat}
                phx-value-lon={result.lon}
                class="btn btn-primary"
              >
                detalles
              </button>
              <button class="btn btn-secondary">favorito</button>
            </th>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end
end

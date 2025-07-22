defmodule ClimaWeb.Components.NavbarComponent do
  use Phoenix.Component

  def navbar(assigns) do
    ~H"""
    <div class="navbar bg-base-100 shadow-sm">
      <div class="flex-1">
        <a class="btn btn-ghost text-xl">
          <img src="/images/logo.svg" width="36" /> ClimApp
        </a>
      </div>
      <div class="navbar-end">
        <ul class="menu menu-horizontal w-full relative z-10 flex items-center gap-4 px-4 sm:px-6 lg:px-8 justify-end">
          <%= if @current_scope do %>
            <li>
              {@current_scope.user.email}
            </li>
            <li>
              <.link href="/users/log-out" method="delete">Log out</.link>
            </li>
          <% else %>
            <li>
              <.link href="/users/log-in">Log in</.link>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end

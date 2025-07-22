defmodule ClimaWeb.Components.HeroComponent do
  use Phoenix.Component

  slot :inner_block, required: false

  def hero(assigns) do
    ~H"""
    <div
      class="hero min-h-100"
      style="background-image: url(https://img.daisyui.com/images/stock/photo-1507358522600-9f71e620c44e.webp);"
    >
      <div class="hero-overlay"></div>
      <div class="hero-content w-full text-center">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end
end

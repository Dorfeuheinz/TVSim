defmodule TvSimulationWeb.SimulationLive do
  @moduledoc false
  use TvSimulationWeb, :live_view
  require Logger
  alias TvSimulation.{Simulation, Simulator}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-4">
      <.header>
        Simulation of tracking TV habits
        <:subtitle>Recruitment task for MindNexus company</:subtitle>
      </.header>

      <div class="grid grid-cols-3 gap-4">
        <.card title="Time passed"><%= @simulation_time_passed %> minutes</.card>
        <.card title="Participants"><%= @simulation_participants %></.card>
        <.card title="Channels"><%= @simulation_channels %></.card>
      </div>

      <.simple_form for={@form} phx-submit="save" phx-change="change">
        <.input
          field={@form[:question]}
          type="text"
          label="Question"
          placeholder="What would you like to ask?"
        />
        <:actions>
          <.button>Ask a question</.button>
        </:actions>
      </.simple_form>

      <p class="border p-4 italic rounded-lg">

      </p>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:simulation_time_passed, 0)
      |> assign(:form, get_form(%{}))
      # these can be hardcoded for the purpose of take-home assignment
      |> assign(:simulation_participants, 100)
      |> assign(:simulation_channels, 5)
      |> assign(:response, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("change", %{"form" => params}, socket) do
    {:noreply, assign(socket, :form, get_form(params, action: :insert))}
  end

  @impl true
  def handle_event("save", %{"form" => %{"question" => question}}, socket) do
    Logger.info([Simulator.get_stats()])

    data = Simulator.get_stats()
    response = case Instructor.chat_completion(
      model: "llama3-70b-8192",
      response_model: Simulation,
      max_retries: 3,
      messages: [
        %{
          role: "user",
          content: """
          Heres the context you need to refer to answer questions-
          format: channel_name: duration_of_user1, duration_of_user2, ....
          none isnt a channel, rather it means user is waiting for the tv to switch on
          ```
          #{data}
          ```

          The question is:
          ```
          #{question}
          ```
          Reply in natural language
          """
        }
      ]
    ) do

      {:ok, response} -> response
      {:error, error} -> error

    end
    # %TvSimulation.Simulation{user_id: user_id, channel: channel, duration: duration} = response
    Logger.info(response)
    {:noreply, assign(socket, :response, response)}
  end

  defp get_form(params, action \\ :ignore) do
    params
    |> get_changeset()
    |> Map.put(:action, action)
    |> to_form(as: :form)
  end

  defp get_changeset(params) do
    data = %{}
    types = %{question: :string}

    {data, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required([:question])
  end

  # defp update_behaviour do

  # end

end

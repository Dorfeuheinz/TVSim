defmodule TvSimulation.Simulation do
  use Ecto.Schema

  # @doc """
  # Time durations for which different TV channels are being watched by users

  # ## Fields:
  # - user_id: ID number of the user (from range 1 - 100)
  # - channel: Channel name can be - ZDF, RTL, ProSieben, Vox, Das Erste, None- ( in case TV switched off)
  # - duration: Time spent watching that channel (from range 1 - 120)

  # Answer must be given in natural language
  # Ex. user 3 watched Vox for 29 minutes, which is the highest of all
  # """
  # @primary_key false
  # embedded_schema do
  #   field(:user_id, :id)
  #   field(:channel, Ecto.Enum,
  #     values: [:zdf, :rtl, :prosieben, :vox, :das_erste, :none]
  #   )
  #   field(:duration, :integer)
  # end

  @doc """
  Time durations for which different TV channels are being watched by users-

  ## Fields:
  - answer: Reply to a question based upon given context

  Answer must be given in natural language
  Ex. user 3 watched Vox for 29 minutes, which is the highest of all
  """
  @primary_key false
  embedded_schema do
    field(:answer, :string)
  end

end

defmodule Divsoup.Achievement do
  @type hierarchy :: :bronze | :silver | :gold

  @enforce_keys [:title, :description, :hierarchy]
  defstruct [:title, :description, :hierarchy]

  @type t() :: %__MODULE__{
          title: String.t(),
          description: String.t(),
          hierarchy: hierarchy()
        }
end

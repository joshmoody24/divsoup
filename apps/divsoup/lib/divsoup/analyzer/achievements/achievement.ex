defmodule Divsoup.Achievement do
  @type hierarchy :: :bronze | :silver | :gold | :platinum | nil

  @enforce_keys [:title, :group, :description, :hierarchy]
  defstruct [:title, :group, :description, :hierarchy]

  @type t() :: %__MODULE__{
          title: String.t(),
          group: String.t(),
          description: String.t(),
          hierarchy: hierarchy()
        }
end

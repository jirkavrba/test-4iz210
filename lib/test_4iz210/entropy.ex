defmodule Test4iz210.Entropy do
  defmodule Dataset do
    @type t :: %__MODULE__{
            rows: list(map()),
            attributes: list(atom()),
            class_attribute: atom()
          }
    @enforce_keys [:rows, :attributes, :class_attribute]
    defstruct [:rows, :attributes, :class_attribute]
  end

  defmodule EntropyQuestion do
    @type t :: %__MODULE__{
            dataset: Dataset.t(),
            selected_attribute: atom(),
            entropy: float(),
            information_gain: float()
          }
    @enforce_keys [:dataset, :selected_attribute, :information_gain, :entropy]
    defstruct [:dataset, :selected_attribute, :information_gain, :entropy]
  end

  @spec generate_entropy_question() :: EntropyQuestion.t()
  def generate_entropy_question() do
    attributes = [:a, :b, :c, :d, :class]

    dataset = generate_dataset(attributes, :class)
    selected_attribute = Enum.random([:a, :b, :c, :d])

    entropy = compute_entropy(dataset)
    information_gain = compute_information_gain(dataset, selected_attribute)

    %EntropyQuestion{
      dataset: dataset,
      selected_attribute: selected_attribute,
      information_gain: information_gain,
      entropy: entropy
    }
  end

  @spec compute_information_gain(Dataset.t(), atom()) :: float()
  defp compute_information_gain(%Dataset{rows: rows} = dataset, selected_attribute) do
    total = length(rows)
    entropy = compute_entropy(dataset)

    reduced_entropy =
      rows
      |> Enum.group_by(fn row -> row[selected_attribute] end)
      |> Enum.map(fn {_, subset} ->
        length(subset) / total * compute_entropy(%Dataset{dataset | rows: subset})
      end)
      |> Enum.sum()

    entropy - reduced_entropy
  end

  @spec compute_entropy(Dataset.t()) :: float()
  defp compute_entropy(%Dataset{rows: rows, class_attribute: class_attribute}) do
    total = length(rows)

    rows
    |> Enum.map(fn row -> row[class_attribute] end)
    |> Enum.frequencies()
    |> Enum.map(fn {_, count} -> count / total * :math.log2(count / total) end)
    |> Enum.sum()
    |> then(fn sum -> -sum end)
  end

  @spec generate_dataset(list(atom()), atom()) :: Dataset.t()
  defp generate_dataset(attributes, class_attribute)
       when is_list(attributes) and is_atom(class_attribute) do
    size = Enum.random(5..8)
    rows = Stream.repeatedly(fn -> generate_row(attributes) end) |> Enum.take(size)

    %Dataset{rows: rows, attributes: attributes, class_attribute: class_attribute}
  end

  defp generate_row(attributes) do
    attributes
    |> Enum.map(fn attribute -> {attribute, Enum.random(0..1) == 1} end)
    |> Map.new()
  end
end

defmodule Test4iz210.EuclideanDistance do
  defmodule EuclideanDistanceQuestion do
    @type t :: %__MODULE__{
            first_vector: list(integer()),
            second_vector: list(integer()),
            distance: float()
          }
    @enforce_keys [:first_vector, :second_vector, :distance]
    defstruct [:first_vector, :second_vector, :distance]
  end

  @spec generate_euclidean_distance_question() :: EuclideanDistanceQuestion.t()
  def generate_euclidean_distance_question() do
    vector_length = Enum.random(2..5)
    first_vector = generate_random_vector(vector_length)
    second_vector = generate_random_vector(vector_length)

    %EuclideanDistanceQuestion{
      first_vector: first_vector,
      second_vector: second_vector,
      distance: compute_distance(first_vector, second_vector)
    }
  end

  @spec generate_random_vector(integer()) :: list(integer())
  defp generate_random_vector(length) do
    Enum.map(0..length, fn _ -> Enum.random(0..8) end)
  end

  defp compute_distance(first_vector, second_vector) do
    first_vector
    |> Enum.zip(second_vector)
    |> Enum.map(fn {x, y} -> (x - y) * (x - y) end)
    |> Enum.sum()
    |> :math.sqrt()
  end
end

defmodule Test4iz210.ConfusionMatrix do
  defmodule Result do
    @type t :: %__MODULE__{
            id: integer(),
            prediction: boolean(),
            reality: boolean()
          }
    @enforce_keys [:id, :prediction, :reality]
    defstruct [:id, :prediction, :reality]
  end

  defmodule ConfusionMatrix do
    @type t :: %__MODULE__{
            true_positive: integer(),
            false_positive: integer(),
            false_negative: integer(),
            true_negative: integer()
          }
    @enforce_keys [:true_positive, :false_positive, :false_negative, :true_negative]
    defstruct [:true_positive, :false_positive, :false_negative, :true_negative]
  end

  defmodule ConfusionMatrixQuestion do
    @type t :: %__MODULE__{
            results: list(Result.t()),
            confusion_matrix: ConfusionMatrix.t(),
            precision_class: boolean(),
            recall_class: boolean(),
            precision: float(),
            recall: float(),
            accuracy: float()
          }
    @enforce_keys [
      :results,
      :confusion_matrix,
      :precision_class,
      :recall_class,
      :precision,
      :recall,
      :accuracy
    ]
    defstruct [
      :results,
      :confusion_matrix,
      :precision_class,
      :recall_class,
      :precision,
      :recall,
      :accuracy
    ]
  end

  @spec generate_confusion_matrix_question() :: ConfusionMatrixQuestion.t()
  def generate_confusion_matrix_question() do
    results = generate_results()
    confusion_matrix = compute_confusion_matrix(results)
    precision_class = random_boolean()
    recall_class = random_boolean()

    %ConfusionMatrixQuestion{
      results: results,
      confusion_matrix: confusion_matrix,
      precision_class: precision_class,
      recall_class: recall_class,
      precision: compute_precision(confusion_matrix, precision_class),
      recall: compute_recall(confusion_matrix, recall_class),
      accuracy: compute_accuracy(confusion_matrix)
    }
  end

  @spec compute_precision(ConfusionMatrix.t(), boolean()) :: float()
  defp compute_precision(
         %ConfusionMatrix{true_positive: true_positive, false_positive: false_positive},
         true
       ),
       do: true_positive / (true_positive + false_positive)

  defp compute_precision(
         %ConfusionMatrix{true_negative: true_negative, false_negative: false_negative},
         false
       ),
       do: true_negative / (true_negative + false_negative)

  @spec compute_recall(ConfusionMatrix.t(), boolean()) :: float()
  defp compute_recall(
         %ConfusionMatrix{true_positive: true_positive, false_negative: false_negative},
         true
       ),
       do: true_positive / (true_positive + false_negative)

  defp compute_recall(
         %ConfusionMatrix{true_negative: true_negative, false_positive: false_positive},
         false
       ),
       do: true_negative / (true_negative + false_positive)

  @spec compute_accuracy(ConfusionMatrix.t()) :: float()
  defp compute_accuracy(matrix) do
    (matrix.true_positive + matrix.true_negative) /
      (matrix.true_positive + matrix.true_negative + matrix.false_positive + matrix.false_negative)
  end

  @spec compute_confusion_matrix(list(Result.t())) :: ConfusionMatrix.t()
  defp compute_confusion_matrix(results) do
    %ConfusionMatrix{
      true_positive: Enum.count(results, fn row -> row.prediction and row.reality end),
      false_positive: Enum.count(results, fn row -> row.prediction and not row.reality end),
      false_negative: Enum.count(results, fn row -> not row.prediction and row.reality end),
      true_negative: Enum.count(results, fn row -> not row.prediction and not row.reality end)
    }
  end

  @spec generate_results() :: list(Result.t())
  defp generate_results() do
    Enum.map(1..10, fn index ->
      %Result{id: index, prediction: random_boolean(), reality: random_boolean()}
    end)
  end

  @spec random_boolean() :: boolean()
  defp random_boolean() do
    Enum.random(0..1) == 1
  end
end

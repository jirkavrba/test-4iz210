defmodule Test4iz210.AssociativeRules do
  defmodule ContingencyTable do
    @type t :: %__MODULE__{
            a_c: integer(),
            a_not_c: integer(),
            not_a_c: integer(),
            not_a_not_c: integer()
          }
    @enforce_keys [:a_c, :a_not_c, :not_a_c, :not_a_not_c]
    defstruct [:a_c, :a_not_c, :not_a_c, :not_a_not_c]
  end

  defmodule AssociativeRuleQuestion do
    @type t :: %__MODULE__{
            contingency_table: ContingencyTable.t(),
            confidence: float(),
            support: float(),
            lift: float()
          }
    @enforce_keys [:contingency_table, :confidence, :support, :lift]
    defstruct [:contingency_table, :confidence, :support, :lift]
  end

  @spec generate_associative_rule_question() :: AssociativeRuleQuestion.t()
  def generate_associative_rule_question() do
    contingency_table = generate_contingency_table()

    %AssociativeRuleQuestion{
      contingency_table: contingency_table,
      confidence: compute_confidence(contingency_table),
      support: compute_support(contingency_table),
      lift: compute_lift(contingency_table)
    }
  end

  @spec compute_confidence(ContingencyTable.t()) :: float()
  defp compute_confidence(%ContingencyTable{a_c: a_c, a_not_c: a_not_c}) do
    a_c / (a_c + a_not_c)
  end

  @spec compute_support(ContingencyTable.t()) :: float()
  defp compute_support(%ContingencyTable{a_c: a_c} = table) do
    a_c / compute_total(table)
  end

  @spec compute_lift(ContingencyTable.t()) :: float()
  defp compute_lift(%ContingencyTable{a_c: a_c, a_not_c: a_not_c, not_a_c: not_a_c} = table) do
    a_c / (a_c + a_not_c) / ((a_c + not_a_c) / compute_total(table))
  end

  @spec compute_total(ContingencyTable.t()) :: integer()
  defp compute_total(%ContingencyTable{
         a_c: a_c,
         a_not_c: a_not_c,
         not_a_c: not_a_c,
         not_a_not_c: not_a_not_c
       }) do
    a_c + a_not_c + not_a_c + not_a_not_c
  end

  @spec generate_contingency_table() :: ContingencyTable.t()
  defp generate_contingency_table() do
    %ContingencyTable{
      a_c: Enum.random(1..300),
      a_not_c: Enum.random(1..300),
      not_a_c: Enum.random(1..300),
      not_a_not_c: Enum.random(1..300)
    }
  end
end

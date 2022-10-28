defmodule Test4iz210Web.PageController do
  use Test4iz210Web, :controller

  import Test4iz210.AssociativeRules, only: [generate_associative_rule_question: 0]
  import Test4iz210.ConfusionMatrix, only: [generate_confusion_matrix_question: 0]
  import Test4iz210.Entropy, only: [generate_entropy_question: 0]
  import Test4iz210.EuclideanDistance, only: [generate_euclidean_distance_question: 0]

  def index(conn, _params) do
    conn
    |> assign(:associative_rules_question, generate_associative_rule_question())
    |> assign(:confusion_matrix_question, generate_confusion_matrix_question())
    |> assign(:entropy_question, generate_entropy_question())
    |> assign(:euclidean_distance_question, generate_euclidean_distance_question())
    |> render("index.html")
  end
end

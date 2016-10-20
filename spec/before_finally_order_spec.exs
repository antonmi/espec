defmodule BeforeFinallyOrderSpec do
  use ESpec

  before do
    expect(shared.answer).to eq(42)
    {:shared, answer: (shared.answer + 1)} # shared == %{anwser: 43}
  end

  finally do
    expect(shared.answer).to eq(45)
    {:shared, answer: (shared.answer + 1)} # shared == %{anwser: 46}
  end

  context do
    before do
      expect(shared.answer).to eq(43)
      {:shared, answer: shared.answer + 1} # shared == %{anwser: 44}
    end

    finally do
      expect(shared.answer).to eq(44)
      {:shared, answer: shared.answer + 1} # shared == %{anwser: 45}
    end

    it do: shared.answer |> should(eq 44)
  end
end

defmodule BeforeFinallyOrderSpec do
  use ESpec

  before do
    expect(shared.order_spec_answer).to eq(42) # defined in spec_helper.exs
    {:shared, order_spec_answer: (shared.order_spec_answer + 1)} # order_spec_answer is 43
  end

  finally do
    expect(shared.order_spec_answer).to eq(47)
    {:shared, order_spec_answer: (shared.order_spec_answer + 1)} # order_spec_answer is 48
  end

  context do
    before do
      expect(shared.order_spec_answer).to eq(43)
      {:shared, order_spec_answer: shared.order_spec_answer + 1} # order_spec_answer is 44
    end

    finally do
      expect(shared.order_spec_answer).to eq(46)
      {:shared, order_spec_answer: shared.order_spec_answer + 1} # order_spec_answer is 47
    end

    context do
      before do
        expect(shared.order_spec_answer).to eq(44)
        {:shared, order_spec_answer: shared.order_spec_answer + 1} # sorder_spec_answer is 45
      end

      finally do
        expect(shared.order_spec_answer).to eq(45)
        {:shared, order_spec_answer: shared.order_spec_answer + 1} # order_spec_answer is 46
      end

      it do: shared.order_spec_answer |> should(eq 45)
    end
  end
end

defmodule BeforeFinallyOrderSpec do
  use ESpec

  before do
    # defined in spec_helper.exs
    expect(shared.order_spec_answer) |> to(eq(42))
    # order_spec_answer is 43
    {:shared, order_spec_answer: shared.order_spec_answer + 1}
  end

  finally do
    expect(shared.order_spec_answer) |> to(eq(47))
    # order_spec_answer is 48
    {:shared, order_spec_answer: shared.order_spec_answer + 1}
  end

  context do
    before do
      expect(shared.order_spec_answer) |> to(eq(43))
      # order_spec_answer is 44
      {:shared, order_spec_answer: shared.order_spec_answer + 1}
    end

    finally do
      expect(shared.order_spec_answer) |> to(eq(46))
      # order_spec_answer is 47
      {:shared, order_spec_answer: shared.order_spec_answer + 1}
    end

    context do
      before do
        expect(shared.order_spec_answer) |> to(eq(44))
        # sorder_spec_answer is 45
        {:shared, order_spec_answer: shared.order_spec_answer + 1}
      end

      finally do
        expect(shared.order_spec_answer) |> to(eq(45))
        # order_spec_answer is 46
        {:shared, order_spec_answer: shared.order_spec_answer + 1}
      end

      it do: shared.order_spec_answer |> should(eq 45)
    end
  end
end

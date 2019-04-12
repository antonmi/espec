defmodule Regression.IncorrectSharedValuesInBeforeSpec do
  use ESpec, option: true

  before do: send(self(), {:option, shared[:option]})

  it "option should be true" do
    assert_receive {:option, true}
  end

  it "option should be false", option: false do
    assert_receive {:option, false}
  end
end

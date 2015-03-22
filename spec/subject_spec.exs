defmodule SubjectSpec do
  use ESpec

  subject do: 10

  it do: IO.puts subject

  context "new subject" do

    subject do: 20

    it do: IO.puts subject

  end
end

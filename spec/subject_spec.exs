defmodule SubjectSpec do
  use ESpec

  subject do: 10

  it do: expect(subject).to eq(10)

  context "new subject" do

    subject do: 20

    it do: expect(subject).to eq(20)

  end

  subject do: 30

  it do: expect(subject).to eq(30)




end

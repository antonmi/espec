defmodule SubjectSpec do
  use ESpec, async: true

  subject(1 + 1)

  it do: expect(subject).to eq(2)

  it do: is_expected.to eq(2)
  it do: should eq(2)

  it do: is_expected.to_not eq(1)
  it do: should_not eq(1)

  context "without name" do
    subject!(5 + 5)

    it do: is_expected.to eq(10)

    context "new subject" do
      subject(List.last([1, 20]))

      it do: is_expected.to eq(20)
      it do: should eq(20)
    end

    subject(15 + 15)
    it do: is_expected.to eq(30)
  end

  context "with name" do
    subject :subj, do: 2 + 5
    it do: expect(subj).to eq(7)

    context "redefine" do
      subject :subj, do: 3 + 5
      it do: expect(subj).to eq(8)
      it do: subj |> should(eq 8)
      it do: subj |> should_not(eq 10)
    end
  end
end

defmodule SubjectSpec do
  use ESpec

  context "without name" do
    subject(10)

    it do: is_expected.to eq(10)

    context "new subject" do

      subject(20)

      it do: is_expected.to eq(20)

    end

    subject(30)

    it do: is_expected.to eq(30)
  end

  context "with name" do
    subject :subj, do: 25
    it do: expect(subj).to eq(25)

    context "redefine" do
      subject :subj, do: 35
      it do: expect(subj).to eq(35)
    end
  end



end

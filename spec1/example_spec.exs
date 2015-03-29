defmodule ExampleSpec do
 
 use ESpec
 
 before do
   answer = Enum.reduce((1..9), &(&2 + &1)) - 3
   {:ok, answer: answer} #saves {:key, :value} to `__`
 end

 example "test" do
   expect(__.answer).to eq(42)
 end

 context "Defines context" do
   subject(__.answer)
   
   it do: is_expected.to be_between(41, 43)
   
   describe "is an alias for context" do
     before do
       value = __.answer * 2
       {:ok, new_answer: value}
     end

     let :val, do: __.new_answer

     it "checks val" do
       expect(val).to eq(84)
     end  
   end
 end

 xcontext "xcontext skips examples." do
   xit "And xit also skips" do
     "skipped"
   end
 end

 pending "There are so many features to test!"
end 

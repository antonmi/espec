defmodule ESpec.Assertions.BeCloseToSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.BeCloseTo" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(5).to be_close_to(4, 1)
        expect(message) |> to(eq "`5` is close to `4` with delta `1`.")
      end

      it "checks success with `not_to`" do
        message = expect(2).to_not be_close_to(5, 1)
        expect(message) |> to(eq "`2` is not close to `5` with delta `1`.")
      end

      it do: expect(5).to be_close_to(6, 1)
      it do: expect(5.5).to be_close_to(5.3, 0.21)
    end

    context "Success with Date with a granularity of years" do
      it "checks success with `to`" do
        message = expect(~D[2017-08-07]).to be_close_to(~D[2018-08-07], {:years, 1})
        expect(message) |> to(eq "`~D[2017-08-07]` is close to `~D[2018-08-07]` with delta `{:years, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-08-07]).to_not be_close_to(~D[2020-08-07], {:years, 2})
        expect(message) |> to(eq "`~D[2017-08-07]` is not close to `~D[2020-08-07]` with delta `{:years, 2}`.")
      end

      it do: expect(~D[2017-08-07]).to be_close_to(~D[2020-08-07], {:years, 3})
    end

    context "Success with Date with a granularity of months" do
      it "checks success with `to`" do
        message = expect(~D[2017-08-07]).to be_close_to(~D[2017-09-07], {:months, 1})
        expect(message) |> to(eq "`~D[2017-08-07]` is close to `~D[2017-09-07]` with delta `{:months, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-08-07]).to_not be_close_to(~D[2020-08-07], {:months, 2})
        expect(message) |> to(eq "`~D[2017-08-07]` is not close to `~D[2020-08-07]` with delta `{:months, 2}`.")
      end

      it do: expect(~D[2017-08-07]).to be_close_to(~D[2017-01-07], {:months, 7})
    end

    context "Success with Date with a granularity of weeks" do
      it "checks success with `to`" do
        message = expect(~D[2017-08-07]).to be_close_to(~D[2017-08-14], {:weeks, 1})
        expect(message) |> to(eq "`~D[2017-08-07]` is close to `~D[2017-08-14]` with delta `{:weeks, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-08-07]).to_not be_close_to(~D[2020-08-07], {:weeks, 2})
        expect(message) |> to(eq "`~D[2017-08-07]` is not close to `~D[2020-08-07]` with delta `{:weeks, 2}`.")
      end

      it do: expect(~D[2017-08-07]).to be_close_to(~D[2017-08-14], {:weeks, 1})
    end

    context "Success with Date with a granularity of days" do
      it "checks success with `to`" do
        message = expect(~D[2017-08-07]).to be_close_to(~D[2017-08-06], {:days, 1})
        expect(message) |> to(eq "`~D[2017-08-07]` is close to `~D[2017-08-06]` with delta `{:days, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-08-07]).to_not be_close_to(~D[2017-08-19], {:days, 1})
        expect(message) |> to(eq "`~D[2017-08-07]` is not close to `~D[2017-08-19]` with delta `{:days, 1}`.")
      end

      it do: expect(~D[2017-08-07]).to be_close_to(~D[2017-10-07], {:days, 61})
    end

    context "Success with NaiveDateTime with a granularity of years" do
      it "checks success with `to`" do
        message = expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2018-08-07 01:10:10], {:years, 1})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is close to `~N[2018-08-07 01:10:10]` with delta `{:years, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-08-07 01:10:10]).to_not be_close_to(~N[2020-08-07 01:10:10], {:years, 2})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is not close to `~N[2020-08-07 01:10:10]` with delta `{:years, 2}`.")
      end

      it do: expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2020-08-07 01:10:10], {:years, 3})
    end

    context "Success with NaiveDateTime with a granularity of months" do
      it "checks success with `to`" do
        message = expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-09-07 01:10:10], {:months, 1})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is close to `~N[2017-09-07 01:10:10]` with delta `{:months, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-08-07 01:10:10]).to_not be_close_to(~N[2020-08-07 01:10:10], {:months, 2})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is not close to `~N[2020-08-07 01:10:10]` with delta `{:months, 2}`.")
      end

      it do: expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-01-07 01:10:10], {:months, 7})
    end

    context "Success with NaiveDateTime with a granularity of weeks" do
      it "checks success with `to`" do
        message = expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-08-14 01:10:10], {:weeks, 1})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is close to `~N[2017-08-14 01:10:10]` with delta `{:weeks, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-08-07 01:10:10]).to_not be_close_to(~N[2020-08-07 01:10:10], {:weeks, 2})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is not close to `~N[2020-08-07 01:10:10]` with delta `{:weeks, 2}`.")
      end

      it do: expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-08-14 01:10:10], {:weeks, 1})
    end

    context "Success with NaiveDateTime with a granularity of days" do
      it "checks success with `to`" do
        message = expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-08-06 01:10:10], {:days, 1})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is close to `~N[2017-08-06 01:10:10]` with delta `{:days, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-08-07 01:10:10]).to_not be_close_to(~N[2017-08-19 01:10:10], {:days, 1})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is not close to `~N[2017-08-19 01:10:10]` with delta `{:days, 1}`.")
      end

      it do: expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-10-07 01:10:10], {:days, 61})
    end

    context "Success with NaiveDateTime with a granularity of hours" do
      it "checks success with `to`" do
        message = expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-08-07 02:10:10], {:hours, 1})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is close to `~N[2017-08-07 02:10:10]` with delta `{:hours, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-08-07 01:10:10]).to_not be_close_to(~N[2017-08-19 01:10:10], {:hours, 1})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is not close to `~N[2017-08-19 01:10:10]` with delta `{:hours, 1}`.")
      end

      it do: expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-08-07 02:10:10], {:hours, 1})
    end

    context "Success with NaiveDateTime with a granularity of minutes" do
      it "checks success with `to`" do
        message = expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-08-07 01:50:10], {:minutes, 40})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is close to `~N[2017-08-07 01:50:10]` with delta `{:minutes, 40}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-08-07 01:10:10]).to_not be_close_to(~N[2017-08-07 01:51:10], {:minutes, 40})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is not close to `~N[2017-08-07 01:51:10]` with delta `{:minutes, 40}`.")
      end

      it do: expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-08-07 01:50:10], {:minutes, 40})
    end

    context "Success with NaiveDateTime with a granularity of seconds" do
      it "checks success with `to`" do
        message = expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-08-07 01:10:11], {:seconds, 1})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is close to `~N[2017-08-07 01:10:11]` with delta `{:seconds, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-08-07 01:10:10]).to_not be_close_to(~N[2017-08-07 01:10:12], {:seconds, 1})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10]` is not close to `~N[2017-08-07 01:10:12]` with delta `{:seconds, 1}`.")
      end

      it do: expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-08-07 01:10:11], {:seconds, 1})
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(2).to be_close_to(1, 0.9) end,
            message: "Expected `2` to be close to `1` with delta `0.9`, but it isn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(3).to_not be_close_to(3, 0) end,
            message: "Expected `3` not to be close to `3` with delta `0`, but it is."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end

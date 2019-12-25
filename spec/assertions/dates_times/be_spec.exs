defmodule ESpec.Assertions.DatesTimes.BeSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Be, without specified granularity" do
    context "Success with Date" do
      it "checks success with `to`" do
        message = expect(~D[2017-08-07]) |> to(be :<=, ~D[2018-08-07])
        expect(message) |> to(eq "`~D[2017-08-07] <= ~D[2018-08-07]` is true.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-08-07]) |> to_not(be :>, ~D[2020-08-07])
        expect(message) |> to(eq "`~D[2017-08-07] > ~D[2020-08-07]` is false.")
      end

      it do: expect(~D[2020-08-07]) |> to(be :>=, ~D[2017-08-07])
    end

    context "Errors with Date" do
      context "with `to`" do
        before do
          {:shared,
           expectation: fn -> expect(~D[2017-08-07]) |> to(be :<, ~D[2050-08-19]) end,
           message: "Expected `~D[2017-08-07] < ~D[2050-08-19]` to be `true` but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn -> expect(~D[2017-08-07]) |> to_not(be :>, ~D[2017-10-07]) end,
           message: "Expected `~D[2017-08-07] < ~D[2017-10-07]` to be `true`  but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end

    context "Success with NaiveDateTime" do
      it "checks success with `to`" do
        message = expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-09-07 01:10:10])
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10] <= ~N[2017-09-07 01:10:10]` is true.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-08-07 01:10:10]) |> to_not(be :>, ~N[2020-08-07 01:10:10])
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10] > ~N[2020-08-07 01:10:10]` is false.")
      end

      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :>=, ~N[2017-01-07 01:10:10])
    end

    context "Errors with NaiveDateTime" do
      context "with `to`" do
        before do
          {:shared,
           expectation: fn ->
             expect(~N[2017-08-07 01:10:10]) |> to(be :<, ~N[2017-08-07 01:10:15])
           end,
           message:
             "Expected `~N[2017-08-07 01:10:10] < ~N[2017-08-07 01:10:15]` to be `true` but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn ->
             expect(~N[2017-08-07 01:10:10]) |> to_not(be :>, ~N[2017-08-07 01:10:15])
           end,
           message:
             "Expected `~N[2017-08-07 01:10:10] > ~N[2017-08-07 01:10:15]` to be `true` but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end

    context "Success with DateTime" do
      let :datetime1,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000001], "Etc/UTC")

      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000003], "Etc/UTC")

      it "checks success with `to`" do
        message = expect(datetime1()) |> to(be :<=, datetime2())
        expect(message) |> to(eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true.")
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()) |> to_not(be :>, datetime2())
        expect(message) |> to(eq "`#{inspect(datetime1())} > #{inspect(datetime2())}` is false.")
      end

      it do: expect(datetime1()) |> to(be :<=, datetime2())
    end

    context "Errors with DateTime" do
      let :datetime1,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000001], "Etc/UTC")

      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000006], "Etc/UTC")

      context "with `to`" do
        before do
          {:shared,
           expectation: fn -> expect(datetime1()) |> to(be :<, datetime2()) end,
           message:
             "Expected `#{inspect(datetime1())} < #{inspect(datetime2())}` to be `true` but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn -> expect(datetime1()) |> to_not(be :<, datetime2()) end,
           message:
             "Expected `#{inspect(datetime1())} < #{inspect(datetime2())}` to be `false` but got `true`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end

  # without granularity

  describe "ESpec.Assertions.Be, with specified granularity" do
    context "Success with Date with a granularity of year" do
      it "checks success with `to` for granularity specified by tuple" do
        message = expect(~D[2017-08-07]) |> to(be :<=, ~D[2018-08-07], {:year, 1})

        expect(message)
        |> to(eq "`~D[2017-08-07] <= ~D[2018-08-07]` is true with delta `{:year, 1}`.")
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~D[2017-08-07]) |> to(be :<=, ~D[2018-08-07], year: 1)

        expect(message)
        |> to(eq "`~D[2017-08-07] <= ~D[2018-08-07]` is true with delta `[year: 1]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-08-07]) |> to_not(be :<, ~D[2020-08-07], {:year, 2})

        expect(message)
        |> to(eq "`~D[2017-08-07] < ~D[2020-08-07]` is false with delta `{:year, 2}`.")
      end

      it do: expect(~D[2020-08-07]) |> to(be :>=, ~D[2017-08-07], {:year, 3})
    end

    context "Success with Date with a granularity of month" do
      it "checks success with `to` for granularity specified by tuple" do
        message = expect(~D[2017-10-07]) |> to(be :>=, ~D[2017-08-07], {:month, 2})

        expect(message)
        |> to(eq "`~D[2017-10-07] >= ~D[2017-08-07]` is true with delta `{:month, 2}`.")
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~D[2017-10-07]) |> to(be :>=, ~D[2017-08-07], month: 2)

        expect(message)
        |> to(eq "`~D[2017-10-07] >= ~D[2017-08-07]` is true with delta `[month: 2]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2020-08-07]) |> to_not(be :>, ~D[2017-08-07], {:month, 36})

        expect(message)
        |> to(eq "`~D[2020-08-07] > ~D[2017-08-07]` is false with delta `{:month, 36}`.")
      end

      it do: expect(~D[2017-08-07]) |> to(be :>=, ~D[2017-01-07], {:month, 7})
    end

    context "Success with Date with a granularity of week" do
      it "checks success with `to` for granularity specified by tuple" do
        message = expect(~D[2017-08-07]) |> to(be :<, ~D[2017-08-20], {:week, 2})

        expect(message)
        |> to(eq "`~D[2017-08-07] < ~D[2017-08-20]` is true with delta `{:week, 2}`.")
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~D[2017-08-07]) |> to(be :<, ~D[2017-08-20], week: 2)

        expect(message)
        |> to(eq "`~D[2017-08-07] < ~D[2017-08-20]` is true with delta `[week: 2]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-08-07]) |> to_not(be :<, ~D[2020-08-07], {:week, 156})

        expect(message)
        |> to(eq "`~D[2017-08-07] < ~D[2020-08-07]` is false with delta `{:week, 156}`.")
      end

      it do: expect(~D[2017-08-14]) |> to(be :>=, ~D[2017-08-07], {:week, 1})
    end

    context "Success with Date with a granularity of day" do
      it "checks success with `to` for granularity specified by tuple" do
        message = expect(~D[2017-08-07]) |> to(be :>=, ~D[2017-08-06], {:day, 1})

        expect(message)
        |> to(eq "`~D[2017-08-07] >= ~D[2017-08-06]` is true with delta `{:day, 1}`.")
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~D[2017-08-07]) |> to(be :>=, ~D[2017-08-06], day: 1)

        expect(message)
        |> to(eq "`~D[2017-08-07] >= ~D[2017-08-06]` is true with delta `[day: 1]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-08-07]) |> to_not(be :<, ~D[2017-08-19], {:day, 1})

        expect(message)
        |> to(eq "`~D[2017-08-07] < ~D[2017-08-19]` is false with delta `{:day, 1}`.")
      end

      it do: expect(~D[2017-08-07]) |> to(be :<=, ~D[2017-10-07], {:day, 61})
    end

    context "Errors with Date" do
      context "with `to`" do
        before do
          {:shared,
           expectation: fn -> expect(~D[2017-08-07]) |> to(be :<, ~D[2050-08-19], {:year, 3}) end,
           message:
             "Expected `~D[2017-08-07] < ~D[2050-08-19]` to be `true` but got `false` with delta `{:year, 3}`. The actual delta is {:year, 33}, with an inclusive boundary."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn ->
             expect(~D[2017-08-07]) |> to_not(be :<, ~D[2017-10-07], {:month, 1})
           end,
           message:
             "Expected `~D[2017-08-07] < ~D[2017-10-07]` to be `true`  but got `false` with delta `{:month, 1}`, but it is. The actual delta is {:month, 2}, with an inclusive boundary."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end

    context "Success with NaiveDateTime with a granularity of year" do
      it "checks success with `to` for granularity specified by tuple" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2018-08-07 01:10:10], {:year, 1})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2018-08-07 01:10:10]` is true with delta `{:year, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2018-08-07 01:10:10], year: 1)

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2018-08-07 01:10:10]` is true with delta `[year: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2020-08-07 01:10:10], {:year, 2})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] < ~N[2020-08-07 01:10:10]` is false with delta `{:year, 2}`."
        )
      end

      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2020-08-07 01:10:10], {:year, 3})
    end

    context "Success with NaiveDateTime with a granularity of month" do
      it "checks success with `to` for granularity specified by tuple" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-09-07 01:10:10], {:month, 1})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2017-09-07 01:10:10]` is true with delta `{:month, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-09-07 01:10:10], month: 1)

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2017-09-07 01:10:10]` is true with delta `[month: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2020-08-07 01:10:10], {:month, 2})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] < ~N[2020-08-07 01:10:10]` is false with delta `{:month, 2}`."
        )
      end

      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :>=, ~N[2017-01-07 01:10:10], {:month, 7})
    end

    context "Success with NaiveDateTime with a granularity of week" do
      it "checks success with `to` for granularity specified by tuple" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-14 01:10:10], {:week, 1})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2017-08-14 01:10:10]` is true with delta `{:week, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-14 01:10:10], week: 1)

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2017-08-14 01:10:10]` is true with delta `[week: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2020-08-07 01:10:10], {:week, 2})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] < ~N[2020-08-07 01:10:10]` is false with delta `{:week, 2}`."
        )
      end

      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-14 01:10:10], {:week, 1})
    end

    context "Success with NaiveDateTime with a granularity of day" do
      it "checks success with `to` for granularity specified by tuple" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to(be :>=, ~N[2017-08-06 01:10:10], {:day, 1})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] >= ~N[2017-08-06 01:10:10]` is true with delta `{:day, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~N[2017-08-07 01:10:10]) |> to(be :>=, ~N[2017-08-06 01:10:10], day: 1)

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] >= ~N[2017-08-06 01:10:10]` is true with delta `[day: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message =
          expect(~N[2017-08-19 01:10:10]) |> to_not(be :>, ~N[2017-08-07 01:10:10], {:day, 13})

        expect(message)
        |> to(
          eq "`~N[2017-08-19 01:10:10] > ~N[2017-08-07 01:10:10]` is false with delta `{:day, 13}`."
        )
      end

      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-10-07 01:10:10], {:day, 61})
    end

    context "Success with NaiveDateTime with a granularity of hour" do
      it "checks success with `to` for granuarlity specifed by tuple" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 02:10:10], {:hour, 1})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2017-08-07 02:10:10]` is true with delta `{:hour, 1}`."
        )
      end

      it "checks success with `to` for granularity specifed by single element Keyword list" do
        message = expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 02:10:10], hour: 1)

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2017-08-07 02:10:10]` is true with delta `[hour: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2017-08-19 01:10:10], {:hour, 1})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] < ~N[2017-08-19 01:10:10]` is false with delta `{:hour, 1}`."
        )
      end

      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 02:10:10], {:hour, 1})
    end

    context "Success with NaiveDateTime with a granularity of minute" do
      it "checks success with `to` for granularity specified by tuple" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 01:50:10], {:minute, 40})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2017-08-07 01:50:10]` is true with delta `{:minute, 40}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 01:50:10], minute: 40)

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2017-08-07 01:50:10]` is true with delta `[minute: 40]`."
        )
      end

      it "checks success with `not_to`" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2017-08-07 01:51:10], {:minute, 40})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] < ~N[2017-08-07 01:51:10]` is false with delta `{:minute, 40}`."
        )
      end

      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 01:50:10], {:minute, 40})
    end

    context "Success with NaiveDateTime with a granularity of second" do
      it "checks success with `to` for granularity specified by tuple" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 01:10:11], {:second, 1})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2017-08-07 01:10:11]` is true with delta `{:second, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 01:10:11], second: 1)

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] <= ~N[2017-08-07 01:10:11]` is true with delta `[second: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message =
          expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2017-08-07 01:10:12], {:second, 1})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10] < ~N[2017-08-07 01:10:12]` is false with delta `{:second, 1}`."
        )
      end

      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 01:10:11], {:second, 1})
    end

    context "Success with NaiveDateTime with a granularity of microsecond" do
      it "checks success with `to` for granularity specified by tuple" do
        message =
          expect(~N[2017-08-07 01:10:10.000001])
          |> to(be :<=, ~N[2017-08-07 01:10:10.000003], {:microsecond, 2})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10.000001] <= ~N[2017-08-07 01:10:10.000003]` is true with delta `{:microsecond, 2}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message =
          expect(~N[2017-08-07 01:10:10.000001])
          |> to(be :<=, ~N[2017-08-07 01:10:10.000003], microsecond: 2)

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10.000001] <= ~N[2017-08-07 01:10:10.000003]` is true with delta `[microsecond: 2]`."
        )
      end

      it "checks success with `not_to`" do
        message =
          expect(~N[2017-08-07 01:10:10.000001])
          |> to_not(be :<, ~N[2017-08-07 01:10:10.000003], {:microsecond, 1})

        expect(message)
        |> to(
          eq "`~N[2017-08-07 01:10:10.000001] < ~N[2017-08-07 01:10:10.000003]` is false with delta `{:microsecond, 1}`."
        )
      end

      it do:
           expect(~N[2017-08-07 01:10:10.000001])
           |> to(be :<=, ~N[2017-08-07 01:10:10.000003], {:microsecond, 2})
    end

    context "Errors with NaiveDateTime" do
      context "with `to`" do
        before do
          {:shared,
           expectation: fn ->
             expect(~N[2017-08-07 01:10:10]) |> to(be :<, ~N[2017-08-07 01:10:15], {:second, 3})
           end,
           message:
             "Expected `~N[2017-08-07 01:10:10] < ~N[2017-08-07 01:10:15]` to be `true` but got `false` with delta `{:second, 3}`. The actual delta is {:second, 5}, with an inclusive boundary."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn ->
             expect(~N[2017-08-07 01:10:10])
             |> to_not(be :<, ~N[2017-08-07 01:10:15], {:second, 5})
           end,
           message:
             "Expected `~N[2017-08-07 01:10:10] < ~N[2017-08-07 01:10:15]` to be `true` but got `false`  with delta `{:second, 5}`. The actual delta is {:second, 5}, with an inclusive boundary."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end

    context "Success with Time with a granularity of hour" do
      it "checks success with `to` for granularity specified by tuple" do
        message = expect(~T[01:10:10]) |> to(be :<=, ~T[02:10:10], {:hour, 1})

        expect(message)
        |> to(eq "`~T[01:10:10] <= ~T[02:10:10]` is true with delta `{:hour, 1}`.")
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~T[01:10:10]) |> to(be :<=, ~T[02:10:10], hour: 1)

        expect(message)
        |> to(eq "`~T[01:10:10] <= ~T[02:10:10]` is true with delta `[hour: 1]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~T[01:10:10]) |> to_not(be :<, ~T[03:10:10], {:hour, 1})

        expect(message)
        |> to(eq "`~T[01:10:10] < ~T[03:10:10]` is false with delta `{:hour, 1}`.")
      end

      it do: expect(~T[01:10:10]) |> to(be :<=, ~T[02:10:10], {:hour, 1})
    end

    context "Success with Time with a granularity of minute" do
      it "checks success with `to` for granularity specified by tuple" do
        message = expect(~T[01:10:10]) |> to(be :<=, ~T[01:50:10], {:minute, 40})

        expect(message)
        |> to(eq "`~T[01:10:10] <= ~T[01:50:10]` is true with delta `{:minute, 40}`.")
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~T[01:10:10]) |> to(be :<=, ~T[01:50:10], minute: 40)

        expect(message)
        |> to(eq "`~T[01:10:10] <= ~T[01:50:10]` is true with delta `[minute: 40]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~T[01:10:10]) |> to_not(be :<, ~T[01:50:10], {:minute, 40})

        expect(message)
        |> to(eq "`~T[01:10:10] < ~T[01:50:10]` is false with delta `{:minute, 40}`.")
      end

      it do: expect(~T[01:10:10]) |> to(be :<=, ~T[01:50:10], {:minute, 40})
    end

    context "Success with Time with a granularity of second" do
      it "checks success with `to` for granularity specified by tuple" do
        message = expect(~T[01:10:10]) |> to(be :<=, ~T[01:10:11], {:second, 1})

        expect(message)
        |> to(eq "`~T[01:10:10] <= ~T[01:10:11]` is true with delta `{:second, 1}`.")
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~T[01:10:10]) |> to(be :<=, ~T[01:10:11], second: 1)

        expect(message)
        |> to(eq "`~T[01:10:10] <= ~T[01:10:11]` is true with delta `[second: 1]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~T[01:10:10]) |> to_not(be :<, ~T[01:10:12], {:second, 1})

        expect(message)
        |> to(eq "`~T[01:10:10] < ~T[01:10:12]` is false with delta `{:second, 1}`.")
      end

      it do: expect(~T[01:10:10]) |> to(be :<=, ~T[01:10:11], {:second, 1})
    end

    context "Success with Time with a granularity of microsecond" do
      it "checks success with `to` for granularity specified by tuple" do
        message =
          expect(~T[01:10:10.000001]) |> to(be :<=, ~T[01:10:10.000002], {:microsecond, 1})

        expect(message)
        |> to(
          eq "`~T[01:10:10.000001] <= ~T[01:10:10.000002]` is true with delta `{:microsecond, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(~T[01:10:10.000001]) |> to(be :<=, ~T[01:10:10.000002], microsecond: 1)

        expect(message)
        |> to(
          eq "`~T[01:10:10.000001] <= ~T[01:10:10.000002]` is true with delta `[microsecond: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message =
          expect(~T[01:10:10.000001]) |> to_not(be :<, ~T[01:10:11.000002], {:microsecond, 1})

        expect(message)
        |> to(
          eq "`~T[01:10:10.000001] < ~T[01:10:11.000002]` is false with delta `{:microsecond, 1}`."
        )
      end

      it do: expect(~T[01:10:10.000001]) |> to(be :<=, ~T[01:10:10.000002], {:microsecond, 1})
    end

    context "Errors with Time" do
      context "with `to`" do
        before do
          {:shared,
           expectation: fn ->
             expect(~T[01:10:10.000001]) |> to(be :<, ~T[01:10:10.000006], {:microsecond, 3})
           end,
           message:
             "Expected `~T[01:10:10.000001] < ~T[01:10:10.000006]` to be `true` but got `false` with delta `{:microsecond, 3}`. The actual delta is {:microsecond, 5}, with an inclusive boundary."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn ->
             expect(~T[01:10:10.000001]) |> to_not(be :<, ~T[01:10:10.000006], {:microsecond, 5})
           end,
           message:
             "Expected `~T[01:10:10.000001] < ~T[01:10:10.000006]` to be `true` but got `false` with delta `{:microsecond, 5}`. The actual delta is {:microsecond, 5}, with an inclusive boundary."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end

    let :datetime1, do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000001], "Etc/UTC")
    let :datetime3, do: DateTime.Extension.from_naive!(~N[2020-08-07 01:10:10.000001], "Etc/UTC")

    context "Success with DateTime with a granularity of year" do
      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2018-08-07 01:10:10.000001], "Etc/UTC")

      it "checks success with `to` for granularity specified by tuple" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), {:year, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `{:year, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), year: 1)

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `[year: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()) |> to_not(be :<, datetime3(), {:year, 2})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} < #{inspect(datetime3())}` is false with delta `{:year, 2}`."
        )
      end

      it do: expect(datetime1()) |> to(be :<=, datetime3(), {:year, 3})
    end

    context "Success with DateTime with a granularity of month" do
      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-09-07 01:10:10.000001], "Etc/UTC")

      it "checks success with `to` for granularity specified by tuple" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), {:month, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `{:month, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), month: 1)

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `[month: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()) |> to_not(be :<, datetime3(), {:month, 2})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} < #{inspect(datetime3())}` is false with delta `{:month, 2}`."
        )
      end

      it do: expect(datetime1()) |> to(be :<=, datetime2(), {:month, 1})
    end

    context "Success with DateTime with a granularity of week" do
      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-14 01:10:10.000001], "Etc/UTC")

      it "checks success with `to` for granularity specified by tuple" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), {:week, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `{:week, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), week: 1)

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `[week: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()) |> to_not(be :<, datetime3(), {:week, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} < #{inspect(datetime3())}` is false with delta `{:week, 1}`."
        )
      end

      it do: expect(datetime1()) |> to(be :<=, datetime2(), {:week, 1})
    end

    context "Success with DateTime with a granularity of day" do
      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-06 01:10:10.000001], "Etc/UTC")

      let :datetime4,
        do: DateTime.Extension.from_naive!(~N[2017-10-07 01:10:10.000001], "Etc/UTC")

      it "checks success with `to` for granularity specified by tuple" do
        message = expect(datetime1()) |> to(be :>=, datetime2(), {:day, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} >= #{inspect(datetime2())}` is true with delta `{:day, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(datetime1()) |> to(be :>=, datetime2(), day: 1)

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} >= #{inspect(datetime2())}` is true with delta `[day: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()) |> to_not(be :<, datetime3(), {:day, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} < #{inspect(datetime3())}` is false with delta `{:day, 1}`."
        )
      end

      it do: expect(datetime1()) |> to(be :<=, datetime4(), {:day, 61})
    end

    context "Success with DateTime with a granularity of hour" do
      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 02:10:10.000001], "Etc/UTC")

      it "checks success with `to` for granularity specified by tuple" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), {:hour, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `{:hour, 1}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), hour: 1)

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `[hour: 1]`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()) |> to_not(be :<, datetime3(), {:hour, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} < #{inspect(datetime3())}` is false with delta `{:hour, 1}`."
        )
      end

      it do: expect(datetime1()) |> to(be :<=, datetime2(), {:hour, 1})
    end

    context "Success with DateTime with a granularity of minute" do
      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:50:10.000001], "Etc/UTC")

      it "checks success with `to` for granularity specified by tuple" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), {:minute, 40})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `{:minute, 40}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), minute: 40)

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `[minute: 40]`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()) |> to_not(be :<, datetime2(), {:minute, 40})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} < #{inspect(datetime2())}` is false with delta `{:minute, 40}`."
        )
      end

      it do: expect(datetime1()) |> to(be :<=, datetime2(), {:minute, 40})
    end

    context "Success with DateTime with a granularity of second" do
      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000001], "Etc/UTC")

      it "checks success with `to` for granularity specified by tuple" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), {:second, 2})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `{:second, 2}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), second: 2)

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `[second: 2]`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()) |> to_not(be :<, datetime2(), {:second, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} < #{inspect(datetime2())}` is false with delta `{:second, 1}`."
        )
      end

      it do: expect(datetime1()) |> to(be :<=, datetime2(), {:second, 2})
    end

    context "Success with DateTime with a granularity of microsecond" do
      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000003], "Etc/UTC")

      it "checks success with `to` for granularity specified by tuple" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), {:microsecond, 2})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `{:microsecond, 2}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(datetime1()) |> to(be :<=, datetime2(), microsecond: 2)

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} <= #{inspect(datetime2())}` is true with delta `[microsecond: 2]`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()) |> to_not(be :<, datetime2(), {:microsecond, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime1())} < #{inspect(datetime2())}` is false with delta `{:microsecond, 1}`."
        )
      end

      it do: expect(datetime1()) |> to(be :<=, datetime2(), {:microsecond, 2})
    end

    context "Success with DateTime with utc and std offsets to represent time zone differences" do
      let :datetime_pst,
        do: %DateTime{
          year: 2017,
          month: 3,
          day: 15,
          hour: 1,
          minute: 30,
          second: 30,
          microsecond: {1, 6},
          std_offset: 1 * 3600,
          utc_offset: -8 * 3600,
          zone_abbr: "PST",
          time_zone: "America/Los_Angeles"
        }

      let :datetime_est,
        do: %DateTime{
          year: 2017,
          month: 3,
          day: 15,
          hour: 6,
          minute: 30,
          second: 30,
          microsecond: {1, 6},
          std_offset: 1 * 3600,
          utc_offset: -5 * 3600,
          zone_abbr: "EST",
          time_zone: "America/New_York"
        }

      it "checks success with `to` for granularity specified by tuple" do
        message = expect(datetime_pst()) |> to(be :<=, datetime_est(), {:hour, 2})

        expect(message)
        |> to(
          eq "`#{inspect(datetime_pst())} <= #{inspect(datetime_est())}` is true with delta `{:hour, 2}`."
        )
      end

      it "checks success with `to` for granularity specified by single element Keyword list" do
        message = expect(datetime_pst()) |> to(be :<=, datetime_est(), hour: 2)

        expect(message)
        |> to(
          eq "`#{inspect(datetime_pst())} <= #{inspect(datetime_est())}` is true with delta `[hour: 2]`."
        )
      end

      it "checks success with `not_to`" do
        message = expect(datetime_pst()) |> to_not(be :<, datetime_est(), {:hour, 1})

        expect(message)
        |> to(
          eq "`#{inspect(datetime_pst())} < #{inspect(datetime_est())}` is false with delta `{:hour, 1}`."
        )
      end

      it do: expect(datetime_pst()) |> to(be :<=, datetime_est(), {:hour, 2})
    end

    context "Errors with DateTime" do
      context "with `to`" do
        let :datetime1,
          do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000001], "Etc/UTC")

        let :datetime2,
          do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000006], "Etc/UTC")

        before do
          {:shared,
           expectation: fn -> expect(datetime1()) |> to(be :<, datetime2(), {:microsecond, 3}) end,
           message:
             "Expected `#{inspect(datetime1())} < #{inspect(datetime2())}` to be `true` but got `false` with delta `{:microsecond, 3}`. The actual delta is {:microsecond, 5}, with an inclusive boundary."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        let :datetime1,
          do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000001], "Etc/UTC")

        let :datetime2,
          do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000006], "Etc/UTC")

        before do
          {:shared,
           expectation: fn ->
             expect(datetime1()) |> to_not(be :<, datetime2(), {:microsecond, 5})
           end,
           message:
             "Expected `#{inspect(datetime1())} < #{inspect(datetime2())}` to be `true` but got `false` with delta `{:microsecond, 5}`. The actual delta is {:microsecond, 5}."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end

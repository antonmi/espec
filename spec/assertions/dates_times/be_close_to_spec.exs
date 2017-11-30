defmodule ESpec.Assertions.DatesTimes.BeCloseToSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.BeCloseTo" do
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

    context "Errors with Date" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(~D[2017-08-07]).to be_close_to(~D[2050-08-19], {:years, 3}) end,
            message: "Expected `~D[2017-08-07]` to be close to `~D[2050-08-19]` with delta `{:years, 3}`, but it isn't. The actual delta is {:years, 33}."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(~D[2017-08-07]).to_not be_close_to(~D[2017-10-07], {:months, 1}) end,
            message: "Expected `~D[2017-08-07]` not to be close to `~D[2017-10-07]` with delta `{:months, 1}`, but it is. The actual delta is {:months, 2}"}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
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

    context "Success with NaiveDateTime with a granularity of microseconds" do
      it "checks success with `to`" do
        message = expect(~N[2017-08-07 01:10:10.000001]).to be_close_to(~N[2017-08-07 01:10:10.000003], {:microseconds, 2})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10.000001]` is close to `~N[2017-08-07 01:10:10.000003]` with delta `{:microseconds, 2}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-08-07 01:10:10.000001]).to_not be_close_to(~N[2017-08-07 01:10:10.000003], {:microseconds, 1})
        expect(message) |> to(eq "`~N[2017-08-07 01:10:10.000001]` is not close to `~N[2017-08-07 01:10:10.000003]` with delta `{:microseconds, 1}`.")
      end

      it do: expect(~N[2017-08-07 01:10:10.000001]).to be_close_to(~N[2017-08-07 01:10:10.000003], {:microseconds, 2})
    end

    context "Errors with NaiveDateTime" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(~N[2017-08-07 01:10:10]).to be_close_to(~N[2017-08-07 01:10:15], {:seconds, 3}) end,
            message: "Expected `~N[2017-08-07 01:10:10]` to be close to `~N[2017-08-07 01:10:15]` with delta `{:seconds, 3}`, but it isn't. The actual delta is {:seconds, 5}."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(~N[2017-08-07 01:10:10]).to_not be_close_to(~N[2017-08-07 01:10:15], {:seconds, 5}) end,
            message: "Expected `~N[2017-08-07 01:10:10]` not to be close to `~N[2017-08-07 01:10:15]` with delta `{:seconds, 5}`, but it isn't. The actual delta is {:seconds, 5}."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end

    context "Success with Time with a granularity of hours" do
      it "checks success with `to`" do
        message = expect(~T[01:10:10]).to be_close_to(~T[02:10:10], {:hours, 1})
        expect(message) |> to(eq "`~T[01:10:10]` is close to `~T[02:10:10]` with delta `{:hours, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~T[01:10:10]).to_not be_close_to(~T[03:10:10], {:hours, 1})
        expect(message) |> to(eq "`~T[01:10:10]` is not close to `~T[03:10:10]` with delta `{:hours, 1}`.")
      end

      it do: expect(~T[01:10:10]).to be_close_to(~T[02:10:10], {:hours, 1})
    end

    context "Success with Time with a granularity of minutes" do
      it "checks success with `to`" do
        message = expect(~T[01:10:10]).to be_close_to(~T[01:50:10], {:minutes, 40})
        expect(message) |> to(eq "`~T[01:10:10]` is close to `~T[01:50:10]` with delta `{:minutes, 40}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~T[01:10:10]).to_not be_close_to(~T[01:51:10], {:minutes, 40})
        expect(message) |> to(eq "`~T[01:10:10]` is not close to `~T[01:51:10]` with delta `{:minutes, 40}`.")
      end

      it do: expect(~T[01:10:10]).to be_close_to(~T[01:50:10], {:minutes, 40})
    end

    context "Success with Time with a granularity of seconds" do
      it "checks success with `to`" do
        message = expect(~T[01:10:10]).to be_close_to(~T[01:10:11], {:seconds, 1})
        expect(message) |> to(eq "`~T[01:10:10]` is close to `~T[01:10:11]` with delta `{:seconds, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~T[01:10:10]).to_not be_close_to(~T[01:10:12], {:seconds, 1})
        expect(message) |> to(eq "`~T[01:10:10]` is not close to `~T[01:10:12]` with delta `{:seconds, 1}`.")
      end

      it do: expect(~T[01:10:10]).to be_close_to(~T[01:10:11], {:seconds, 1})
    end

    context "Success with Time with a granularity of microseconds" do
      it "checks success with `to`" do
        message = expect(~T[01:10:10.000001]).to be_close_to(~T[01:10:10.000002], {:microseconds, 1})
        expect(message) |> to(eq "`~T[01:10:10.000001]` is close to `~T[01:10:10.000002]` with delta `{:microseconds, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(~T[01:10:10.000001]).to_not be_close_to(~T[01:10:11.000002], {:microseconds, 1})
        expect(message) |> to(eq "`~T[01:10:10.000001]` is not close to `~T[01:10:11.000002]` with delta `{:microseconds, 1}`.")
      end

      it do: expect(~T[01:10:10.000001]).to be_close_to(~T[01:10:10.000002], {:microseconds, 1})
    end

    context "Errors with Time" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(~T[01:10:10.000001]).to be_close_to(~T[01:10:10.000006], {:microseconds, 3}) end,
            message: "Expected `~T[01:10:10.000001]` to be close to `~T[01:10:10.000006]` with delta `{:microseconds, 3}`, but it isn't. The actual delta is {:microseconds, 5}."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(~T[01:10:10.000001]).to_not be_close_to(~T[01:10:10.000006], {:microseconds, 5}) end,
            message: "Expected `~T[01:10:10.000001]` not to be close to `~T[01:10:10.000006]` with delta `{:microseconds, 5}`, but it isn't. The actual delta is {:microseconds, 5}."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end

    let :datetime1, do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000001], "Etc/UTC")
    let :datetime3, do: DateTime.Extension.from_naive!(~N[2020-08-07 01:10:10.000001], "Etc/UTC")

    context "Success with DateTime with a granularity of years" do
      let :datetime2, do: DateTime.Extension.from_naive!(~N[2018-08-07 01:10:10.000001], "Etc/UTC")

      it "checks success with `to`" do
        message = expect(datetime1()).to be_close_to(datetime2(), {:years, 1})
        expect(message) |> to(eq "`#{inspect datetime1()}` is close to `#{inspect datetime2()}` with delta `{:years, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()).to_not be_close_to(datetime3(), {:years, 2})
        expect(message) |> to(eq "`#{inspect datetime1()}` is not close to `#{inspect datetime3()}` with delta `{:years, 2}`.")
      end

      it do: expect(datetime1()).to be_close_to(datetime3(), {:years, 3})
    end

    context "Success with DateTime with a granularity of months" do
      let :datetime2, do: DateTime.Extension.from_naive!(~N[2017-09-07 01:10:10.000001], "Etc/UTC")
      it "checks success with `to`" do
        message = expect(datetime1()).to be_close_to(datetime2(), {:months, 1})
        expect(message) |> to(eq "`#{inspect datetime1()}` is close to `#{inspect datetime2()}` with delta `{:months, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()).to_not be_close_to(datetime3(), {:months, 2})
        expect(message) |> to(eq "`#{inspect datetime1()}` is not close to `#{inspect datetime3()}` with delta `{:months, 2}`.")
      end

      it do: expect(datetime1()).to be_close_to(datetime2(), {:months, 1})
    end

    context "Success with DateTime with a granularity of weeks" do
      let :datetime2, do: DateTime.Extension.from_naive!(~N[2017-08-14 01:10:10.000001], "Etc/UTC")
      it "checks success with `to`" do
        message = expect(datetime1()).to be_close_to(datetime2(), {:weeks, 1})
        expect(message) |> to(eq "`#{inspect datetime1()}` is close to `#{inspect datetime2()}` with delta `{:weeks, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()).to_not be_close_to(datetime3(), {:weeks, 1})
        expect(message) |> to(eq "`#{inspect datetime1()}` is not close to `#{inspect datetime3()}` with delta `{:weeks, 1}`.")
      end

      it do: expect(datetime1()).to be_close_to(datetime2(), {:weeks, 1})
    end

    context "Success with DateTime with a granularity of days" do
      let :datetime2, do: DateTime.Extension.from_naive!(~N[2017-08-06 01:10:10.000001], "Etc/UTC")
      let :datetime4, do: DateTime.Extension.from_naive!(~N[2017-10-07 01:10:10.000001], "Etc/UTC")
      it "checks success with `to`" do
        message = expect(datetime1()).to be_close_to(datetime2(), {:days, 1})
        expect(message) |> to(eq "`#{inspect datetime1()}` is close to `#{inspect datetime2()}` with delta `{:days, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()).to_not be_close_to(datetime3(), {:days, 1})
        expect(message) |> to(eq "`#{inspect datetime1()}` is not close to `#{inspect datetime3()}` with delta `{:days, 1}`.")
      end

      it do: expect(datetime1()).to be_close_to(datetime4(), {:days, 61})
    end

    context "Success with DateTime with a granularity of hours" do
      let :datetime2, do: DateTime.Extension.from_naive!(~N[2017-08-07 02:10:10.000001], "Etc/UTC")
      it "checks success with `to`" do
        message = expect(datetime1()).to be_close_to(datetime2(), {:hours, 1})
        expect(message) |> to(eq "`#{inspect datetime1()}` is close to `#{inspect datetime2()}` with delta `{:hours, 1}`.")
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()).to_not be_close_to(datetime3(), {:hours, 1})
        expect(message) |> to(eq "`#{inspect datetime1()}` is not close to `#{inspect datetime3()}` with delta `{:hours, 1}`.")
      end

      it do: expect(datetime1()).to be_close_to(datetime2(), {:hours, 1})
    end

    context "Success with DateTime with a granularity of minutes" do
      let :datetime2, do: DateTime.Extension.from_naive!(~N[2017-08-07 01:50:10.000001], "Etc/UTC")
      it "checks success with `to`" do
        message = expect(datetime1()).to be_close_to(datetime2(), {:minutes, 40})
        expect(message) |> to(eq "`#{inspect datetime1()}` is close to `#{inspect datetime2()}` with delta `{:minutes, 40}`.")
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()).to_not be_close_to(datetime2(), {:minutes, 39})
        expect(message) |> to(eq "`#{inspect datetime1()}` is not close to `#{inspect datetime2()}` with delta `{:minutes, 39}`.")
      end

      it do: expect(datetime1()).to be_close_to(datetime2(), {:minutes, 40})
    end

    context "Success with DateTime with a granularity of seconds" do
      let :datetime2, do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000001], "Etc/UTC")
      it "checks success with `to`" do
        message = expect(datetime1()).to be_close_to(datetime2(), {:seconds, 2})
        expect(message) |> to(eq "`#{inspect datetime1()}` is close to `#{inspect datetime2()}` with delta `{:seconds, 2}`.")
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()).to_not be_close_to(datetime2(), {:seconds, 1})
        expect(message) |> to(eq "`#{inspect datetime1()}` is not close to `#{inspect datetime2()}` with delta `{:seconds, 1}`.")
      end

      it do: expect(datetime1()).to be_close_to(datetime2(), {:seconds, 2})
    end

    context "Success with DateTime with a granularity of microseconds" do
      let :datetime2, do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000003], "Etc/UTC")
      it "checks success with `to`" do
        message = expect(datetime1()).to be_close_to(datetime2(), {:microseconds, 2})
        expect(message) |> to(eq "`#{inspect datetime1()}` is close to `#{inspect datetime2()}` with delta `{:microseconds, 2}`.")
      end

      it "checks success with `not_to`" do
        message = expect(datetime1()).to_not be_close_to(datetime2(), {:microseconds, 1})
        expect(message) |> to(eq "`#{inspect datetime1()}` is not close to `#{inspect datetime2()}` with delta `{:microseconds, 1}`.")
      end

      it do: expect(datetime1()).to be_close_to(datetime2(), {:microseconds, 2})
    end

    context "Success with DateTime with utc and std offsets to represent time zone differences" do
      let :datetime_pst, do: %DateTime{year: 2017, month: 3, day: 15, hour: 1, minute: 30, second: 30, microsecond: {1, 6}, std_offset: 1 * 3600, utc_offset: -8 * 3600, zone_abbr: "PST", time_zone: "America/Los_Angeles"}
      let :datetime_est, do: %DateTime{year: 2017, month: 3, day: 15, hour: 6, minute: 30, second: 30, microsecond: {1, 6}, std_offset: 1 * 3600, utc_offset: -5 * 3600, zone_abbr: "EST", time_zone: "America/New_York"}
      it "checks success with `to`" do
        message = expect(datetime_pst()).to be_close_to(datetime_est(), {:hours, 2})
        expect(message) |> to(eq "`#{inspect datetime_pst()}` is close to `#{inspect datetime_est()}` with delta `{:hours, 2}`.")
      end

      it "checks success with `not_to`" do
        message = expect(datetime_pst()).to_not be_close_to(datetime_est(), {:hours, 1})
        expect(message) |> to(eq "`#{inspect datetime_pst()}` is not close to `#{inspect datetime_est()}` with delta `{:hours, 1}`.")
      end

      it do: expect(datetime_pst()).to be_close_to(datetime_est(), {:hours, 2})
    end

    context "Errors with DateTime" do
      let :datetime1, do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000001], "Etc/UTC")
      let :datetime2, do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000006], "Etc/UTC")

      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(datetime1()).to be_close_to(datetime2(), {:microseconds, 3}) end,
            message: "Expected `#{inspect datetime1()}` to be close to `#{inspect datetime2()}` with delta `{:microseconds, 3}`, but it isn't. The actual delta is {:microseconds, 5}."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(datetime1()).to_not be_close_to(datetime2(), {:microseconds, 5}) end,
            message: "Expected `#{inspect datetime1()}` not to be close to `#{inspect datetime2()}` with delta `{:microseconds, 5}`, but it isn't. The actual delta is {:microseconds, 5}."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end

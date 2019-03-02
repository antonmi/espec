defmodule DatesTimes.BeTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success, without granularity" do
      let :datetime1,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000001], "Etc/UTC")

      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000003], "Etc/UTC")

      it do: expect(~D[2020-08-07]) |> to(be :>=, ~D[2017-08-07])
      it do: expect(~D[2017-08-07]) |> to_not(be :>, ~D[2020-08-07])
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-09-07 01:10:10])
      it do: expect(~N[2017-08-07 01:10:10]) |> to_not(be :>, ~N[2020-08-07 01:10:10])
      it do: expect(datetime1()) |> to(be :<=, datetime2())
      it do: expect(datetime1()) |> to_not(be :>, datetime2())
    end

    context "Success, with granularity" do
      let :datetime1,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000001], "Etc/UTC")

      let :datetime_months,
        do: DateTime.Extension.from_naive!(~N[2017-09-07 01:10:10.000001], "Etc/UTC")

      let :datetime3,
        do: DateTime.Extension.from_naive!(~N[2020-08-07 01:10:10.000001], "Etc/UTC")

      let :datetime_weeks,
        do: DateTime.Extension.from_naive!(~N[2017-08-14 01:10:10.000001], "Etc/UTC")

      let :datetime_days,
        do: DateTime.Extension.from_naive!(~N[2017-10-07 01:10:10.000001], "Etc/UTC")

      let :datetime_hours,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 02:10:10.000001], "Etc/UTC")

      let :datetime_minutes,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:50:10.000001], "Etc/UTC")

      let :datetime_seconds,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000001], "Etc/UTC")

      let :datetime_microseconds,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000003], "Etc/UTC")

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

      it do: expect(~D[2020-08-07]) |> to(be :>=, ~D[2017-08-07], {:year, 3})
      it do: expect(~D[2020-08-07]) |> to(be :>=, ~D[2017-08-07], year: 3)
      it do: expect(~D[2017-08-07]) |> to_not(be :<, ~D[2020-08-07], {:year, 2})
      it do: expect(~D[2017-08-07]) |> to_not(be :<, ~D[2020-08-07], year: 2)
      it do: expect(~D[2017-08-07]) |> to(be :>=, ~D[2017-01-07], {:month, 7})
      it do: expect(~D[2017-08-07]) |> to(be :>=, ~D[2017-01-07], month: 7)
      it do: expect(~D[2020-08-07]) |> to_not(be :>, ~D[2017-08-07], {:month, 36})
      it do: expect(~D[2017-08-14]) |> to(be :>=, ~D[2017-08-07], {:week, 1})
      it do: expect(~D[2017-08-14]) |> to(be :>=, ~D[2017-08-07], week: 1)
      it do: expect(~D[2017-08-07]) |> to_not(be :<, ~D[2020-08-07], {:week, 156})
      it do: expect(~D[2017-08-07]) |> to(be :<=, ~D[2017-10-07], {:day, 61})
      it do: expect(~D[2017-08-07]) |> to(be :<=, ~D[2017-10-07], day: 61)
      it do: expect(~D[2017-08-07]) |> to_not(be :<, ~D[2017-08-19], {:day, 1})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2020-08-07 01:10:10], {:year, 3})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2020-08-07 01:10:10], year: 3)
      it do: expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2020-08-07 01:10:10], {:year, 2})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :>=, ~N[2017-01-07 01:10:10], {:month, 7})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :>=, ~N[2017-01-07 01:10:10], month: 7)
      it do: expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2020-08-07 01:10:10], {:month, 2})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-14 01:10:10], {:week, 1})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-14 01:10:10], week: 1)
      it do: expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2020-08-07 01:10:10], {:week, 2})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-10-07 01:10:10], {:day, 61})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-10-07 01:10:10], day: 61)
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 02:10:10], {:hour, 1})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 02:10:10], hour: 1)
      it do: expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2017-08-19 01:10:10], {:hour, 1})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 01:50:10], {:minute, 40})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 01:50:10], minute: 40)

      it do:
           expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2017-08-07 01:51:10], {:minute, 40})

      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 01:10:11], {:second, 1})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<=, ~N[2017-08-07 01:10:11], second: 1)
      it do: expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2017-08-07 01:10:12], {:second, 1})

      it do:
           expect(~N[2017-08-07 01:10:10.000001]) |> to(
             be :<=, ~N[2017-08-07 01:10:10.000003], {:microsecond, 2}
           )

      it do:
           expect(~N[2017-08-07 01:10:10.000001]) |> to(
             be :<=, ~N[2017-08-07 01:10:10.000003], microsecond: 2
           )

      it do:
           expect(~N[2017-08-07 01:10:10.000001]) |> to_not(
             be :<, ~N[2017-08-07 01:10:10.000003], {:microsecond, 1}
           )

      it do: expect(~T[01:10:10]) |> to(be :<=, ~T[02:10:10], {:hour, 1})
      it do: expect(~T[01:10:10]) |> to(be :<=, ~T[02:10:10], hour: 1)
      it do: expect(~T[01:10:10]) |> to_not(be :<, ~T[03:10:10], {:hour, 1})
      it do: expect(~T[01:10:10]) |> to(be :<=, ~T[01:50:10], {:minute, 40})
      it do: expect(~T[01:10:10]) |> to(be :<=, ~T[01:50:10], minute: 40)
      it do: expect(~T[01:10:10]) |> to_not(be :<, ~T[01:50:10], {:minute, 40})
      it do: expect(~T[01:10:10]) |> to(be :<=, ~T[01:10:11], {:second, 1})
      it do: expect(~T[01:10:10]) |> to(be :<=, ~T[01:10:11], second: 1)
      it do: expect(~T[01:10:10]) |> to_not(be :<, ~T[01:10:12], {:second, 1})
      it do: expect(~T[01:10:10.000001]) |> to(be :<=, ~T[01:10:10.000002], {:microsecond, 1})
      it do: expect(~T[01:10:10.000001]) |> to(be :<=, ~T[01:10:10.000002], microsecond: 1)
      it do: expect(~T[01:10:10.000001]) |> to_not(be :<, ~T[01:10:11.000002], {:microsecond, 1})
      it do: expect(datetime1()) |> to(be :<=, datetime3(), {:year, 3})
      it do: expect(datetime1()) |> to(be :<=, datetime3(), year: 3)
      it do: expect(datetime1()) |> to_not(be :<, datetime3(), {:year, 2})
      it do: expect(datetime1()) |> to(be :<=, datetime_months(), {:month, 1})
      it do: expect(datetime1()) |> to(be :<=, datetime_months(), month: 1)
      it do: expect(datetime1()) |> to(be :<=, datetime_weeks(), {:week, 1})
      it do: expect(datetime1()) |> to(be :<=, datetime_weeks(), week: 1)
      it do: expect(datetime1()) |> to(be :<=, datetime_days(), {:day, 61})
      it do: expect(datetime1()) |> to(be :<=, datetime_days(), day: 61)
      it do: expect(datetime1()) |> to_not(be :<, datetime3(), {:day, 1})
      it do: expect(datetime1()) |> to(be :<=, datetime_hours(), {:hour, 1})
      it do: expect(datetime1()) |> to(be :<=, datetime_hours(), hour: 1)
      it do: expect(datetime1()) |> to(be :<=, datetime_minutes(), {:minute, 40})
      it do: expect(datetime1()) |> to(be :<=, datetime_minutes(), minute: 40)
      it do: expect(datetime1()) |> to(be :<=, datetime_seconds(), {:second, 2})
      it do: expect(datetime1()) |> to(be :<=, datetime_seconds(), second: 2)
      it do: expect(datetime1()) |> to(be :<=, datetime_microseconds(), {:microsecond, 2})
      it do: expect(datetime1()) |> to(be :<=, datetime_microseconds(), microsecond: 2)
      it do: expect(datetime_pst()) |> to(be :<=, datetime_est(), {:hour, 2})
      it do: expect(datetime_pst()) |> to(be :<=, datetime_est(), hour: 2)
      it do: expect(datetime_pst()) |> to_not(be :<, datetime_est(), {:hour, 1})
    end

    context "Errors, without granularity" do
      let :datetime1,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000001], "Etc/UTC")

      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000006], "Etc/UTC")

      it do: expect(~D[2017-08-07]) |> to(be :>, ~D[2050-08-19])
      it do: expect(~D[2017-08-07]) |> to_not(be :<, ~D[2017-10-07])
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :>=, ~N[2017-08-07 01:10:15])
      it do: expect(~N[2017-08-07 01:10:10]) |> to_not(be :<, ~N[2017-08-07 01:10:15])
      it do: expect(datetime1()) |> to(be :>, datetime2())
      it do: expect(datetime1()) |> to_not(be :<, datetime2())
    end

    context "Errors, with granularity" do
      let :datetime1,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000001], "Etc/UTC")

      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000006], "Etc/UTC")

      it do: expect(~D[2020-08-07]) |> to(be :<, ~D[2017-08-07], {:year, 3})
      it do: expect(~D[2017-08-07]) |> to_not(be :<, ~D[2017-10-07], {:month, 3})
      it do: expect(~N[2017-08-07 01:10:10]) |> to(be :<, ~N[2017-08-07 01:10:15], {:second, 3})

      it do:
           expect(~N[2017-08-07 01:10:10]) |> to_not(be :<=, ~N[2017-08-07 01:10:15], {:second, 5})

      it do: expect(~T[01:10:10.000001]) |> to(be :>, ~T[01:10:10.000006], {:microsecond, 3})
      it do: expect(~T[01:10:10.000001]) |> to_not(be :<, ~T[01:10:10.000006], {:microsecond, 6})
      it do: expect(datetime1()) |> to(be :<, datetime2(), {:microsecond, 3})
      it do: expect(datetime1()) |> to_not(be :<, datetime2(), {:microsecond, 6})
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples(), true)
    {:ok, success: Enum.slice(examples, 0, 74), errors: Enum.slice(examples, 75, 88)}
  end

  test "Success", context do
    Enum.each(context[:success], &assert(&1.status == :success))
  end

  test "Errors", context do
    Enum.each(context[:errors], &assert(&1.status == :failure))
  end
end

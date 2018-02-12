defmodule DatesTimes.BeCloseToTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success, Date with granularity" do
      it do: expect(~D[2017-08-07]).to(be_close_to(~D[2020-08-07], {:years, 3}))
      it do: expect(~D[2017-08-07]).to_not(be_close_to(~D[2020-08-07], {:years, 2}))
      it do: expect(~D[2017-08-07]).to(be_close_to(~D[2017-01-07], {:months, 7}))
      it do: expect(~D[2017-08-07]).to_not(be_close_to(~D[2020-08-07], {:months, 2}))
      it do: expect(~D[2017-08-07]).to(be_close_to(~D[2017-08-14], {:weeks, 1}))
      it do: expect(~D[2017-08-07]).to_not(be_close_to(~D[2020-08-07], {:weeks, 2}))
      it do: expect(~D[2017-08-07]).to(be_close_to(~D[2017-10-07], {:days, 61}))
      it do: expect(~D[2017-08-07]).to_not(be_close_to(~D[2017-08-19], {:days, 1}))
    end

    context "Success, NaiveDateTime with granularity" do
      it do: expect(~N[2017-08-07 01:10:10]).to(be_close_to(~N[2020-08-07 01:10:10], {:years, 3}))

      it do:
           expect(~N[2017-08-07 01:10:10]).to_not(
             be_close_to(~N[2020-08-07 01:10:10], {:years, 2})
           )

      it do: expect(~N[2017-08-07 01:10:10]).to(be_close_to(~N[2017-08-14 01:10:10], {:weeks, 1}))

      it do:
           expect(~N[2017-08-07 01:10:10]).to_not(
             be_close_to(~N[2020-08-07 01:10:10], {:weeks, 2})
           )
    end

    context "Success, Time with granularity" do
      it do: expect(~T[01:10:10]).to(be_close_to(~T[02:10:10], {:hours, 1}))
      it do: expect(~T[01:10:10]).to_not(be_close_to(~T[03:10:10], {:hours, 1}))
      it do: expect(~T[01:10:10]).to(be_close_to(~T[01:50:10], {:minutes, 40}))
      it do: expect(~T[01:10:10]).to_not(be_close_to(~T[01:51:10], {:minutes, 40}))
      it do: expect(~T[01:10:10]).to(be_close_to(~T[01:10:11], {:seconds, 1}))
      it do: expect(~T[01:10:10]).to_not(be_close_to(~T[01:10:12], {:seconds, 1}))
      it do: expect(~T[01:10:10.000001]).to(be_close_to(~T[01:10:10.000002], {:microseconds, 1}))

      it do:
           expect(~T[01:10:10.000001]).to_not(
             be_close_to(~T[01:10:11.000002], {:microseconds, 1})
           )
    end

    context "Success, DateTime with granularity" do
      let :datetime_a,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:10.000001], "Etc/UTC")

      let :datetime_b,
        do: DateTime.Extension.from_naive!(~N[2020-08-07 01:10:10.000001], "Etc/UTC")

      let :datetime_months,
        do: DateTime.Extension.from_naive!(~N[2017-09-07 01:10:10.000001], "Etc/UTC")

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

      it do: expect(datetime_a()).to(be_close_to(datetime_b(), {:years, 3}))
      it do: expect(datetime_a()).to_not(be_close_to(datetime_b(), {:years, 2}))
      it do: expect(datetime_a()).to(be_close_to(datetime_months(), {:months, 1}))
      it do: expect(datetime_a()).to_not(be_close_to(datetime_b(), {:months, 2}))
      it do: expect(datetime_a()).to(be_close_to(datetime_weeks(), {:weeks, 1}))
      it do: expect(datetime_a()).to_not(be_close_to(datetime_b(), {:weeks, 1}))
      it do: expect(datetime_a()).to(be_close_to(datetime_days(), {:days, 61}))
      it do: expect(datetime_a()).to_not(be_close_to(datetime_b(), {:days, 1}))
      it do: expect(datetime_a()).to(be_close_to(datetime_hours(), {:hours, 1}))
      it do: expect(datetime_a()).to_not(be_close_to(datetime_b(), {:hours, 1}))
      it do: expect(datetime_a()).to(be_close_to(datetime_minutes(), {:minutes, 40}))
      it do: expect(datetime_a()).to_not(be_close_to(datetime_minutes(), {:minutes, 39}))
      it do: expect(datetime_a()).to(be_close_to(datetime_seconds(), {:seconds, 2}))
      it do: expect(datetime_a()).to_not(be_close_to(datetime_seconds(), {:seconds, 1}))
      it do: expect(datetime_a()).to(be_close_to(datetime_microseconds(), {:microseconds, 2}))
      it do: expect(datetime_a()).to_not(be_close_to(datetime_microseconds(), {:microseconds, 1}))
    end

    context "Errors, Date with granularity" do
      it do: expect(~D[2017-08-07]).to(be_close_to(~D[2050-08-19], {:years, 3}))
      it do: expect(~D[2017-08-07]).to_not(be_close_to(~D[2017-10-07], {:months, 2}))
    end

    context "Errors, NaiveDateTime with granularity" do
      it do:
           expect(~N[2017-08-07 01:10:10]).to(be_close_to(~N[2017-08-07 01:10:15], {:seconds, 3}))

      it do:
           expect(~N[2017-08-07 01:10:10]).to_not(
             be_close_to(~N[2017-08-07 01:10:15], {:seconds, 5})
           )
    end

    context "Errors, Time with granularity" do
      it do: expect(~T[01:10:10.000001]).to(be_close_to(~T[01:10:10.000006], {:microseconds, 3}))

      it do:
           expect(~T[01:10:10.000001]).to_not(
             be_close_to(~T[01:10:10.000006], {:microseconds, 5})
           )
    end

    context "Errors, DateTime with granularity" do
      let :datetime1,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000001], "Etc/UTC")

      let :datetime2,
        do: DateTime.Extension.from_naive!(~N[2017-08-07 01:10:12.000006], "Etc/UTC")

      it do: expect(datetime1()).to(be_close_to(datetime2(), {:microseconds, 3}))
      it do: expect(datetime1()).to_not(be_close_to(datetime2(), {:microseconds, 5}))
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples(), true)
    {:ok, success: Enum.slice(examples, 0, 35), errors: Enum.slice(examples, 36, 43)}
  end

  test "Success", context do
    Enum.each(context[:success], &assert(&1.status == :success))
  end

  test "Errors", context do
    Enum.each(context[:errors], &assert(&1.status == :failure))
  end
end

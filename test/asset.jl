@testset "ExternallyPricedAsset" begin
    externally_priced_asset_eod = ExternallyPricedAsset(
        "externally_priced_asset_eod",
        PricesSeries(time = [
            DateTime(2023,1,1),
            DateTime(2023,1,2),
            DateTime(2023,1,3),
        ], val = [100.0, 101.0, 102.0])
    )
    times_subset = [DateTime(2023,1,1), DateTime(2023,1,3)]
    prices_subset = [100.0, 102.0]
    exp = PricesSeries(time = times_subset, val = prices_subset)
    act = get_prices(externally_priced_asset_eod, times_subset)
    @test act == exp

    prices_series = PricesSeries(
        time = [
                DateTime(2023,1,1,13,00,00),
                DateTime(2023,1,1,16,00,00),
                DateTime(2023,1,1,17,00,00),
        ], val = [100.0, 101.0, 102.0]
    )
    externally_priced_asset_intraday = ExternallyPricedAsset(
        "externally_priced_asset_intraday",
        prices_series,
    )
    cutoff_time = DateTime(2023,1,1,16,30,00)
    exp = filter(prices_series) do p
        p.time < cutoff_time
    end
    act = get_prices(externally_priced_asset_intraday, [cutoff_time])
    @test act == exp
end

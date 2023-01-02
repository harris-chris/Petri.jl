@testset "ExternallyPricedAsset" begin
    externally_priced_asset = ExternallyPricedAsset(
        "externally_price_asset_1",
        PricesSeries(time = [
            DateTime(2023,1,1),
            DateTime(2023,1,2),
            DateTime(2023,1,3),
        ], val = [100.0, 101.0, 102.0])
    )
    println("ep1 is $externally_priced_asset")

    times_subset = [DateTime(2023,1,1), DateTime(2023,1,3)]
    prices_subset = [100.0, 102.0]
    exp = PricesSeries(time = times_subset, val = prices_subset)
    println("exp is $externally_priced_asset")
    act = get_prices(externally_priced_asset, times_subset)
    println(act)
    @test act == exp
end

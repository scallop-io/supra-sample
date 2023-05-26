module supra_rule::rule {
  use supra_rule::supra_registry::{Self, SupraRegistry};

  use SupraOracle::SupraSValueFeed::{Self, OracleHolder};

  const U8_MAX: u16 = 255;
  const U64_MAX: u128 = 18446744073709551615;

  const PRICE_DECIMALS_TOO_LARGE: u64 = 0;
  const PRICE_VALUE_TOO_LARGE: u64 = 1;
  const TIMESTAMP_TOO_LARGE: u64 = 2;


  public fun get_price<CoinType>(
    supra_oracle: &mut OracleHolder,
    supra_registry: &SupraRegistry,
  ):(u64, u8, u64) {
    // Make sure the price info object is the registerred one for the coin type
    let pair_id = supra_registry::get_supra_pair_id<CoinType>(supra_registry);
    let (price_value, price_decimals, timestamp, _) = SupraSValueFeed::get_price(supra_oracle, pair_id);

    assert!(price_decimals <= U8_MAX, PRICE_DECIMALS_TOO_LARGE);
    let price_decimals = (price_decimals as u8);

    assert!(price_value <= U64_MAX, PRICE_VALUE_TOO_LARGE);
    let price_value = (price_value as u64);

    // Supra timestamp is in milliseconds, but XOracle timestamp is in seconds
    let now= timestamp / 1000;
    assert!(now <= U64_MAX, TIMESTAMP_TOO_LARGE);
    let now = (now as u64);

    (price_value, price_decimals, now)
  }
}

module pyth::pocket {

    use sui::object::{Self, UID};
    use sui::url::{Self, Url};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::vec_map::{Self, VecMap};
    use sui::vec_set::{Self, VecSet};
    use std::string::{Self, String};
    use sui::coin::{Self, Coin};
    use sui::event;
    use std::type_name;
    use sui::math::pow;
    use sui::object::ID;
    use sui::clock::Clock;
    use sui::dynamic_field as df;
    use pyth::price_info::{Self, PriceInfo, PriceInfoObject};
    use pyth::i64;
    use pyth::state::State as PythState;
    use pyth::price::Self as pyth_price;
    use pyth::pyth::get_price as pyth_get_price;


    // === Errors ===

    const EInvalidPriceObjectInfo: u64 = 0;
    const EZeroPrice: u64 = 1;
    const EPriceConfidenceOutOfRange: u64 = 2;
    const EWRONGAMOUNT:u64 = 3;


    public struct PriceInfoObjectKey has copy, drop, store {}

    public struct ConfidenceKey has copy, drop, store {}

    public struct PythFeed has drop {}


    public struct Details has key, store {
        id: UID,
        amount: u64,
    }

    fun init(_ctx: &mut sui::tx_context::TxContext) {
        
    }



    fun get_price(
        pyth_state: &PythState,
        price_info_object: &mut PriceInfoObject,
        clock_object: &Clock
    ) {

        let pyth_price = pyth_get_price(pyth_state, price_info_object, clock_object);
        let pyth_price_value = pyth_price::get_price(&pyth_price);
        let pyth_price_expo = pyth_price::get_expo(&pyth_price);
        let latest_timestamp = pyth_price::get_timestamp(&pyth_price);
        let price_conf = pyth_price::get_conf(&pyth_price);

        let pyth_price_u64 = i64::get_magnitude_if_positive(&pyth_price_value);


    }
  


    

}

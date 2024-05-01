module pyth::pocket {

    // use sui::object::{Self, UID};
    // use sui::url::{Self, Url};
    // use sui::transfer;
    // use sui::tx_context::{Self, TxContext};
    // use sui::vec_map::{Self, VecMap};
    // use sui::vec_set::{Self, VecSet};
    // use std::string::{Self, String};
    use sui::coin::{Self, Coin};
    // use sui::event;
    // use std::type_name;
    // use sui::math::pow;
    // use sui::object::ID;
    use sui::clock::Clock;
    // use sui::dynamic_field as df;
    use pyth::price_info::{Self, PriceInfo, PriceInfoObject};
    use pyth::i64;
    use pyth::state::State as PythState;
    use pyth::price::Self as pyth_price;
    use pyth::pyth::get_price as pyth_get_price;


    // === Errors ===

    // const E_Invalid_Price_Object_Info: u64 = 0;
    const E_ZERO_PRICE: u64 = 1;
    // const E_Price_Confidence_Out_Of_Range: u64 = 2;
    const E_WRONG_AMOUNT:u64 = 3;
    const E_NEGATIVE_PRICE:u64 = 4;

    public struct PriceInfoObjectKey has copy, drop, store {}

    public struct ConfidenceKey has copy, drop, store {}

    public struct PythFeed has drop {}


    public struct Details has key, store {
        id: UID,
        amount: u64,
    }

    fun init(_ctx: &mut sui::tx_context::TxContext) {
        
    }

     public fun get_usd_to_sui_rate(pyth_state_id: &PythState, price_info_object: &mut PriceInfoObject, clock_object: &Clock): u64 {
        let pyth_price = pyth_get_price(pyth_state_id, price_info_object, clock_object);
        let price_in_usd = pyth_price::get_price(&pyth_price);
        let is_negative = i64::get_is_negative(&price_in_usd);

        assert!(!is_negative, E_NEGATIVE_PRICE);
        i64::get_magnitude_if_positive(&price_in_usd)
    }
  
    
    public entry fun send_tx<T>(
        payment: &mut Coin<T>, addr: address, amount:u64,
                pyth_state_id: &PythState, price_info_object: &mut PriceInfoObject, clock_object: &Clock, ctx: &mut TxContext
    ) {
        let signer = tx_context::sender(ctx);
        let sui_rate = get_usd_to_sui_rate(pyth_state_id, price_info_object, clock_object);
        assert!(sui_rate > 0, E_ZERO_PRICE);

        // Convert USD amount to SUI
        let sui_amount = amount * 1_000_000 / sui_rate;  // Assuming the rate is given per million SUI for precision
        

        assert!(sui_amount > 0, E_WRONG_AMOUNT);

        let balance = coin::balance_mut(payment);
        let new_coin = coin::take(balance, sui_amount, ctx); 

        transfer::public_transfer(new_coin, addr);

        let details = Details {
                id: object::new(ctx),
                amount: sui_amount,
        };

        transfer::transfer(details, signer)
    }

}




// public entry fun get_price(
    //     pyth_state_id: &PythState,
    //     price_info_object: &mut PriceInfoObject,
    //     clock_object: &Clock
    // ) {

    //     let pyth_price = pyth_get_price(pyth_state_id, price_info_object, clock_object);
    //     let pyth_price_value = pyth_price::get_price(&pyth_price);
    //     let pyth_price_expo = pyth_price::get_expo(&pyth_price);
    //     let latest_timestamp = pyth_price::get_timestamp(&pyth_price);
    //     let price_conf = pyth_price::get_conf(&pyth_price);

    //     let pyth_price_u64 = i64::get_magnitude_if_positive(&pyth_price_value);

    //     assert!(pyth_price_u64 != 0, E_WRONG_AMOUNT);
    //     let is_exponent_negative = i64::get_is_negative(&pyth_price_expo);  
    // }
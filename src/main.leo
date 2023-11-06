// The 'shop' program.
program exchanger.aleo {

    struct Currency {
        name: field
    }

    struct CurrencyPair {
        first_currency_id: field,
        second_currency_id: field
    }

    mapping currencies_amounts: field => u64;

    transition create_currencies(first_currency: Currency, second_currency: Currency) -> CurrencyPair {
        let first_id: field = BHP256::hash_to_field(first_currency.name);
        let second_id: field = BHP256::hash_to_field(second_currency.name);
        return CurrencyPair {
            first_currency_id: first_id,
            second_currency_id: second_id
        }  then finalize(first_id, second_id);
    }

    finalize create_currencies(first_id: field, second_id: field) {
        let first_current_amount: u64 = Mapping::get_or_use(currencies_amounts, first_id, 0u64);
        let second_current_amount: u64 = Mapping::get_or_use(currencies_amounts, second_id, 0u64);
        Mapping::set(currencies_amounts, first_id, first_current_amount);
        Mapping::set(currencies_amounts, second_id, second_current_amount);
    }

    transition add_currencies(first_id: field, second_id: field, amount: u64) {
        return then finalize(first_id, second_id, amount);
    }

    finalize add_currencies(first_id: field, second_id: field, amount: u64) {
        let first_amount: u64 = Mapping::get_or_use(currencies_amounts, first_id, 0u64);
        Mapping::set(currencies_amounts, first_id, first_amount.add(amount));
        let second_amount: u64 = Mapping::get_or_use(currencies_amounts, second_id, 0u64);
        Mapping::set(currencies_amounts, second_id, second_amount.add(amount));
    }

    transition change_currency(first_id:field, second_id: field, amount: u64) {
        return then finalize(first_id, second_id, amount);
    }

    finalize change_currency(first_id: field, second_id: field, amount: u64) {
        let first_amount: u64 = Mapping::get_or_use(currencies_amounts, first_id, 0u64);
        let second_amount: u64 = Mapping::get_or_use(currencies_amounts, second_id, 0u64);
        let is_enough: bool = first_amount >= amount;
        assert(is_enough);
        Mapping::set(currencies_amounts, first_id, first_amount.sub(amount));
    }

}

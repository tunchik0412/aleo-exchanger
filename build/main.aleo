program exchanger.aleo;

struct Currency:
    name as field;

struct CurrencyPair:
    first_currency_id as field;
    second_currency_id as field;


mapping currencies_amounts:
	key as field.public;
	value as u64.public;

function create_currencies:
    input r0 as Currency.private;
    input r1 as Currency.private;
    hash.bhp256 r0.name into r2 as field;
    hash.bhp256 r1.name into r3 as field;
    cast r2 r3 into r4 as CurrencyPair;
    async create_currencies r2 r3 into r5;
    output r4 as CurrencyPair.private;
    output r5 as exchanger.aleo/create_currencies.future;

finalize create_currencies:
    input r0 as field.public;
    input r1 as field.public;
    get.or_use currencies_amounts[r0] 0u64 into r2;
    get.or_use currencies_amounts[r1] 0u64 into r3;
    set r2 into currencies_amounts[r0];
    set r3 into currencies_amounts[r1];


function add_currencies:
    input r0 as field.private;
    input r1 as field.private;
    input r2 as u64.private;
    async add_currencies r0 r1 r2 into r3;
    output r3 as exchanger.aleo/add_currencies.future;

finalize add_currencies:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as u64.public;
    get.or_use currencies_amounts[r0] 0u64 into r3;
    add r3 r2 into r4;
    set r4 into currencies_amounts[r0];
    get.or_use currencies_amounts[r1] 0u64 into r5;
    add r5 r2 into r6;
    set r6 into currencies_amounts[r1];


function change_currency:
    input r0 as field.private;
    input r1 as field.private;
    input r2 as u64.private;
    async change_currency r0 r1 r2 into r3;
    output r3 as exchanger.aleo/change_currency.future;

finalize change_currency:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as u64.public;
    get.or_use currencies_amounts[r0] 0u64 into r3;
    get.or_use currencies_amounts[r1] 0u64 into r4;
    gte r3 r2 into r5;
    assert.eq r5 true;
    sub r3 r2 into r6;
    set r6 into currencies_amounts[r0];

program token_693.aleo;

record Token:
    owner as address.private;
    amount as u64.private;


mapping balance:
	key as address.public;
	value as u64.public;

function mint_private:
    input r0 as u64.private;
    cast self.caller r0 into r1 as Token.record;
    output r1 as Token.record;


function mint_public:
    input r0 as u64.private;
    async mint_public r0 self.caller into r1;
    output r1 as token_693.aleo/mint_public.future;

finalize mint_public:
    input r0 as u64.public;
    input r1 as address.public;
    set r0 into balance[r1];


function transfer_private:
    input r0 as u64.private;
    input r1 as address.private;
    input r2 as Token.record;
    sub r2.amount r0 into r3;
    cast self.caller r3 into r4 as Token.record;
    cast r1 r0 into r5 as Token.record;
    output r4 as Token.record;
    output r5 as Token.record;


function transfer_public:
    input r0 as u64.private;
    input r1 as address.private;
    async transfer_public r0 r1 self.caller into r2;
    output r2 as token_693.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as u64.public;
    input r1 as address.public;
    input r2 as address.public;
    get.or_use balance[r2] 0u64 into r3;
    get.or_use balance[r1] 0u64 into r4;
    gte r3 r0 into r5;
    assert.eq r5 true;
    sub r3 r0 into r6;
    set r6 into balance[r2];
    set r0 into balance[r1];


function transfer_private_to_public:
    input r0 as u64.private;
    input r1 as address.private;
    input r2 as Token.record;
    sub r2.amount r0 into r3;
    cast self.caller r3 into r4 as Token.record;
    async transfer_private_to_public r0 r1 into r5;
    output r4 as Token.record;
    output r5 as token_693.aleo/transfer_private_to_public.future;

finalize transfer_private_to_public:
    input r0 as u64.public;
    input r1 as address.public;
    get.or_use balance[r1] 0u64 into r2;
    add r0 r2 into r3;
    set r3 into balance[r1];


function transfer_public_to_private:
    input r0 as u64.private;
    input r1 as address.private;
    cast r1 r0 into r2 as Token.record;
    async transfer_public_to_private r0 self.caller into r3;
    output r2 as Token.record;
    output r3 as token_693.aleo/transfer_public_to_private.future;

finalize transfer_public_to_private:
    input r0 as u64.public;
    input r1 as address.public;
    get.or_use balance[r1] 0u64 into r2;
    sub r2 r0 into r3;
    set r3 into balance[r1];

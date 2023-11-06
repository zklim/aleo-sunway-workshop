// The 'token_693' program.
program token_693.aleo {
    
    mapping balance: address => u64;

    record Token {
        owner: address,
        amount: u64,
    }

    transition mint_private(amount: u64) -> Token {
        return Token {
            owner: self.caller,
            amount: amount,
        };
    }

    transition mint_public(amount: u64) {
        return then finalize(amount, self.caller);
    }

    finalize mint_public(amount: u64, caller: address) {
        Mapping::set(balance, caller, amount);
    }

    transition transfer_private(amount: u64, receiver: address, input: Token) -> (Token, Token) {
        let difference: u64 = input.amount - amount;

        let caller: Token = Token {
            owner: self.caller,
            amount: difference,
        };

        let recipient: Token = Token {
            owner: receiver,
            amount: amount,
        };

        return (caller, recipient);
    }

    transition transfer_public(amount: u64, receiver: address) {
        return then finalize(amount, receiver, self.caller);
    }

    finalize transfer_public(amount: u64, receiver: address, caller: address) {
        let prev_balance: u64 = Mapping::get_or_use(balance, caller, 0u64);
        let prev_balance2: u64 = Mapping::get_or_use(balance, receiver, 0u64);

        assert(prev_balance >= amount);
        let difference: u64 = prev_balance - amount;

        Mapping::set(balance, caller, difference);
        Mapping::set(balance, receiver, amount);
    }

    transition transfer_private_to_public(amount: u64, receiver: address, input: Token) -> Token {
        let difference: u64 = input.amount - amount;

        let caller: Token = Token {
            owner: self.caller,
            amount: difference,
        };

        return caller then finalize (amount, receiver);
    }

    finalize transfer_private_to_public(amount: u64, receiver: address) {
        let prev_balance2: u64 = Mapping::get_or_use(balance, receiver, 0u64);

        Mapping::set(balance, receiver, amount + prev_balance2);
    }

    transition transfer_public_to_private(amount: u64, receiver: address) -> Token {
        return Token {
            owner: receiver,
            amount: amount,
        } then finalize (amount, self.caller);
    }

    finalize transfer_public_to_private(amount: u64, caller: address) {
        let prev_balance: u64 = Mapping::get_or_use(balance, caller, 0u64);
        
        Mapping::set(balance, caller, prev_balance - amount);
    }

    transition join(input: Token, input2: Token) -> Token {
        return Token {
            owner: self.caller,
            amount: input.amount + input2.amount,
        };
    }
}

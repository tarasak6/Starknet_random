%lang starknet

from starkware.cairo.common.math import assert_le

const PRIME: felt = 2654435761;  // A large prime number
const SEED: felt = 42;  // Initial seed

@storage_var
var current_seed: felt = SEED;

@external
func test_random_number{
    syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
}() -> (random_number: felt) {
    alloc_locals;
    
    // Generate the next random number using a different algorithm.
    let random_number = xorshift32();
    
    return (random_number,);
}

func xorshift32() -> (random: felt) {
    alloc_locals;
    let seed = current_seed;
    
    // Xorshift algorithm to generate the next random number.
    let x = seed ^ (seed << 13);
    let y = x ^ (x >> 17);
    let z = y ^ (y << 5);
    
    current_seed = z;
    
    return (z % PRIME);
}

 @external
 func random_float{
      syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
  }() -> (random_float: felt) {
     alloc_locals;

     // Generate a random float in the range [0, 1).
     let random_float = felt(xorshift32()) / felt(PRIME);

     return (random_float,);
}

  @external
 func random_int_in_range{
     syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
 }(min_value: felt, max_value: felt) -> (random_int: felt) {
     alloc_locals;

     // Generate a random integer in the specified range.
     let random_int = min_value + (xorshift32() % (max_value - min_value + 1));

     return (random_int,);
 }

   @external
 func set_seed{
     syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
 }(seed: felt) -> (success: felt) {
     current_seed = seed;
     return (1,);  // Success
  }

  @external
 func get_current_seed{
     syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
  }() -> (seed: felt) {
     return (current_seed,);
  } 

  @external
 func shuffle_array{
     syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
 }(arr: felt*) -> (shuffled: felt*) {
     alloc_locals;

     // Fisher-Yates shuffle algorithm.
     let array_length = arr[0];
     for i in [array_length - 1, 0..0] {
         let j = (i + 1) % (array_length - 1);
         let temp = arr[i + 1];
         arr[i + 1] = arr[j + 1];
         arr[j + 1] = temp;
     }

     return (arr,);
     }

    @external
  func random_boolean{
      syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
  }() -> (result: felt) {
      alloc_locals;

      // Generate a random boolean value (true or false).
      let is_true = xorshift32() % 2;

      return (is_true,);
  }

  @external
func random_password{
    syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
}(length: felt) -> (random_password: felt*) {
    alloc_locals;
    const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*";
    var password: felt* = [];

    // Generate a random password of the specified length.
    for i in [0, length - 1] {
        let char_index = xorshift32() % len(charset);
        password := [charset[char_index], ...password];
    }

    return (password,);
    }
  
    @external
 func random_hash{
     syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
 }() -> (random_hash: felt) {
     alloc_locals;

     // Generate a random hash value (e.g., CRC32, Adler32, etc.).
     let random_hash = xorshift32() ^ (xorshift32() << 13);

     return (random_hash,);
    }
   
    @external
  func reset_seed_to_initial{
    syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
  }() -> (success: felt) {
   current_seed = SEED;
    return (1,);  // Success
    }

     @external
   func random_date{
      syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
    }() -> (random_date: felt) {
      alloc_locals;

     // Generate a random date value (e.g., timestamp).
     let random_date = xorshift32() + current_seed;

     return (random_date,);
     }
  @external
 func random_color{
     syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
}() -> (random_color: felt) {
    alloc_locals;

    // Generate a random color value (e.g., RGB).
    let r = xorshift32() % 256;
    let g = xorshift32() % 256;
    let b = xorshift32() % 256;

    let random_color = (r << 16) | (g << 8) | b;

    return (random_color,);
}

 @external
func random_walk{
    syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
}(steps: felt, max_step_size: felt) -> (position: felt) {
    alloc_locals;
    var position: felt = 0;

    // Simulate a random walk with the given number of steps and maximum step size.
    for _ in [0, steps - 1] {
        let step = xorshift32() % (2 * max_step_size + 1) - max_step_size;
        position += step;
    }

    return (position,);
}

 @external
func random_phone_number{
    syscall_ptr, bitwise_ptr, pedersen_ptr, range_check_ptr
}() -> (random_phone_number: felt) {
    alloc_locals;

    // Generate a random phone number with a valid format.
    let area_code = xorshift32() % 1000;
    let exchange_code = xorshift32() % 1000;
    let subscriber_number = xorshift32() % 10000;

    let random_phone_number = (area_code * 10000000) + (exchange_code * 10000) + subscriber_number;

    return (random_phone_number,);
}

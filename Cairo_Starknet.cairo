%lang starknet

from starkware.cairo.common.math import assert_le, unsigned_div_rem
from starkware.cairo.common.registers import get_label_location

const A: felt = 6364136223846793005;  // Multiplier
const C: felt = 1;  // Increment
const M: felt = 2**64;  // Modulus
const INITIAL_SEED: felt = 42;

@storage_var
var current_seed: felt = INITIAL_SEED;

@external
func next_random{
    syscall_ptr, range_check_ptr
}(unused_ptr: felt*) -> (random_number: felt) {
    alloc_locals;
    let seed = current_seed;
    
    // Generate the next random number using LCG.
    let (new_seed) = (A * seed + C) % M;
    current_seed = new_seed;

    return (new_seed,);
}

@external
func random_range{
    syscall_ptr, range_check_ptr
}(min_value: felt, max_value: felt) -> (random_number: felt) {
    alloc_locals;
    let seed = current_seed;
    
    // Generate the next random number using LCG.
    let (new_seed) = (A * seed + C) % M;
    current_seed = new_seed;

    // Map the random number to the specified range.
    let scaled_random = min_value + (new_seed % (max_value - min_value + 1));
    
    return (scaled_random,);
}

@external
func set_initial_seed{
    syscall_ptr, range_check_ptr
}(seed: felt) -> (success: felt) {
    current_seed = seed;
    return (1,);  // Success
}

@external
func get_current_seed{
    syscall_ptr, range_check_ptr
}() -> (seed: felt) {
    return (current_seed,);
}

@external
func reset_seed_to_initial{
    syscall_ptr, range_check_ptr
}() -> (success: felt) {
    current_seed = INITIAL_SEED;
    return (1,);  // Success
}

@external
func random_boolean{
    syscall_ptr, range_check_ptr
}() -> (result: felt) {
    alloc_locals;
    let seed = current_seed;
    
    // Generate the next random number using LCG.
    let (new_seed) = (A * seed + C) % M;
    current_seed = new_seed;

    // Map the random number to a boolean value.
    let is_true = new_seed % 2;
    
    return (is_true,);
}

@external
func shuffle_array{
    syscall_ptr, range_check_ptr
}(arr: felt*) -> (shuffled: felt*) {
    alloc_locals;
    let seed = current_seed;
    
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
func random_string{
    syscall_ptr, range_check_ptr
}(length: felt) -> (random_string: felt*) {
    alloc_locals;
    let seed = current_seed;
    let charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    // Generate the next random number using LCG and map it to characters in the charset.
    var result: felt* = [];
    for i in [0, length - 1] {
        let (new_seed) = (A * seed + C) % M;
        current_seed = new_seed;
        let char_index = new_seed % len(charset);
        result := [charset[char_index], ...result];
    }
    
    return (result,);
}

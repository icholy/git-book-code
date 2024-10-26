const std = @import("std");

pub fn main() !void {
    try arrays();
}

pub fn variables() !void {
    // you can use 'undefined' to avoid specifying a default value
    var x: i32 = undefined;
    try std.debug.print("Undefined i32: {d}\n", .{x});
    x = 1;

    // you can assign to _ to avoid the unused local compiler error
    const y = 123;
    _ = y; // you can't use y after doing this
}

pub fn arrays() !void {
    const ns = [4]u8{ 48, 24, 12, 6 };
    const ls = [_]f64{ 42.1, 92.2, 900 };
    // _ = ns;
    _ = ls;

    // zero based indexing
    std.debug.print("Array ns[2]: {d}\n", .{ns[2]});

    // array ranges
    const sl = ns[1..2];
    _ = sl;
}

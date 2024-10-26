const std = @import("std");

pub fn main() !void {}

pub fn variables() !void {
    // you can use 'undefined' to avoid specifying a default value
    var x: i32 = undefined;
    try std.debug.print("Undefined i32: {d}\n", .{x});
    x = 1;

    // you can assign to _ to avoid the unused local compiler error
    const y = 123;
    _ = y; // you can't use y after doing this
}

const std = @import("std");

pub fn main() !void {
    // you can use 'undefined' to avoid specifying a default value
    var x: i32 = undefined;
    std.debug.print("All your {d} are belong to us.\n", .{x});
    x = 1;

    // you can assign to _ to avoid the unused local compiler error
    const y = 123;
    _ = y;
}

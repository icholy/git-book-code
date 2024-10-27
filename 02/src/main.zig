const std = @import("std");

pub fn main() !void {}

test "if statements" {
    const x = 5;
    if (x > 10) {
        std.debug.print("x is > 10\n", .{});
    } else {
        std.debug.print("x is <= 10\n", .{});
    }
}

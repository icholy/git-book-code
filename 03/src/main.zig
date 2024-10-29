const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {}

fn input_length(input: []const u8) usize {
    return input.len;
}

test "known at compile time" {
    const name = "Ilia";
    const array = [_]u8{ 1, 2, 3, 4 };
    _ = name;
    _ = array;
}

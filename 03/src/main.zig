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

test "gpa" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const name = "Ilia";
    const output = try std.fmt.allocPrint(allocator, "Hello {s}!!!", .{name});
    try stdout.print("{s}\n", .{output});
}

test "allocate int" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const ptr = try allocator.create(i64);
    defer allocator.destroy(ptr);
    ptr.* = 123;
    try stdout.print("{d}\n", .{ptr.*});
}

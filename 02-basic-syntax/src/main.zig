const std = @import("std");
const builtin = @import("builtin");

pub fn main() !void {
    try strings();
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
    _ = ls;

    // zero based indexing
    std.debug.print("Array ns[2]: {d}\n", .{ns[2]});

    // array ranges
    const sl = ns[1..2];
    _ = sl;

    // partial range
    const all = ns[1..];
    std.debug.print("All: {any}\n", .{all});

    // array operations
    std.debug.print("Plus Plus Operator: {any}\n", .{all ++ all});
    std.debug.print("Star Star Operator: {any}\n", .{[_]i32{2} ** 5});

    // runtime slice range
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var n: usize = 0;
    if (builtin.target.os.tag == .windows) {
        n = 10;
    } else {
        n = 12;
    }
    const buffer = try allocator.alloc(u64, n);
    const slice = buffer[0..];
    std.debug.print("Value: {d}", .{slice[9]});
}

pub fn scopes() !void {
    // you can use 'break' to return values from labeled blocks.
    var y: i32 = 123;
    const x = add_one: {
        y += 1;
        break :add_one y;
    };
    if (x == 124 and y == 124) {
        std.debug.print("Hello\n", .{});
    }
}

pub fn strings() !void {}

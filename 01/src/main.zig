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

pub fn strings() !void {
    const s: []const u8 = "A string";
    std.debug.print("String: {s}\n", .{s});

    const bytes = [_]u8{ 0x48, 0x65, 0x6C, 0x6C, 0x6F };
    std.debug.print("Bytes: {s}\n", .{bytes});

    for (s) |byte| {
        std.debug.print("Byte: {X}\n", .{byte});
    }

    std.debug.print("Len: {d}\n", .{s.len});

    // a string is a pointer to an array
    const string_object = "This is a string literal";
    const simple_array = [_]i32{ 1, 2, 3, 4 };
    std.debug.print("Type of array object: {}\n", .{@TypeOf(simple_array)});
    std.debug.print("Type of string object: {}\n", .{@TypeOf(string_object)});
    std.debug.print("Type of pointer to array: {}\n", .{@TypeOf(&simple_array)});

    // unicode code points
    const chinese = "你好";
    const view = try std.unicode.Utf8View.init(chinese);
    var iterator = view.iterator();

    while (iterator.nextCodepointSlice()) |codepoint| {
        std.debug.print("Code Point: {s}\n", .{codepoint});
    }

    // useful functions
    const a = "a";
    const b = "b";
    std.debug.print("Equal: {}\n", .{std.mem.eql(u8, a, b)});
    std.debug.print("StartsWith: {}\n", .{std.mem.startsWith(u8, "fooo", "fo")});
}

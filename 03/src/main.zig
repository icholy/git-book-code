const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var input = try allocator.alloc(u8, 50);
    defer allocator.free(input);
    for (0..input.len) |i| {
        input[i] = 0;
    }
    _ = try stdin.readUntilDelimiterOrEof(input, '\n');
    try stdout.print("Input: {s}\n", .{input});
}

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

test "fixed buffer allocator" {
    var buffer: [100]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    for (0..10) |i| {
        const x = try allocator.create(f64);
        x.* = @floatFromInt(i);
    }
}

test "arena allocator" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var aa = std.heap.ArenaAllocator.init(gpa.allocator());
    defer aa.deinit();
    const allocator = aa.allocator();

    const a1 = allocator.alloc(u8, 10);
    _ = a1;
}

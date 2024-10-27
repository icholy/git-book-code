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

test "switch statements" {
    const Role = enum { SE, DPE, DE, DA, PM, PO, KS, NONE };
    var area: []const u8 = undefined;
    const role = Role.SE;
    switch (role) {
        .PM, .SE, .DPE, .PO => {
            area = "Platform";
        },
        .DE, .DA => {
            area = "Data & Analytics";
        },
        .KS => {
            area = "Sales";
        },
        else => {
            @panic("unsupported role");
        },
    }
    std.debug.print("{s}\n", .{area});
}

test "switch expression" {
    const level = 100;
    const x = switch (level) {
        1 => "one",
        2 => "two",
        3...100 => "3 - 100",
        else => @panic("invalid"),
    };
    std.debug.print("{s}\n", .{x});
}

test "defer" {
    defer std.debug.print("Existing test ...\n", .{});
    {
        defer std.debug.print("Inside block ... \n", .{});
    }
    std.debug.print("New test ...\n", .{});
}

fn foo() !void {
    return error.FooError;
}

test "errdefer" {
    var i: usize = 1;
    errdefer std.debug.print("Value of i: {d}\n", .{i});
    defer i = 2;
    // try foo();
}

test "for loop" {
    const name = "Pedro";
    for (name, 0..) |char, i| {
        std.debug.print("{d}: {c}\n", .{ i, char });
    }
}

test "while loop" {
    var i: u8 = 1;
    while (i < 3) {
        i += 1;
    }
}

test "while inline increment" {
    var i: u8 = 1;
    while (i < 5) : (i += 2) {
        std.debug.print("{d}\n", .{i});
    }
}

fn add2(x: u32) u32 {
    x = x + 2;
    return x;
}

test "cannot mutate argument" {
    // add2(2);
}

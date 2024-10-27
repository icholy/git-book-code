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
    const level = 1;
    const x = switch (level) {
        1 => "one",
        2 => "two",
        else => @panic("invalid"),
    };
    std.debug.print("{s}\n", .{x});
}
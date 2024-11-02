//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");

pub fn main() !void {
    const base64 = Base64.init();
    std.debug.print("All your {any} are belong to us.\n", .{base64});
}

const default_table = base64scale();

fn base64scale() [64]u8 {
    var scale: [64]u8 = undefined;
    for ('A'..('Z' + 1), 0..) |c, i| {
        scale[i] = @intCast(c);
    }
    for ('a'..('z' + 1), 26..) |c, i| {
        scale[i] = @intCast(c);
    }
    for ('0'..('9' + 1), 52..) |c, i| {
        scale[i] = @intCast(c);
    }
    scale[62] = '+';
    scale[63] = '/';
    return scale;
}

const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        return Base64{
            ._table = &default_table,
        };
    }
};

test "test scale" {
    const scale = base64scale();
    try std.testing.expectEqualStrings("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", &scale);
}

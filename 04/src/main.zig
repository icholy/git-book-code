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

    pub fn _char_at(self: Base64, index: u8) u8 {
        return self._table[index];
    }

    fn _calc_encode_length(input: []const u8) !usize {
        if (input.len < 3) {
            return 4;
        }
        const n_groups = try std.math.divCeil(usize, input.len, 3);
        return n_groups * 4;
    }

    fn _calc_decode_length(input: []const u8) !usize {
        if (input.len < 4) {
            return 3;
        }
        const n_output: usize = try std.math.divFloor(usize, input.len, 4);
        return n_output * 3;
    }
};

test "base64scale returns the right value" {
    const scale = base64scale();
    try std.testing.expectEqualStrings("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", &scale);
}

test "_char_at returns the right value" {
    const base64 = Base64.init();
    try std.testing.expectEqual('c', base64._char_at(28));
}

test "_calc_encode_length" {
    try std.testing.expectEqual(4, Base64._calc_encode_length(""));
    try std.testing.expectEqual(4, Base64._calc_encode_length("a"));
    try std.testing.expectEqual(8, Base64._calc_encode_length("aaaa"));
}

test "_calc_decode_length" {
    try std.testing.expectEqual(3, Base64._calc_decode_length(""));
    try std.testing.expectEqual(3, Base64._calc_decode_length("a"));
    try std.testing.expectEqual(3, Base64._calc_decode_length("aaaa"));
}

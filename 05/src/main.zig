const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Ast = std.zig.Ast;

const LaunchConfiguration = struct {
    name: *const []u8,
    type: *const []u8,
    request: *const []u8,
    program: *const []u8,
    cwd: *const []u8,
    args: *const []u8,
};

const LaunchJSON = struct {
    Version: *const []u8,
};

pub fn main() !void {
    // setup allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // read source file
    var file = try std.fs.cwd().openFile("./src/main.zig", .{});
    defer file.close();
    const source = try file.readToEndAllocOptions(allocator, std.math.maxInt(usize), null, @alignOf(u8), 0);

    // find the test names and create configurations for them
    var configurations = std.ArrayList(LaunchConfiguration).init(arena);
    var tree = try Ast.parse(allocator, source, .zig);
    const tags = tree.nodes.items(.tag);
    const datas = tree.nodes.items(.data);
    for (tree.rootDecls()) |index| {
        if (tags[index] != .test_decl) {
            continue;
        }
        const data = datas[index];
        const name = tree.tokenSlice(data.lhs);
        try configurations.append(.{
            .name = try std.fmt.allocPrint(allocator, "Run Test ({s})", .{name}),
        });
    }
    std.debug.print("{any}\n", .{try configurations.toOwnedSlice()});
}

test "foo" {
    std.debug.print("FOO\n", .{});
}

test "bar" {
    std.debug.print("BAR\n", .{});
}

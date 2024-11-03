const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Ast = std.zig.Ast;

const LaunchConfiguration = struct {
    name: ?[]const u8 = null,
    type: ?[]const u8 = null,
    request: ?[]const u8 = null,
    program: ?[]const u8 = null,
    cwd: ?[]const u8 = null,
    args: ?[]const []const u8 = null,
};

const LaunchJSON = struct {
    version: []const u8,
    configurations: []LaunchConfiguration,
};

pub fn main() !void {
    // setup allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // parse arg
    const args = try std.process.argsAlloc(allocator);
    if (args.len != 2) {
        std.debug.print("usage: {s} <filename>\n", .{args[0]});
        return error.InvalidArgs;
    }
    const filename = args[1];

    // get the cwd
    const cwd_path = try std.fs.cwd().realpathAlloc(allocator, ".");

    // read source file
    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const source = try file.readToEndAllocOptions(allocator, std.math.maxInt(usize), null, @alignOf(u8), 0);

    // find the test names and create configurations for them
    var configurations = std.ArrayList(LaunchConfiguration).init(allocator);
    var tree = try Ast.parse(allocator, source, .zig);
    const tags = tree.nodes.items(.tag);
    const datas = tree.nodes.items(.data);
    for (tree.rootDecls()) |index| {
        if (tags[index] != .test_decl) {
            continue;
        }
        const data = datas[index];
        const name = tree.tokenSlice(data.lhs);

        // remove quotes
        var unquoted = name;
        if (std.mem.startsWith(u8, unquoted, "\"")) {
            unquoted = unquoted[1..];
        }
        if (std.mem.endsWith(u8, unquoted, "\"")) {
            unquoted = unquoted[0 .. unquoted.len - 1];
        }

        // bin name
        var bin_name = try allocator.dupe(u8, unquoted);
        for (bin_name, 0..) |c, i| {
            bin_name[i] = switch (c) {
                'a'...'z', 'A'...'Z', '0'...'9' => c,
                else => '_',
            };
        }
        const bin_path = try std.fs.path.resolve(allocator, &.{ cwd_path, ".zig-cache", "tmp", bin_name });
        std.debug.print("building: {s}\n", .{bin_path});

        // compile the test binary
        const cmd = &[_][]const u8{
            "zig",
            "test",
            filename,
            "--test-no-exec",
            "--test-filter",
            unquoted,
            try std.fmt.allocPrint(allocator, "-femit-bin={s}", .{bin_path}),
        };
        var child = std.process.Child.init(cmd, allocator);
        child.stdout_behavior = .Pipe;
        child.stdout_behavior = .Pipe;
        child.stderr_behavior = .Pipe;
        child.cwd = try std.fs.cwd().realpathAlloc(allocator, ".");

        const term = try child.spawnAndWait();
        switch (term) {
            .Exited => |code| {
                if (code != 0) {
                    const formatted_cmd = try std.mem.join(allocator, " ", cmd);
                    std.debug.print("failed to build test: {s}\n", .{formatted_cmd});
                    return error.TestBuildFailed;
                }
            },
            else => {},
        }

        // add launch configuration
        try configurations.append(.{
            .name = try std.fmt.allocPrint(allocator, "Run Test: {s}", .{name}),
            .type = "lldb",
            .request = "launch",
            .cwd = "${workspaceFolder}",
            .program = try std.fmt.allocPrint(allocator, "${{workspaceFolder}}/.zig-cache/tmp/{s}", .{bin_name}),
        });
    }

    const launch = LaunchJSON{
        .version = "0.2.0",
        .configurations = try configurations.toOwnedSlice(),
    };

    try std.json.stringify(launch, .{ .whitespace = .indent_tab, .emit_null_optional_fields = false }, stdout);
}

test "foo" {
    std.debug.print("FOO\n", .{});
}

test "bar" {
    std.debug.print("BAR\n", .{});
}

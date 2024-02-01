const std = @import("std");

pub fn part1() !void {
    const file = try std.fs.cwd().openFile("input_files/day3_test.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader();

    const not_symbols = "0123456789.";

    var buf: [1024]u8 = undefined;
    var possible_previous_line: ?[buf.len]u8 = null;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        _ = line;

        if (possible_previous_line) |previous_line| {
            const new_line_index = std.mem.indexOfScalar(u8, buf[0..buf.len], '\n');

            std.debug.print("{s}", .{previous_line});

            for (previous_line[0..new_line_index.?], 0..) |character, index| {
                if (std.mem.indexOfScalar(u8, not_symbols, character) == null) {
                    // std.debug.print("{}: {c}\n", .{ index, character });
                    _ = index;
                }
            }
        }
        possible_previous_line = buf;
    }
}

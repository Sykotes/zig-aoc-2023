const std = @import("std");

const rgb = struct {
    red: u16,
    green: u16,
    blue: u16,
};

fn getSets(line: []const u8) ![]const u8 {
    var sets_start_index = std.mem.indexOfAny(u8, line, ':');
    var sets = line[sets_start_index.?..];
    return sets;
}

fn getValuesFromSet(sets: []const u8) !rgb {
    var set_end_index = std.mem.indexOfAny(u8, sets, ';');

    var set_1 = sets[0..set_end_index.?];
    _ = set_1;
    var set_2 = sets[set_end_index.? + 1 ..];
    _ = set_2;

    // a set looks like 3 blue, 4 red
    // or like 1 red, 2 green, 6 blue, 2 green
    // (not fun)
    return rgb{
        .red = 10,
        .green = 11,
        .blue = 12,
    };
}

fn calculateTotalRGB(set_1: rgb, set_2: rgb) !rgb {
    return rgb{
        .red = set_1.red + set_2.red,
        .green = set_1.green + set_2.green,
        .blue = set_1.blue + set_2.blue,
    };
}

fn isValidGame(set_total: rgb) bool {
    if (set_total.red <= 12) return false;
    if (set_total.green <= 13) return false;
    if (set_total.blue <= 14) return false;

    return true;
}

pub fn part1() !void {
    const file = try std.fs.cwd().openFile("input_files/day2.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader();

    var game_number: u16 = 0;
    _ = game_number;
    var set_1: rgb = undefined;
    _ = set_1;
    var set_2: rgb = undefined;
    _ = set_2;
    var set_total: rgb = undefined;
    _ = set_total;

    var sum: u16 = 0;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});
    }
    std.debug.print("Day2 Part1: {}", .{sum});
}

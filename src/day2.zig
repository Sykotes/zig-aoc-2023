const std = @import("std");

const rgb = struct {
    red: u16,
    green: u16,
    blue: u16,
};

const Sets = struct {
    set_1: []const u8,
    set_2: []const u8,
    set_3: []const u8,
};

fn getSets(line: []const u8) !Sets {
    var sets_start_index = std.mem.indexOfAny(u8, line, ": ");
    var sets_in_line = line[sets_start_index.?..];
    var set_first_index = std.mem.indexOfAny(u8, sets_in_line, "; ");
    var set_last_index = std.mem.lastIndexOfAny(u8, sets_in_line, "; ");

    const sets = Sets{
        .set_1 = sets_in_line[0..set_first_index.?],
        .set_2 = sets_in_line[set_first_index.?..set_last_index.?],
        .set_3 = sets_in_line[set_last_index.?..],
    };

    return sets;
}

fn getValuesFromSet(sets: Sets) !rgb {
    var split_set_1 = std.mem.split(u8, sets.set_1, ", ");
    _ = split_set_1;
    // a set is "10 red, 19 blue, 3 green"

    return rgb{
        .red = 10,
        .green = 11,
        .blue = 12,
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
    var set_total: rgb = undefined;
    _ = set_total;

    var sum: u16 = 0;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});
    }
    std.debug.print("Day2 Part1: {}", .{sum});
}

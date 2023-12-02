const std = @import("std");

const RGB = struct {
    red: u16,
    green: u16,
    blue: u16,
};

fn getSets(line: []const u8) !std.ArrayList(RGB) {
    var sets_start_index = std.mem.indexOfScalar(u8, line, ':');
    var sets_in_line = line[sets_start_index.? + 2 ..];

    const number_of_sets = std.mem.count(u8, sets_in_line, "; ") + 1;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var set_array = try std.ArrayList(RGB).initCapacity(gpa.allocator(), number_of_sets);
    errdefer set_array.deinit();

    var split_sets = std.mem.split(u8, sets_in_line, "; ");
    while (split_sets.next()) |set| {
        try set_array.append(set);
    }

    return set_array;
}

fn getTotalsFromSet(set_array: std.ArrayList(RGB)) !RGB {
    var sets_total = RGB{
        .red = 0,
        .green = 0,
        .blue = 0,
    };
    for (set_array) |set| {
        const space_index = std.mem.indexOfScalar(u8, set, ' ');
        const number_string = set[0..space_index.?];
        const number = try std.fmt.parseInt(u16, number_string, 10);

        const first_letter_of_colour = set[space_index.? + 1];
        switch (first_letter_of_colour) {
            'r' => sets_total.red += number,
            'g' => sets_total.green += number,
            'b' => sets_total.blue += number,
            else => {},
        }
    }
    return sets_total;
}

fn isValidGame(set_total: RGB) bool {
    if (set_total.red <= 12) return false;
    if (set_total.green <= 13) return false;
    if (set_total.blue <= 14) return false;

    return true;
}

pub fn part1() !void {
    const file = try std.fs.cwd().openFile("input_files/day2_test.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader();

    var game_number: u16 = 0;
    var sets: std.ArrayList(RGB) = undefined;
    var sets_total: RGB = undefined;
    var sum: u16 = 0;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        game_number += 1;

        sets = try getSets(line);
        sets_total = try getTotalsFromSet(sets);

        if (isValidGame(sets_total)) sum += game_number;
    }
    std.debug.print("Day2 Part1: {}\n", .{sum});
}

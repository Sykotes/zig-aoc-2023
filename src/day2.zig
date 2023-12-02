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
    var sets_start_index = std.mem.indexOfScalar(u8, line, ':');
    std.log.info("{}\n", .{sets_start_index.?});
    var sets_in_line = line[sets_start_index.? + 2 ..];
    std.log.info("{s}", .{sets_in_line});
    var set_first_index = std.mem.indexOfScalar(u8, sets_in_line, ';');
    var set_last_index = std.mem.lastIndexOfScalar(u8, sets_in_line, ';');

    const sets = Sets{
        .set_1 = sets_in_line[0..set_first_index.?],
        .set_2 = sets_in_line[set_first_index.? + 2 .. set_last_index.?],
        .set_3 = sets_in_line[set_last_index.? + 2 ..],
    };
    std.log.info("{}\n", .{set_first_index.?});
    std.log.info("{}\n", .{set_last_index.?});

    std.log.info("{s}\n", .{sets.set_1});
    std.log.info("{s}\n", .{sets.set_2});
    std.log.info("{s}\n", .{sets.set_3});

    return sets;
}

fn getValuesFromSet(set: []const u8) !rgb {
    var set_rgb = rgb{
        .red = 0,
        .green = 0,
        .blue = 0,
    };

    var split_set = std.mem.split(u8, set, ", ");
    while (split_set.next()) |colour| {
        _ = colour;
        // const space_index = std.mem.indexOfScalar(u8, colour, ' ');
        // const number_string = colour[0..space_index.?];
        // const number = try std.fmt.parseInt(u16, number_string, 10);

        // const first_letter_of_colour = colour[space_index.? + 1];
        // switch (first_letter_of_colour) {
        //     'r' => set_rgb.red = number,
        //     'g' => set_rgb.green = number,
        //     'b' => set_rgb.blue = number,
        //     else => {},
        // }
    }
    return set_rgb;
}

fn isValidGame(set_total: rgb) bool {
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
    var sets = Sets{
        .set_1 = undefined,
        .set_2 = undefined,
        .set_3 = undefined,
    };

    var set_1_values = rgb{ .red = undefined, .green = undefined, .blue = undefined };
    var set_2_values = rgb{ .red = undefined, .green = undefined, .blue = undefined };
    _ = set_2_values;
    var set_3_values = rgb{ .red = undefined, .green = undefined, .blue = undefined };
    _ = set_3_values;
    var set_total: rgb = undefined;
    _ = set_total;

    var sum: u16 = 0;
    _ = sum;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        game_number += 1;
        sets = try getSets(line);

        set_1_values = try getValuesFromSet(sets.set_1);
    }
    // std.debug.print("Day2 Part1: {}\n", .{sum});
}

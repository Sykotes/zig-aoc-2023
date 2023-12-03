const std = @import("std");

const Set = struct {
    r: u8,
    g: u8,
    b: u8,
};

fn getSetsString(line: []const u8) ![]const u8 {
    const sets_start_index_maybe: ?usize = std.mem.indexOfScalar(u8, line, ':');
    const sets_string = line[sets_start_index_maybe.? + 2 ..];

    return sets_string;
}

fn getSets(sets_string: []const u8) !std.ArrayList(Set) {
    var sets_string_iter = std.mem.split(u8, sets_string, "; ");
    var list_of_sets: std.ArrayList(Set) = std.ArrayList(Set).init(std.heap.page_allocator);

    while (sets_string_iter.next()) |set_string| {
        var set = Set{
            .r = 0,
            .g = 0,
            .b = 0,
        };

        const index_of_space_maybe = std.mem.indexOfScalar(u8, set_string, ' ');
        const string_of_number = set_string[0..index_of_space_maybe.?];
        const number = try std.fmt.parseInt(u8, string_of_number, 10);

        const first_letter_of_colour = set_string[index_of_space_maybe.? + 1];
        switch (first_letter_of_colour) {
            'r' => set.r = number,
            'g' => set.b = number,
            'b' => set.b = number,
            else => {},
        }

        try list_of_sets.append(set);
    }

    return list_of_sets;
}

fn addUpSetValues(list_of_sets: std.ArrayList(Set)) Set {
    var total_set = Set{
        .r = 0,
        .g = 0,
        .b = 0,
    };
    for (list_of_sets.items) |set| {
        total_set.r += set.r;
        total_set.g += set.g;
        total_set.b += set.b;
    }

    return total_set;
}

fn isValidGame(total_set: Set) bool {
    if (total_set.r > 12) return false;
    if (total_set.g > 13) return false;
    if (total_set.b > 14) return false;
    return true;
}

pub fn part1() !void {
    const file = try std.fs.cwd().openFile("input_files/day2_test.txt", .{});
    defer file.close();

    var game_id: u8 = 0;
    var list_of_sets: std.ArrayList(Set) = undefined;
    var sets_string: []const u8 = undefined;
    var total_set: Set = undefined;
    var sum: u32 = 0;

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        game_id += 1;

        sets_string = try getSetsString(line);
        list_of_sets = try getSets(sets_string);
        total_set = addUpSetValues(list_of_sets);

        if (isValidGame(total_set)) {
            std.debug.print("Game {} is valid!\n", .{game_id});
            std.debug.print("Total set:\nRed: {}\nGreen {}\nBlue: {}\n", .{ total_set.r, total_set.g, total_set.b });
            sum += game_id;
        }
    }
    std.debug.print("Day2 Part1: {}\n", .{sum});
}

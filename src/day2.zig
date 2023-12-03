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
        var item_string_iter = std.mem.split(u8, set_string, ", ");
        while (item_string_iter.next()) |item| {
            var set = Set{
                .r = 0,
                .g = 0,
                .b = 0,
            };

            const index_of_space_maybe = std.mem.indexOfScalar(u8, item, ' ');
            const string_of_number = item[0..index_of_space_maybe.?];
            const number = try std.fmt.parseInt(u8, string_of_number, 10);

            const first_letter_of_colour = item[index_of_space_maybe.? + 1];
            switch (first_letter_of_colour) {
                'r' => set.r = number,
                'g' => set.g = number,
                'b' => set.b = number,
                else => {},
            }
            try list_of_sets.append(set);
        }
    }

    return list_of_sets;
}

fn isValidGame(list_of_sets: std.ArrayList(Set)) bool {
    for (list_of_sets.items) |set| {
        if (set.r > 12) return false;
        if (set.g > 13) return false;
        if (set.b > 14) return false;
    }
    return true;
}

pub fn part1() !void {
    const file = try std.fs.cwd().openFile("input_files/day2.txt", .{});
    defer file.close();

    var game_id: u16 = 0;
    var list_of_sets: std.ArrayList(Set) = undefined;
    var sets_string: []const u8 = undefined;
    var total_set: Set = undefined;
    _ = total_set;
    var is_valid_game = false;
    _ = is_valid_game;
    var sum: u32 = 0;

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        game_id += 1;

        sets_string = try getSetsString(line);
        list_of_sets = try getSets(sets_string);

        if (isValidGame(list_of_sets)) sum += game_id;
    }
    std.debug.print("Day2 Part1: {}\n", .{sum});
}

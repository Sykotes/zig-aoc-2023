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
    _ = list_of_sets;

    while (sets_string_iter.next()) |set| {
        _ = set;
    }
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
    }
    std.debug.print("Day2 Part1: {}\n", .{sum});
}

const std = @import("std");

pub fn part1() !void {
    const file = try std.fs.cwd().openFile("input_files/day1.txt", .{ .mode = .read_only });
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader();

    var nums = [_]u8{ 0, 0 };
    var num_count: u16 = 0;
    var number: u16 = undefined;
    var total: u16 = 0;

    var buffer: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        nums = [_]u8{ 0, 0 };
        num_count = 0;

        for (line) |c| {
            if (c >= '0' and c <= '9') {
                num_count += 1;
                nums[1] = c;
            }
        }

        if (num_count < 2) {
            nums[0] = nums[1];
        } else {
            for (line) |c| {
                if (c >= '0' and c <= '9') {
                    nums[0] = c;
                    break;
                }
            }
        }

        number = try std.fmt.parseInt(u16, &nums, 10);
        total += number;
    }
    std.debug.print("{}\n", .{total});
}

// a lot of this was "borrowed" from https://github.com/applejag/adventofcode-2023-zig/
pub fn part2() !void {
    const file = try std.fs.cwd().openFile("input_files/day1.txt", .{ .mode = .read_only });
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader();

    const digit_chars = "0123456789";

    const Digit = struct {
        name: []const u8,
        value: u8,
    };

    const digits = [_]Digit{
        Digit{ .name = "zero", .value = 0 },
        Digit{ .name = "one", .value = 1 },
        Digit{ .name = "two", .value = 2 },
        Digit{ .name = "three", .value = 3 },
        Digit{ .name = "four", .value = 4 },
        Digit{ .name = "five", .value = 5 },
        Digit{ .name = "six", .value = 6 },
        Digit{ .name = "seven", .value = 7 },
        Digit{ .name = "eight", .value = 8 },
        Digit{ .name = "nine", .value = 9 },
    };

    var possible_char_index: ?usize = null;
    var possible_name_index: ?usize = null;
    var name_value: u8 = 0;

    var first_digit: u8 = undefined;
    var second_digit: u8 = undefined;

    var number: u32 = undefined;
    var total: u32 = 0;

    var buffer: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        number = 0;
        first_digit = undefined;
        second_digit = undefined;

        possible_char_index = null;
        possible_name_index = null;
        name_value = 0;
        possible_char_index = std.mem.indexOfAny(u8, line, digit_chars);

        for (digits) |digit| {
            const index = std.mem.indexOf(u8, line, digit.name);
            if (index) |i| {
                if (possible_name_index == null or i < possible_name_index.?) {
                    possible_name_index = i;
                    name_value = digit.value;
                }
            }
        }

        if (possible_char_index) |char_index| {
            if (possible_name_index) |name_index| {
                if (name_index < char_index) {
                    first_digit = name_value;
                } else {
                    first_digit = line[char_index] - '0';
                }
            } else {
                first_digit = line[char_index] - '0';
            }
        } else if (possible_name_index) |_| {
            first_digit = name_value;
        }

        possible_char_index = std.mem.lastIndexOfAny(u8, line, digit_chars);

        for (digits) |digit| {
            const index = std.mem.lastIndexOf(u8, line, digit.name);
            if (index) |i| {
                if (possible_name_index == null or i > possible_name_index.?) {
                    possible_name_index = i;
                    name_value = digit.value;
                }
            }
        }

        if (possible_char_index) |char_index| {
            if (possible_name_index) |name_index| {
                if (name_index > char_index) {
                    second_digit = name_value;
                } else {
                    second_digit = line[char_index] - '0';
                }
            } else {
                second_digit = line[char_index] - '0';
            }
        } else if (possible_name_index) |_| {
            second_digit = name_value;
        }

        number = first_digit * 10 + second_digit;
        total += number;
    }
    std.debug.print("Total: {}\n", .{total});
}

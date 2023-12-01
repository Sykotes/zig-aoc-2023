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

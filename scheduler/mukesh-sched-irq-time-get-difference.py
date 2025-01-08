#! /usr/bin/python
import argparse

def parse_file(file_path):
    data = {}
    with open(file_path, 'r') as file:
        for line in file:
            if ':' in line:
                key, value = line.split(':')
                data[key.strip()] = int(value.strip().split()[0])  # Convert value to integer
    return data

def calculate_diff(file1_data, file2_data):
    diff = {}
    for key in file1_data:
        if key in file2_data:
            diff[key] = file2_data[key] - file1_data[key]
    return diff

def print_diff(diff):
    for key, value in diff.items():
        #print(f"{key}     : {value} ns")
        ms_value = value / 1_000_000  # Convert to milliseconds
        sec_value = value / 1_000_000_000  # Convert to seconds
        print(f"{key:<10} : {value:>15} ns | {ms_value:>15.3f} ms | {sec_value:>15.3f} s")  # Left-align key, right-align value and ms

def main():
    parser = argparse.ArgumentParser(description="Calculate the difference between two files in the specified format.")
    parser.add_argument("file1", help="Path to the first file")
    parser.add_argument("file2", help="Path to the second file")

    args = parser.parse_args()

    file1_data = parse_file(args.file1)
    file2_data = parse_file(args.file2)

    diff = calculate_diff(file1_data, file2_data)

    print("\nDifferences between the two files:")
    print_diff(diff)

if __name__ == "__main__":
    main()


import sys
import re

def parse_perf_data(file_path):
    with open(file_path, 'r') as file:
        content = file.read()

    # Split the content into sections for each run
    sections = content.strip().split('Usage:')
    
    # Define a list to hold the parsed data
    data = []

    for section in sections:
        # Extract relevant data using regex
        records = re.findall(r'Total records/s: ([\d,\.]+)', section)
        instructions = re.findall(r'(\d[\d,]*)\s+instructions', section)
        cpu_clock = re.findall(r'(\d[\d,]*)\s+msec cpu-clock', section)
        cycles = re.findall(r'(\d[\d,]*)\s+cycles', section)
        cache_misses = re.findall(r'(\d[\d,]*)\s+cache-misses', section)
        
        # If there are valid records, append them to data list
        if records and instructions and cpu_clock and cycles and cache_misses:
            data.append([
                records[0].replace(',', ''),
                instructions[0].replace(',', ''),
                cpu_clock[0].replace(',', ''),
                cycles[0].replace(',', ''),
                cache_misses[0].replace(',', '')
            ])
    
    return data

def format_markdown_table(data):
    # Create Markdown table header
    header = "| Total Records/s | Instructions | CPU Clock (ms) | Cycles | Cache Misses |\n"
    separator = "| --- | --- | --- | --- | --- |\n"
    
    # Create the table rows
    rows = []
    for row in data:
        rows.append(f"| {row[0]} | {row[1]} | {row[2]} | {row[3]} | {row[4]} |")
    
    return header + separator + '\n'.join(rows)

def main():
    if len(sys.argv) != 2:
        print("Usage: python parse_perf_data.py <file_path>")
        sys.exit(1)

    file_path = sys.argv[1]
    data = parse_perf_data(file_path)
    
    if not data:
        print("No valid data found in the file.")
        return
    
    markdown_table = format_markdown_table(data)
    print(markdown_table)

if __name__ == "__main__":
    main()


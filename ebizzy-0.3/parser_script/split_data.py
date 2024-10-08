import sys
import re

def split_list_of_dicts_by_core_sched(data):
    """
    Split a list of dictionaries into two lists based on the 'Core Sched' value.
    
    Parameters:
        data (list): The list of dictionaries to split.
    
    Returns:
        tuple: Two lists: one for 'Enabled' and one for 'Disabled'.
    """
    enabled_list = []
    disabled_list = []
    
    for item in data:
        # Check if 'Core Sched' key exists in the current dictionary
        if 'Core Sched' in item:
            core_sched = item['Core Sched'] == 'Enabled'
            item.pop('Core Sched', None)
            if core_sched:
                enabled_list.append(item)
            else:
                if(item['SMT'] == 'SMT' or item['SMT'] == 'SMT-2'):
                    enabled_list.append(item)
                disabled_list.append(item)
    
    return enabled_list, disabled_list

def parse_performance_section(section):
    metrics = {
        'Core Sched': None,
        'SMT': None,
        'Records/sec': None,
        'Instructions per cycle': None,
        'L1-icache-load-misses': None,
        'L1-dcache-load-misses': None,
        'LLC-load-misses': None,
        'LLC-store-misses': None,
        'Cache-misses': None,
        'PM_exec_stall': None
    }
    
    # Regex patterns to extract relevant metrics
    patterns = {
        'Core Sched': r'Core Sched:\s*(\w+)',
        'SMT': r'(SMT\S*)',
        'Records/sec': r'Total records/s:\s*([\d,\.]+)',
        'Instructions per cycle': r'(\d[\d,]*)\s+instructions\s+#\s+(\d+\.\d+)\s+insn per cycle',
        'L1-icache-load-misses': r'(\d[\d,]*)\s+L1-icache-load-misses\s+#\s+(\d+\.\d+)% of all L1-icache accesses',
        'L1-dcache-load-misses': r'(\d[\d,]*)\s+L1-dcache-load-misses\s+#\s+(\d+\.\d+)% of all L1-dcache accesses',
        'LLC-load-misses': r'(\d[\d,]*)\s+LLC-load-misses\s+#\s+(\d+\.\d+)% of all LL-cache accesses',
#        'LLC-store-misses': r'(\d[\d,]*)\s+LLC-store-misses\s+#\s+([\d.]+)\s+(?:K|M)?/sec',
        'LLC-store-misses': r'LLC-store-misses\s+#\s*(.*?/sec)',
        'Cache-misses': r'(\d[\d,]*)\s+cache-misses\s+#\s+(\d+\.\d+)% of all cache refs',
        'PM_exec_stall': r'pm_exec_stall\s+#\s*(.*?/sec)',
    }
    
    for metric, pattern in patterns.items():
        match = re.search(pattern, section)
        if match:
            if metric in ['Instructions per cycle', 'L1-icache-load-misses', 'L1-dcache-load-misses', 
                          'LLC-load-misses', 'Cache-misses', 'PM_exec_stall (G/sec)']:
                metrics[metric] = match.group(2)  # Capture the second group for percentage values
            else:
                metrics[metric] = match.group(1)  # Capture the first group for direct values

    return metrics

def get_md_table(data):
    if not data:
        return "No data available."

    # Extract the SMT values as the headers
    smt_values = [item['SMT'] for item in data]  # Include 'None' for the first column
    # Extract the metric names from the keys (excluding 'SMT')
    metrics = list(data[0].keys())
    metrics.remove('SMT')  # Remove 'SMT' from metrics since it's already included as headers

    # Create the header row
    headers = '| Metrics | ' + ' | '.join(smt_values) + ' |'
    # Create the separator row
    separator = '| --- | ' + ' | '.join(['---'] * len(smt_values)) + ' |'

    # Create the data rows
    rows = []
    for metric in metrics:
        row = '| ' + metric + ' | ' + ' | '.join(str(item[metric]) for item in data) + ' |'
        rows.append(row)

    # Combine all parts into the final Markdown table
    markdown_table = f"{headers}\n{separator}\n" + "\n".join(rows)
    return markdown_table

def get_md_table_t(data):
    if not data:
        return "No data available."

    # Extract the headers from the first dictionary
    headers = '| ' + ' | '.join(data[0].keys()) + ' |'
    # Create the separator row
    separator = '| ' + ' | '.join(['---'] * len(data[0])) + ' |'
    
    # Create the data rows
    rows = []
    for item in data:
        row = '| ' + ' | '.join(map(str, item.values())) + ' |'
        rows.append(row)
    
    # Combine all parts into the final Markdown table
    markdown_table = f"{headers}\n{separator}\n" + "\n".join(rows)
    return markdown_table  

def format_performance_data(sections):
    # Initialize a list to store the parsed metrics for each section
    all_metrics = []
    
    for section in sections:
        # Parse each section to extract performance metrics
        metrics = parse_performance_section(section)
        all_metrics.append(metrics)
    enabled_list, disabled_list = split_list_of_dicts_by_core_sched(all_metrics)
    return "Core Sched Enabled:\n" + get_md_table(enabled_list) + "\n\nCore Sched Disabled:\n" + get_md_table(disabled_list)

def clean_data(input_text):
    # Split the input text into lines
    lines = input_text.strip().split('\n')
    
    # Initialize an empty list to collect relevant lines
    relevant_lines = []
    
    # Flag to track whether we are within the *** sections
    in_asterisk_section = False
    
    # Flag to track performance stats section
    in_perf_stats_section = False

    for line in lines:
        # Check if the line contains the asterisk section start or end
        if line.startswith('*************************************************************************'):
            in_asterisk_section = not in_asterisk_section
            relevant_lines.append(line)  # Always include the asterisk line
            continue
        
        # If we are within the asterisk section, add the line to relevant lines
        if in_asterisk_section:
            relevant_lines.append(line)
        # If the line contains "Performance counter stats", add it and the following lines
        elif "Performance counter stats for" in line:
            relevant_lines.append(line)
            in_perf_stats_section = True  # Start gathering performance stats
        # If we are in the performance stats section, add the line
        elif in_perf_stats_section:
            # Stop if we encounter the line indicating time elapsed
            if 'seconds sys' in line:
                relevant_lines.append(line)
                break  # Exit after including the time elapsed line
            relevant_lines.append(line)

    return '\n'.join(relevant_lines)

def split_perf_data(file_path):
    with open(file_path, 'r') as file:
        content = file.read()

    # Split the content into sections based on the delimiter "Running warmup"
    sections = content.strip().split('Running warmup')

    # Find the first section with "Running warmup" and keep only those sections
    if len(sections) > 1:
        valid_sections = [f"Running warmup{s}" for s in sections[1:]]  # Skip the part before the first "Running warmup"
    else:
        valid_sections = []

    return valid_sections

def main():
    if len(sys.argv) != 2:
        print("Usage: python split_perf_data.py <file_path>")
        sys.exit(1)

    file_path = sys.argv[1]
    sections = split_perf_data(file_path)
    clean_sections = []
    # Print the sections stored in the list
    for i, section in enumerate(sections):
        clean_sections.append(clean_data(section))
    sections = clean_sections

    output = format_performance_data(sections)
    print(output)

if __name__ == "__main__":
    main()


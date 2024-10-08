def convert_performance_data(data):
    # Initialize the structure to hold results
    result = {
        'Metric': ['Records/sec', 'Instructions per cycle', 'L1-icache-load-misses',
                   'L1-dcache-load-misses', 'LLC-load-misses', 
                   'LLC-store-misses (M/sec)', 'Cache-misses', 'PM_exec_stall (G/sec)'],
        'ST (Off)': [0] * 8,
        'SMT-2': [0] * 8,
        'SMT-4': [0] * 8,
        'SMT-6': [0] * 8,
        'SMT-8': [0] * 8
    }

    # Aggregate data
    disabled_data = {}
    enabled_data = {}

    for entry in data:
        core_sched = entry['Core Sched']
        smt = entry['SMT']
        
        for metric in result['Metric']:
            if metric not in entry:
                continue

            value = float(entry[metric].replace(',', ''))
            if core_sched == 'Disabled':
                if smt is None:
                    if metric not in disabled_data:
                        disabled_data[metric] = []
                    disabled_data[metric].append(value)
                else:
                    if smt not in disabled_data:
                        disabled_data[smt] = {}
                    if metric not in disabled_data[smt]:
                        disabled_data[smt][metric] = []
                    disabled_data[smt][metric].append(value)
            elif core_sched == 'Enabled':
                if smt not in enabled_data:
                    enabled_data[smt] = {}
                if metric not in enabled_data[smt]:
                    enabled_data[smt][metric] = []
                enabled_data[smt][metric].append(value)

    # Calculate averages for Disabled
    result['ST (Off)'][0] = sum(disabled_data[metric]) / len(disabled_data[metric]) for metric in result['Metric']

    # Calculate averages for SMT values
    for smt in ['2', '4', '6', '8']:
        if smt in disabled_data:
            for i, metric in enumerate(result['Metric']):
                if metric in disabled_data[smt]:
                    result[f'SMT-{smt}'][i] = sum(disabled_data[smt][metric]) / len(disabled_data[smt][metric])
    
    # Calculate averages for Enabled (using the same SMT as Disabled)
    for smt in ['4', '6', '8']:
        if smt in enabled_data:
            for i, metric in enumerate(result['Metric']):
                result[f'SMT-{smt}'][i] = sum(enabled_data[smt][metric]) / len(enabled_data[smt][metric])
    
    # Format percentages for load misses
    for i in range(len(result['Metric'])):
        if 'load-misses' in result['Metric'][i] or 'Cache-misses' in result['Metric'][i]:
            result['ST (Off)'][i] *= 100
            result['ST (Off)'][i] = f"{result['ST (Off)'][i]:.2f}%"
            for smt in ['2', '4', '6', '8']:
                result[f'SMT-{smt}'][i] *= 100
                result[f'SMT-{smt}'][i] = f"{result[f'SMT-{smt}'][i]:.2f}%"
        else:
            for smt in ['2', '4', '6', '8']:
                result[f'SMT-{smt}'][i] = f"{result[f'SMT-{smt}'][i]:.2f}"

    # Print the result in the desired format
    print("| Metric                   | ST (Off)   | SMT-2      | SMT-4      | SMT-6      | SMT-8      |")
    print("|--------------------------|-------------|-------------|-------------|-------------|-------------|")
    for i in range(len(result['Metric'])):
        print(f"| {result['Metric'][i]:<24} | {result['ST (Off)'][i]:<11} | {result['SMT-2'][i]:<11} | "
              f"{result['SMT-4'][i]:<11} | {result['SMT-6'][i]:<11} | {result['SMT-8'][i]:<11} |")

# Example usage
data = [
    {'Core Sched': 'Disabled', 'SMT': None, 'Records/sec': '5,767,337.71', 'Instructions per cycle': '2.56', 'L1-icache-load-misses': '0.02', 'L1-dcache-load-misses': '0.82', 'LLC-load-misses': '0.01', 'LLC-store-misses (M/sec)': '18,15,57,19,239', 'Cache-misses': '0.82', 'PM_exec_stall (G/sec)': '1.264'},
    {'Core Sched': 'Disabled', 'SMT': '2', 'Records/sec': '11,463,601.93', 'Instructions per cycle': '2.56', 'L1-icache-load-misses': '0.00', 'L1-dcache-load-misses': '0.82', 'LLC-load-misses': '0.01', 'LLC-store-misses (M/sec)': '36,64,37,29,491', 'Cache-misses': '0.82', 'PM_exec_stall (G/sec)': '1.272'},
    {'Core Sched': 'Disabled', 'SMT': '4', 'Records/sec': '11,373,529.52', 'Instructions per cycle': '2.55', 'L1-icache-load-misses': '0.00', 'L1-dcache-load-misses': '0.82', 'LLC-load-misses': '0.01', 'LLC-store-misses (M/sec)': '36,61,02,14,890', 'Cache-misses': '0.82', 'PM_exec_stall (G/sec)': '1.267'},
    {'Core Sched': 'Enabled', 'SMT': '4', 'Records/sec': '11,424,901.17', 'Instructions per cycle': '2.56', 'L1-icache-load-misses': '0.00', 'L1-dcache-load-misses': '0.98', 'LLC-load-misses': '0.01', 'LLC-store-misses (M/sec)': '36,67,09,26,520', 'Cache-misses': '0.98', 'PM_exec_stall (G/sec)': '1.265'},
    {'Core Sched': 'Disabled', 'SMT': '6', 'Records/sec': '11,434,560.80', 'Instructions per cycle': '2.58', 'L1-icache-load-misses': '0.00', 'L1-dcache-load-misses': '0.82', 'LLC-load-misses': '0.01', 'LLC-store-misses (M/sec)': '36,92,35,56,870', 'Cache-misses': '0.82', 'PM_exec_stall (G/sec)': '1.261'},
    {'Core Sched': 'Enabled', 'SMT': '6', 'Records/sec': '11,439,064.89', 'Instructions per cycle': '2.57', 'L1-icache-load-misses': '0.00', 'L1-dcache-load-misses': '0.82', 'LLC-load-misses': '0.01', 'LLC-store-misses (M/sec)': '36,87,68,38,800', 'Cache-misses': '0.82', 'PM_exec_stall (G/sec)': '1.254'},
    {'Core Sched': 'Disabled', 'SMT': '8', 'Records/sec': '11,517,101.38', 'Instructions per cycle': '2.58', 'L1-icache-load-misses': '0.00', 'L1-dcache-load-misses': '0.82', 'LLC-load-misses': '0.01', 'LLC-store-misses (M/sec)': '36,97,50,25,188', 'Cache-misses': '0.82', 'PM_exec_stall (G/sec)': '1.252'},
    {'Core Sched': 'Enabled', 'SMT': '8', 'Records/sec': '11,126,926.86', 'Instructions per cycle': '2.52', 'L1-icache-load-misses': '0.00', 'L1-dcache-load-misses': '0.82', 'LLC-load-misses': '0.01', 'LLC-store-misses (M/sec)': '36,23,63,31,240', 'Cache-misses': '0.81', 'PM_exec_stall (G/sec)': '1.285'},
]

# Call the function to print the result
convert_performance_data(data)


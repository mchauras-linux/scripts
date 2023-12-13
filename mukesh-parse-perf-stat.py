#! /usr/bin/python3

import os
import sys
import matplotlib.pyplot as plt

def plot_2d_graph(data_points, x_label='X-axis', y_label='Y-axis', graph_title='2D Graph from Data'):
    try:
        # Extract x and y values from the list of tuples
        x_values = [point[0] for point in data_points]
        y_values = [point[1] for point in data_points]

        # Plotting the graph
        plt.figure(figsize=(8, 6))  # Adjust figure size if needed
        plt.scatter(x_values, y_values, color='blue', label='Data Points')  # Scatter plot of x and y values
        plt.xlabel(x_label)
        plt.ylabel(y_label)
        plt.title(graph_title)
        plt.legend()
        plt.grid(True)
        plt.show()

    except Exception as e:
        print(f"An error occurred: {e}")

def read_files_in_directory(directory_path):
    try:
        # List all files in the directory
        files = os.listdir(directory_path)

        # Iterate through each file
        for file_name in files:
            file_path = os.path.join(directory_path, file_name)

            # Check if the path is a file
            if os.path.isfile(file_path):
                print(f"Reading contents of {file_name}:")
                with open(file_path, 'r') as file:
                    content = file.read()
                    print(content)  # Do whatever processing you need here with the file content
    except FileNotFoundError:
        print(f"Directory '{directory_path}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py /path/to/directory")
        sys.exit(1)

    directory_path = sys.argv[1]
    read_files_in_directory(directory_path)


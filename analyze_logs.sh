#!/bin/bash

# Default log file and output file
LOG_FILE=${1:-logs.txt}  # If no log file is provided, default to logs.txt
OUTPUT_FILE=${2:-output.txt}  # Default output file is output.txt

# Ensure the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
  echo "Log file '$LOG_FILE' not found!"
  exit 1
fi

# Function to display top N results
top_n() {
  echo -e "\nTop 5 $1:"
  # Filter log data and get top 5 items
  awk "$2" "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
}

# 1. Exclude automated probes (e.g., DigitalOcean Uptime Probe)
echo "Filtering out automated probes like DigitalOcean Uptime Probe..."

# Top 5 IP addresses with the most requests
top_n "IP addresses with the most requests" '{print $1}'

# Top 5 most requested paths
top_n "most requested paths" '{print $7}'

# Top 5 response status codes
top_n "response status codes" '{print $9}'

# Top 5 user agents (exclude automated probes)
top_n "user agents" '{print $12}' | grep -v "DigitalOcean Uptime Probe" 

# Save the output to a file
echo "Results have been saved to $OUTPUT_FILE."


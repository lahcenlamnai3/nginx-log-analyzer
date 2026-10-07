#!/bin/bash
log_file=$1
if [[ ! -f "$log_file" ]];then
    echo "Error: file not found"
    exit 1
fi
echo "Top 5 IP addresses with the most requests:"
awk '{ip_count[$1]++} END {
    for (ip in ip_count)
    print ip_count[ip], ip
}' "$log_file" | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
echo ""

echo "Top 5 most requested paths:"
awk '{path_count[$7]++} END {
    for (path in path_count)
    print path_count[path], path
}' "$log_file" | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'

echo ""
echo "Top 5 response status codes:"
awk '{code_count[$9]++} END {
    for (code in code_count)
    print code_count[code], code
}' "$log_file" | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'

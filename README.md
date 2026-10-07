# Nginx Log Analyzer

A simple Bash script that analyzes an Nginx access log and displays the **Top 5**:

* IP addresses with the most requests
* Most requested paths
* Most common HTTP response status codes

The project is built using **Bash**, **AWK**, **sort**, and **head**.

---

## 📌 Features

The script analyzes an Nginx access log and extracts three types of information:

### 1. Top 5 IP addresses

The script counts how many requests were made by each IP address.

Example:

```text
Top 5 IP addresses with the most requests:
178.128.94.113 - 1087 requests
142.93.136.176 - 1087 requests
138.68.248.85 - 1087 requests
159.89.185.30 - 1086 requests
86.134.118.70 - 277 requests
```

### 2. Top 5 most requested paths

The script counts how many times each URL path was requested.

Example:

```text
Top 5 most requested paths:
/v1-health - 4560 requests
/ - 270 requests
/v1-me - 232 requests
/v1-list-workspaces - 127 requests
/v1-list-timezone-teams - 75 requests
```

### 3. Top 5 HTTP response status codes

The script counts the occurrences of each HTTP response status code.

Example:

```text
Top 5 response status codes:
200 - 5740 requests
404 - 937 requests
304 - 621 requests
400 - 192 requests
"-" - 31 requests
```

---

## 📂 Project Structure

```text
nginx-log-analyzer/
│
├── analyser.sh
├── README.md
└── nginx-access.log.txt
```

The log file is not required to be inside the project directory. You can provide its path as an argument when running the script.

---

## 📋 Nginx Log Format

The script expects a standard Nginx access log format.

A typical log line looks like:

```text
178.128.94.113 - - [04/Oct/2024:00:00:18 +0000] "GET /v1-health HTTP/1.1" 200 51 "-" "Mozilla/5.0"
```

AWK splits each line into fields based on spaces.

For example:

```text
$1 → IP address
$7 → Requested path
$9 → HTTP response status code
```

The script uses these fields to perform the analysis.

---

## ⚙️ How It Works

### 1. Check if the log file exists

The script first receives the log file as an argument:

```bash
log_file=$1
```

Then it checks whether the file exists:

```bash
if [[ ! -f "$log_file" ]]; then
    echo "Error: file not found"
    exit 1
fi
```

If the file does not exist, the script stops and displays an error.

---

### 2. Count requests by IP address

The following AWK command counts the number of requests for each IP:

```bash
awk '{ip_count[$1]++} END {
    for (ip in ip_count)
        print ip_count[ip], ip
}' "$log_file"
```

The important part is:

```bash
ip_count[$1]++
```

Here:

* `$1` is the first field of the line, which is the IP address.
* `ip_count` is an associative array.
* `++` increments the counter by 1.

For example:

```text
178.128.94.113
178.128.94.113
142.93.136.176
178.128.94.113
```

becomes:

```text
178.128.94.113 → 3
142.93.136.176 → 1
```

The result is then sorted:

```bash
sort -nr
```

where:

* `-n` = numerical sorting
* `-r` = reverse order

Finally:

```bash
head -n 5
```

keeps only the five highest values.

---

### 3. Count requested paths

The script uses the same approach for requested URLs:

```bash
awk '{path_count[$7]++} END {
    for (path in path_count)
        print path_count[path], path
}' "$log_file"
```

Here:

```text
$7 = requested path
```

For example:

```text
/v1-health
/
/v1-health
/v1-me
/v1-health
```

produces:

```text
/v1-health → 3
/           → 1
/v1-me      → 1
```

---

### 4. Count HTTP status codes

The script uses:

```bash
awk '{code_count[$9]++} END {
    for (code in code_count)
        print code_count[code], code
}' "$log_file"
```

Here:

```text
$9 = HTTP response status code
```

For example:

```text
200
200
404
200
304
```

produces:

```text
200 → 3
404 → 1
304 → 1
```

---

## ▶️ How to Run

### 1. Clone the repository

```bash
git clone <YOUR_REPOSITORY_URL>
cd nginx-log-analyzer
```

### 2. Give execution permission

```bash
chmod +x analyser.sh
```

### 3. Run the script

Pass the Nginx log file as the first argument:

```bash
./analyser.sh /path/to/nginx-access.log
```

For example:

```bash
./analyser.sh nginx-access.log.txt
```

---

## 💻 Example

Running:

```bash
./analyser.sh nginx-access.log.txt
```

produces:

```text
Top 5 IP addresses with the most requests:
178.128.94.113 - 1087 requests
142.93.136.176 - 1087 requests
138.68.248.85 - 1087 requests
159.89.185.30 - 1086 requests
86.134.118.70 - 277 requests

Top 5 most requested paths:
/v1-health - 4560 requests
/ - 270 requests
/v1-me - 232 requests
/v1-list-workspaces - 127 requests
/v1-list-timezone-teams - 75 requests

Top 5 response status codes:
200 - 5740 requests
404 - 937 requests
304 - 621 requests
400 - 192 requests
"-" - 31 requests
```
---
## Project URL

https://roadmap.sh/projects/nginx-log-analyser
---

## 📄 License

This project is available for educational and personal use.

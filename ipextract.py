import re

# Function to extract unique IPs from an HTML file
def extract_ips_from_html(file_path):
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
        content = file.read()

    # Extract IPs using regex
    ip_pattern = re.compile(r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b')
    ip_addresses = ip_pattern.findall(content)

    # Remove duplicates and sort
    unique_ips = sorted(set(ip_addresses))

    return unique_ips

# Example usage
file_path = 'your_file.htm'  # Change this to your HTML file path
ips = extract_ips_from_html(file_path)

# Print or save IPs
for ip in ips:
    print(ip)

# Optionally, write IPs to a file
with open('extracted_ips.txt', 'w') as output_file:
    for ip in ips:
        output_file.write(ip + '\n')

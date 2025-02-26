import ipaddress

# Define the start and end IP addresses
start_ip = ipaddress.IPv4Address('217.116.64.1')
end_ip = ipaddress.IPv4Address('217.116.79.254')

# Generate the list of IP addresses
ip_list = [str(ip) for ip in ipaddress.summarize_address_range(start_ip, end_ip)]

# Flatten the list of IP networks into individual IP addresses
ip_addresses = []
for ip_network in ip_list:
    for ip in ipaddress.IPv4Network(ip_network):
        ip_addresses.append(str(ip))

# Print the list of IP addresses
for ip in ip_addresses:
    print(ip)

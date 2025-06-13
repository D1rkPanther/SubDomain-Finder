import requests
import json
import os

def print_banner():
    banner = """
    -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -     ..| subdomain-apiST v1.0 |..     -
    -       site: securitytrails.com       -
    -            Twitter: az7rb            -
    -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    """
    print(banner)

def get_subdomains(domain):
    url = f"https://api.securitytrails.com/v1/domain/{domain}/subdomains"
    headers = {
        'APIKEY': '',
        'Accept': 'application/json'
    }
    response = requests.get(url, headers=headers)
    data = response.json()

    subdomains = [f"{subdomain}.{domain}" for subdomain in data['subdomains']]
    subdomain_count = data['subdomain_count']

    output_file = f"output/{domain}.txt"
    os.makedirs(os.path.dirname(output_file), exist_ok=True)

    with open(output_file, 'w') as f:
        for subdomain in subdomains:
            f.write(subdomain + '\n')

    print(f"\033[32m[+]\033[0m I found in API \033[31m{subdomain_count}\033[0m subdomains")
    print(f"\033[32m[+]\033[0m Total Save will be \033[31m{len(subdomains)}\033[0m subdomains only")
    print(f"\033[32m[+]\033[0m Output saved in {output_file}")

if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("USAGE: python script.py [domain.com]")
        sys.exit(1)

    domain = sys.argv[1]
    print_banner()
    get_subdomains(domain)


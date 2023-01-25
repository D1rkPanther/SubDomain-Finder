import subprocess
import os

# Domain to find subdomains of
domain = "example.com"

# Check if Sublist3r is installed
if not os.path.exists("/usr/local/bin/sublist3r"):
    subprocess.call("git clone https://github.com/aboul3la/Sublist3r.git", shell=True)
    subprocess.call("pip3 install -r Sublist3r/requirements.txt", shell=True)
    subprocess.call("ln -s $(pwd)/Sublist3r/sublist3r.py /usr/local/bin/sublist3r", shell=True)

# Check if Amass is installed
if not os.path.exists("/usr/local/bin/amass"):
    subprocess.call("apt install amass", shell=True)
   
# Check if Assetfinder is installed
if not os.path.exists("/usr/local/bin/assetfinder"):
    subprocess.call("go get -u github.com/tomnomnom/assetfinder", shell=True)
   
# Use Sublist3r to find subdomains
subprocess.call(f"sublist3r -d {domain} -o sublist3r_results.txt", shell=True)

# Use Amass to find subdomains
subprocess.call(f"amass enum -d {domain} -o amass_results.txt", shell=True)

# Use Assetfinder to find subdomains
subprocess.call(f"assetfinder --subs-only {domain} > assetfinder_results.txt", shell=True)

# Combine results from all three tools
subdomains = set()
with open("sublist3r_results.txt", "r") as f:
    subdomains.update(f.read().splitlines())
with open("amass_results.txt", "r") as f:
    subdomains.update(f.read().splitlines())
with open("assetfinder_results.txt", "r") as f:
    subdomains.update(f.read().splitlines())

# Print unique subdomains
print("\n".join(sorted(subdomains)))

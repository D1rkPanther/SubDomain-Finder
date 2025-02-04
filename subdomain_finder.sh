#!/bin/bash

# Define colors for better output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display help menu
show_help() {
    echo -e "${GREEN}Usage: $0 [options] <domain>${NC}"
    echo -e ""
    echo -e "Options:"
    echo -e "  -h, --help      Show this help message and exit."
    echo -e "  -o, --output    Specify output file (default: combined_subdomains.txt)."
    echo -e ""
    echo -e "Example:"
    echo -e "  $0 example.com"
    echo -e "  $0 -o custom_output.txt example.com"
    exit 0
}

# Function to check if a tool is installed
is_tool_installed() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a tool
install_tool() {
    local tool_name=$1
    local install_command=$2
    echo -e "${YELLOW}[+] Installing $tool_name...${NC}"
    eval "$install_command"
}

# Function to run a tool and save results
run_tool() {
    local tool_name=$1
    local command=$2
    local output_file=$3
    echo -e "${GREEN}[+] Running $tool_name...${NC}"
    eval "$command"
    if [[ -f "$output_file" ]]; then
        cat "$output_file"
    fi
}

# Parse arguments
if [[ $# -eq 0 ]]; then
    show_help
fi

output_file="combined_subdomains.txt"
domain=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -o|--output)
            output_file="$2"
            shift
            ;;
        *)
            domain="$1"
            ;;
    esac
    shift
done

if [[ -z "$domain" ]]; then
    echo -e "${RED}Error: Domain is required.${NC}"
    show_help
fi

# Check and install tools if not already installed
declare -A tools=(
    ["sublist3r"]="git clone https://github.com/aboul3la/Sublist3r.git && pip3 install -r Sublist3r/requirements.txt && ln -s $(pwd)/Sublist3r/sublist3r.py /usr/local/bin/sublist3r"
    ["assetfinder"]="go install -v github.com/tomnomnom/assetfinder@latest"
    ["subfinder"]="apt install subfinder -y"
)

for tool in "${!tools[@]}"; do
    if ! is_tool_installed "$tool"; then
        install_tool "$tool" "${tools[$tool]}"
    fi
done

# Run tools and collect results
temp_file=$(mktemp)

# Sublist3r
run_tool "Sublist3r" "sublist3r -d $domain -o sublist3r_results.txt" "sublist3r_results.txt" >> "$temp_file"

# Assetfinder
run_tool "Assetfinder" "assetfinder --subs-only $domain > assetfinder_results.txt" "assetfinder_results.txt" >> "$temp_file"

# Subfinder
run_tool "Subfinder" "subfinder -d $domain -o subfinder_results.txt" "subfinder_results.txt" >> "$temp_file"

# Deduplicate and save results
sort -u "$temp_file" > "$output_file"
rm "$temp_file"

echo -e "${GREEN}[+] Results saved to $output_file${NC}"

#!/bin/bash

# Check if a target domain was provided as an argument
if [ -z "$1" ]; then
    printf "\n[+] Please provide a target domain as an argument (e.g. recon example.com)\n"
    exit 1
fi

# Set some variables for use later in the script
target=$1
output_dir="./recon-${target}"
mkdir -p "${output_dir}"

# Perform subdomain enumeration using a variety of tools
printf "\n[+] Starting subdomain enumeration...\n"
assetfinder --subs-only "${target}" | tee "${output_dir}/assetfinder.txt"
amass enum -d "${target}" -o "${output_dir}/amass.txt"
subfinder -d "${target}" -o "${output_dir}/subfinder.txt"
sublist3r -d "${target}" | tee "${output_dir}/sublist3r.txt"
cat "${output_dir}/sublist3r.txt" "${output_dir}/subfinder.txt" "${output_dir}/amass.txt" "${output_dir}/assetfinder.txt" | sort -u | tee "${output_dir}/all-subs.txt"

# Perform port scanning using masscan
printf "\n[+] Starting port scanning...\n"
masscan -p1-65535 "${target}" --rate 1000 -oL "${output_dir}/masscan.txt"

# Perform web application analysis using httprobe, gau, and gobuster
printf "\n[+] Starting web application analysis...\n"
cat "${output_dir}/all-subs.txt" | httprobe | tee "${output_dir}/alive-subs.txt"
cat "${output_dir}/alive-subs.txt" | gau | tee "${output_dir}/gau.txt"
cat "${output_dir}/alive-subs.txt" | gobuster dir -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 100 -o "${output_dir}/gobuster.txt"

# Perform content discovery using waybackurls
printf "\n[+] Starting content discovery...\n"
cat "${output_dir}/alive-subs.txt" | waybackurls | grep "https://" | grep -v "png\|jpg\|css\|js\|gif\|txt\|pdf" | grep "=" | qsreplace | qsreplace -a | tee "${output_dir}/waybackurls.txt"

# Perform vulnerability scanning using nuclei
printf "\n[+] Starting vulnerability scanning...\n"
nuclei -l "${output_dir}/alive-subs.txt" -t "$

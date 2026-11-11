#!/bin/bash

# Ensure the script is run with appropriate permissions (root/libvirt group)
if ! command -v virsh &> /dev/null; then
    echo "Error: 'virsh' command not found. This script requires libvirt/KVM." >&2
    exit 1
fi

echo "=========================================================================================="
echo "                         KVM / Libvirt VM Resource Report                                 "
echo "=========================================================================================="
printf "%-20s | %-10s | %-15s | %-15s | %-10s\n" "VM Name" "State" "vCPUs" "Max Memory" "Running"
echo "------------------------------------------------------------------------------------------"

# Get a list of all defined domains (VMs)
vms=$(virsh list --all --name)

for vm in $vms; do
    if [ -z "$vm" ]; then
        continue
    fi



# Fetch domain info using virsh
    state=$(virsh domstate "$vm" 2>/dev/null | tr -d '\r')
    vcpus=$(virsh vcpucount "$vm" --current 2>/dev/null || echo "N/A")
    max_mem=$(virsh dominfo "$vm" 2>/dev/null | grep "Max memory" | awk '{print $3, $4}')
    
    # Format output row
    printf "%-20s | %-10s | %-15s | %-15s\n" "$vm" "$state" "$vcpus" "$max_mem"
done

echo "=========================================================================================="    

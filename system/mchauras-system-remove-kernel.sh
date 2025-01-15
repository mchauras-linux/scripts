#!/bin/bash

# Script to list and remove installed kernels, including custom-built ones
# Usage: sudo ./remove_kernel_with_menu.sh

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

CURRENT_KERNEL=$(uname -r)

# Function to list all kernels (both package-managed and custom-built)
list_installed_kernels() {
    # Find kernels installed via package managers
    PACKAGE_KERNELS=$(dpkg --get-selections | grep -E 'linux-image-[0-9]' | awk '{print $1}' | sed 's/linux-image-//g')
    
    # Find custom-built kernels (from /boot)
    CUSTOM_KERNELS=$(ls /boot | grep -oP 'vmlinuz-\K.*' | sort -u)
    
    # Combine both lists and remove duplicates
    echo -e "$PACKAGE_KERNELS\n$CUSTOM_KERNELS" | sort -u
}

# Function to display menu
show_menu() {
    echo
    echo "Select a kernel to remove (currently running kernel: $CURRENT_KERNEL):"
    echo
    
    # Get all kernels in an array
    KERNELS=($(list_installed_kernels))
    
    # Display the kernels with proper numbering
    for i in "${!KERNELS[@]}"; do
        echo "$i) ${KERNELS[$i]}"
    done
    echo "q) Quit"
}

# Function to remove a kernel
remove_kernel() {
    local kernel=$1
    
    # Prevent removal of the currently running kernel
    if [[ "$kernel" == "$CURRENT_KERNEL" ]]; then
        echo "ERROR: You cannot remove the currently running kernel ($CURRENT_KERNEL)."
        return
    fi

    echo "Removing kernel: $kernel"

    # Check if the kernel is package-managed
    if dpkg -l | grep -q "linux-image-$kernel"; then
        echo "Removing package-managed kernel..."
        apt-get purge -y linux-image-$kernel linux-headers-$kernel linux-modules-$kernel
    else
        echo "Removing custom-built kernel..."
        rm -f /boot/vmlinuz-$kernel
        rm -f /boot/initrd.img-$kernel
        rm -f /boot/System.map-$kernel
        rm -f /boot/config-$kernel
    fi

    # Cleanup and update GRUB
    apt-get autoremove -y
    apt-get autoclean -y
    update-grub

    echo "Kernel $kernel removed successfully."
}

# Main script logic
while true; do
    show_menu
    
    read -p "Enter your choice: " CHOICE
    
    if [[ "$CHOICE" == "q" || "$CHOICE" == "Q" ]]; then
        echo "Exiting."
        break
    elif [[ "$CHOICE" =~ ^[0-9]+$ ]] && [[ "$CHOICE" -lt ${#KERNELS[@]} ]]; then
        SELECTED_KERNEL=${KERNELS[$CHOICE]}
        remove_kernel "$SELECTED_KERNEL"
    else
        echo "Invalid choice. Please try again."
    fi
done

exit 0


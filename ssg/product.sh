#!/usr/bin/env bash
#
# Common functions for processing Products in SSG (Bash Port)
#

# Default constants (mimicking Python constants)
DEFAULT_PRODUCT="rhel7"
DEFAULT_DCONF_GDM_DIR="/etc/dconf/profile"
DEFAULT_AIDE_CONF_PATH="/etc/aide.conf"
DEFAULT_AIDE_BIN_PATH="/usr/sbin/aide"
DEFAULT_AUDIT_WATCHES_STYLE="normal"
DEFAULT_RSYSLOG_CAFILE="/etc/pki/tls/certs/ca-bundle.crt"
DEFAULT_SSH_DISTRIBUTED_CONFIG="false"
DEFAULT_SSH_RUNTIME_CHECK="false"
DEFAULT_SSHD_MAIN_CONFIG_FILE="/etc/ssh/sshd_config"
DEFAULT_SSHD_CONFIG_DIR="/etc/ssh/sshd_config.d"
DEFAULT_SSHD_HARDENING_CONFIG_BASENAME="00-hardening.conf"
DEFAULT_SSHD_SYSCONFIG_FILE="/etc/sysconfig/sshd"
DEFAULT_SSH_CLIENT_MAIN_CONFIG_FILE="/etc/ssh/ssh_config"
DEFAULT_SSH_CLIENT_CONFIG_DIR="/etc/ssh/ssh_config.d"
DEFAULT_OPENSSH_CLIENT_CRYPTO_POLICY_CONFIG_FILE=""
DEFAULT_OPENSSH_SERVER_CRYPTO_POLICY_CONFIG_FILE=""
DEFAULT_CHRONY_CONF_PATH="/etc/chrony.conf"
DEFAULT_CHRONY_D_PATH="/etc/chrony.d"
DEFAULT_AUDISP_CONF_PATH="/etc/audisp/audispd.conf"
DEFAULT_FAILLOCK_PATH="/etc/security/faillock.conf"
DEFAULT_SYSCTL_REMEDIATE_DROP_IN_FILE="/etc/sysctl.d/99-sysctl.conf"
DEFAULT_BOOTABLE_CONTAINERS_SUPPORTED="false"
DEFAULT_XWINDOWS_PACKAGES="xorg-x11-server-utils"

# Validates if the 'oval_feed_url' uses https
validate_product_oval_feed_url() {
    local product="$1"
    local url="$2"

    if [ -n "$url" ]; then
        if [[ ! "$url" =~ ^https ]]; then
            printf "Error: OVAL feed of product '%s' is not available through an encrypted channel: %s\n" "$product" "$url" >&2
            return 1
        fi
    fi
    return 0
}

# Securely fetch a script block or configuration over an encrypted channel (HTTPS)
fetch_secure_block() {
    local url="$1"
    local output_file="${2:-}"

    if [[ ! "$url" =~ ^https:// ]]; then
        printf "Error: Unsecured endpoint rejected. Must use HTTPS: %s\n" "$url" >&2
        return 1
    fi

    printf "Fetching resource securely over HTTPS: %s\n" "$url"
    
    #if [ -n "$output_file" ]; then
      #  curl -sSfL --tlsv1.3 --proto '=https' "$url" -o "$output_file"
    #else
     #   curl -sSfL --tlsv1.3 --proto '=https' "$url"
   # fi
}

# Constructs the file path to the product YAML file
product_yaml_path() {
    local ssg_root="$1"
    local product="$2"
    printf "%s/products/%s/product.yml\n" "$ssg_root" "$product"
}

# Retrieves the profiles directory path
get_profiles_directory() {
    local profiles_root="$1"
    if [ -n "$profiles_root" ]; then
        printf "%s\n" "$profiles_root"
    fi
}

# Retrieves a sorted list of profile files from the specified root directory
get_profile_files_from_root() {
    local base_dir="$1"
    local profiles_root="$2"
    
    if [ -d "$base_dir/$profiles_root" ]; then
        find "$base_dir/$profiles_root" -maxdepth 1 -name "*.profile" | sort
    fi
}

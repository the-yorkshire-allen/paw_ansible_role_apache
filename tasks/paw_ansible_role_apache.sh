#!/bin/bash
set -e

# Puppet task for executing Ansible role: ansible_role_apache
# This script runs the entire role via ansible-playbook

# Determine the ansible modules directory
if [ -n "$PT__installdir" ]; then
  ANSIBLE_DIR="$PT__installdir/lib/puppet_x/ansible_modules/ansible_role_apache"
else
  # Fallback to /opt/puppetlabs/puppet/cache/lib/puppet_x/ansible_modules
  ANSIBLE_DIR="/opt/puppetlabs/puppet/cache/lib/puppet_x/ansible_modules/ansible_role_apache"
fi

# Check if ansible-playbook is available
if ! command -v ansible-playbook &> /dev/null; then
  echo '{"_error": {"msg": "ansible-playbook command not found. Please install Ansible.", "kind": "puppet-ansible-converter/ansible-not-found"}}'
  exit 1
fi

# Check if the role directory exists
if [ ! -d "$ANSIBLE_DIR" ]; then
  echo "{\"_error\": {\"msg\": \"Ansible role directory not found: $ANSIBLE_DIR\", \"kind\": \"puppet-ansible-converter/role-not-found\"}}"
  exit 1
fi

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
if [ -d "$ANSIBLE_DIR/roles" ] && [ -f "$ANSIBLE_DIR/roles/paw_ansible_role_apache/playbook.yml" ]; then
  # Collection structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/roles/paw_ansible_role_apache/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR/roles/paw_ansible_role_apache"
elif [ -f "$ANSIBLE_DIR/playbook.yml" ]; then
  # Standalone role structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR"
else
  echo "{\"_error\": {\"msg\": \"playbook.yml not found in $ANSIBLE_DIR or $ANSIBLE_DIR/roles/paw_ansible_role_apache\", \"kind\": \"puppet-ansible-converter/playbook-not-found\"}}"
  exit 1
fi

# Build extra-vars from PT_* environment variables (excluding par_* control params)
EXTRA_VARS="{"
FIRST=true
if [ -n "$PT_apache_global_vhost_settings" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_global_vhost_settings\": \"$PT_apache_global_vhost_settings\""
fi
if [ -n "$PT_apache_listen_ip" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_listen_ip\": \"$PT_apache_listen_ip\""
fi
if [ -n "$PT_apache_listen_port" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_listen_port\": \"$PT_apache_listen_port\""
fi
if [ -n "$PT_apache_listen_port_ssl" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_listen_port_ssl\": \"$PT_apache_listen_port_ssl\""
fi
if [ -n "$PT_apache_ssl_cipher_suite" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_ssl_cipher_suite\": \"$PT_apache_ssl_cipher_suite\""
fi
if [ -n "$PT_apache_ssl_protocol" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_ssl_protocol\": \"$PT_apache_ssl_protocol\""
fi
if [ -n "$PT_apache_enablerepo" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_enablerepo\": \"$PT_apache_enablerepo\""
fi
if [ -n "$PT_apache_create_vhosts" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_create_vhosts\": \"$PT_apache_create_vhosts\""
fi
if [ -n "$PT_apache_vhosts_filename" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_vhosts_filename\": \"$PT_apache_vhosts_filename\""
fi
if [ -n "$PT_apache_vhosts_template" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_vhosts_template\": \"$PT_apache_vhosts_template\""
fi
if [ -n "$PT_apache_remove_default_vhost" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_remove_default_vhost\": \"$PT_apache_remove_default_vhost\""
fi
if [ -n "$PT_apache_vhosts" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_vhosts\": \"$PT_apache_vhosts\""
fi
if [ -n "$PT_apache_allow_override" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_allow_override\": \"$PT_apache_allow_override\""
fi
if [ -n "$PT_apache_options" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_options\": \"$PT_apache_options\""
fi
if [ -n "$PT_apache_vhosts_ssl" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_vhosts_ssl\": \"$PT_apache_vhosts_ssl\""
fi
if [ -n "$PT_apache_ignore_missing_ssl_certificate" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_ignore_missing_ssl_certificate\": \"$PT_apache_ignore_missing_ssl_certificate\""
fi
if [ -n "$PT_apache_ssl_no_log" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_ssl_no_log\": \"$PT_apache_ssl_no_log\""
fi
if [ -n "$PT_apache_mods_enabled" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_mods_enabled\": \"$PT_apache_mods_enabled\""
fi
if [ -n "$PT_apache_mods_disabled" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_mods_disabled\": \"$PT_apache_mods_disabled\""
fi
if [ -n "$PT_apache_conf_enabled" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_conf_enabled\": \"$PT_apache_conf_enabled\""
fi
if [ -n "$PT_apache_conf_disabled" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_conf_disabled\": \"$PT_apache_conf_disabled\""
fi
if [ -n "$PT_apache_state" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_state\": \"$PT_apache_state\""
fi
if [ -n "$PT_apache_enabled" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_enabled\": \"$PT_apache_enabled\""
fi
if [ -n "$PT_apache_restart_state" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_restart_state\": \"$PT_apache_restart_state\""
fi
if [ -n "$PT_apache_packages_state" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"apache_packages_state\": \"$PT_apache_packages_state\""
fi
EXTRA_VARS="$EXTRA_VARS}"

# Build ansible-playbook command with control parameters
ANSIBLE_CMD="ansible-playbook playbook.yml"
ANSIBLE_CMD="$ANSIBLE_CMD --extra-vars \"$EXTRA_VARS\""

# Add connection type (default: local)
CONNECTION="${PT_par_connection:-local}"
ANSIBLE_CMD="$ANSIBLE_CMD --connection=$CONNECTION"

# Add inventory
ANSIBLE_CMD="$ANSIBLE_CMD --inventory=localhost,"

# Add timeout if specified
if [ -n "$PT_par_timeout" ]; then
  ANSIBLE_CMD="$ANSIBLE_CMD --timeout=$PT_par_timeout"
fi

# Add extra flags if specified
if [ -n "$PT_par_extra_flags" ]; then
  # Parse JSON array of extra flags
  EXTRA_FLAGS=$(echo "$PT_par_extra_flags" | sed 's/\[//;s/\]//;s/"//g;s/,/ /g')
  ANSIBLE_CMD="$ANSIBLE_CMD $EXTRA_FLAGS"
fi

# Set working directory if specified
if [ -n "$PT_par_working_directory" ]; then
  cd "$PT_par_working_directory"
else
  cd "$PLAYBOOK_DIR"
fi

# Set environment variables if specified
if [ -n "$PT_par_environment" ]; then
  # Parse JSON hash and export variables
  eval $(echo "$PT_par_environment" | sed 's/[{}]//g;s/": "/=/g;s/","/;export /g;s/"//g' | sed 's/^/export /')
fi

# Execute ansible-playbook
eval $ANSIBLE_CMD 2>&1

EXIT_CODE=$?

# Return JSON result
if [ $EXIT_CODE -eq 0 ]; then
  echo '{"status": "success", "role": "ansible_role_apache"}'
else
  echo "{\"status\": \"failed\", \"role\": \"ansible_role_apache\", \"exit_code\": $EXIT_CODE}"
fi

exit $EXIT_CODE

# Puppet task for executing Ansible role: ansible_role_apache
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_apache"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_apache"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_apache\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_apache"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_apache"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_apache_global_vhost_settings) {
  $ExtraVars['apache_global_vhost_settings'] = $env:PT_apache_global_vhost_settings
}
if ($env:PT_apache_listen_ip) {
  $ExtraVars['apache_listen_ip'] = $env:PT_apache_listen_ip
}
if ($env:PT_apache_listen_port) {
  $ExtraVars['apache_listen_port'] = $env:PT_apache_listen_port
}
if ($env:PT_apache_listen_port_ssl) {
  $ExtraVars['apache_listen_port_ssl'] = $env:PT_apache_listen_port_ssl
}
if ($env:PT_apache_ssl_cipher_suite) {
  $ExtraVars['apache_ssl_cipher_suite'] = $env:PT_apache_ssl_cipher_suite
}
if ($env:PT_apache_ssl_protocol) {
  $ExtraVars['apache_ssl_protocol'] = $env:PT_apache_ssl_protocol
}
if ($env:PT_apache_enablerepo) {
  $ExtraVars['apache_enablerepo'] = $env:PT_apache_enablerepo
}
if ($env:PT_apache_create_vhosts) {
  $ExtraVars['apache_create_vhosts'] = $env:PT_apache_create_vhosts
}
if ($env:PT_apache_vhosts_filename) {
  $ExtraVars['apache_vhosts_filename'] = $env:PT_apache_vhosts_filename
}
if ($env:PT_apache_vhosts_template) {
  $ExtraVars['apache_vhosts_template'] = $env:PT_apache_vhosts_template
}
if ($env:PT_apache_remove_default_vhost) {
  $ExtraVars['apache_remove_default_vhost'] = $env:PT_apache_remove_default_vhost
}
if ($env:PT_apache_vhosts) {
  $ExtraVars['apache_vhosts'] = $env:PT_apache_vhosts
}
if ($env:PT_apache_allow_override) {
  $ExtraVars['apache_allow_override'] = $env:PT_apache_allow_override
}
if ($env:PT_apache_options) {
  $ExtraVars['apache_options'] = $env:PT_apache_options
}
if ($env:PT_apache_vhosts_ssl) {
  $ExtraVars['apache_vhosts_ssl'] = $env:PT_apache_vhosts_ssl
}
if ($env:PT_apache_ignore_missing_ssl_certificate) {
  $ExtraVars['apache_ignore_missing_ssl_certificate'] = $env:PT_apache_ignore_missing_ssl_certificate
}
if ($env:PT_apache_ssl_no_log) {
  $ExtraVars['apache_ssl_no_log'] = $env:PT_apache_ssl_no_log
}
if ($env:PT_apache_mods_enabled) {
  $ExtraVars['apache_mods_enabled'] = $env:PT_apache_mods_enabled
}
if ($env:PT_apache_mods_disabled) {
  $ExtraVars['apache_mods_disabled'] = $env:PT_apache_mods_disabled
}
if ($env:PT_apache_conf_enabled) {
  $ExtraVars['apache_conf_enabled'] = $env:PT_apache_conf_enabled
}
if ($env:PT_apache_conf_disabled) {
  $ExtraVars['apache_conf_disabled'] = $env:PT_apache_conf_disabled
}
if ($env:PT_apache_state) {
  $ExtraVars['apache_state'] = $env:PT_apache_state
}
if ($env:PT_apache_enabled) {
  $ExtraVars['apache_enabled'] = $env:PT_apache_enabled
}
if ($env:PT_apache_restart_state) {
  $ExtraVars['apache_restart_state'] = $env:PT_apache_restart_state
}
if ($env:PT_apache_packages_state) {
  $ExtraVars['apache_packages_state'] = $env:PT_apache_packages_state
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_apache"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_apache"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}

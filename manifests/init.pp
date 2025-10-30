# paw_ansible_role_apache
# @summary Manage paw_ansible_role_apache configuration
#
# @param apache_global_vhost_settings
# @param apache_listen_ip
# @param apache_listen_port
# @param apache_listen_port_ssl
# @param apache_ssl_cipher_suite
# @param apache_ssl_protocol
# @param apache_enablerepo
# @param apache_create_vhosts
# @param apache_vhosts_filename
# @param apache_vhosts_template
# @param apache_remove_default_vhost Set this to `true` to remove that default.
# @param apache_vhosts
# @param apache_allow_override
# @param apache_options
# @param apache_vhosts_ssl
# @param apache_ignore_missing_ssl_certificate
# @param apache_ssl_no_log
# @param apache_mods_enabled Only used on Debian/Ubuntu/Redhat.
# @param apache_mods_disabled
# @param apache_conf_enabled
# @param apache_conf_disabled
# @param apache_state Set initial apache state. Recommended values: `started` or `stopped`
# @param apache_enabled Set initial apache service status. Recommended values: `true` or `false`
# @param apache_restart_state `restarted` or `reloaded`
# @param apache_packages_state if you want to upgrade or switch versions using a new repo.
# @param par_connection Ansible connection type (e.g., 'local', 'ssh')
# @param par_timeout Ansible playbook execution timeout in seconds
# @param par_environment Additional environment variables for ansible-playbook
# @param par_working_directory Working directory for ansible-playbook execution
# @param par_extra_flags Additional flags to pass to ansible-playbook
class paw_ansible_role_apache (
  String $apache_global_vhost_settings = 'DirectoryIndex index.php index.html\n',
  String $apache_listen_ip = '*',
  Integer $apache_listen_port = 80,
  Integer $apache_listen_port_ssl = 443,
  String $apache_ssl_cipher_suite = 'AES256+EECDH:AES256+EDH',
  String $apache_ssl_protocol = 'All -SSLv2 -SSLv3',
  Optional[String] $apache_enablerepo = undef,
  Boolean $apache_create_vhosts = true,
  String $apache_vhosts_filename = 'vhosts.conf',
  String $apache_vhosts_template = 'vhosts.conf.j2',
  Boolean $apache_remove_default_vhost = false,
  Array $apache_vhosts = [{ 'servername' => 'local.dev', 'documentroot' => '/var/www/html' }],
  String $apache_allow_override = 'All',
  String $apache_options = '-Indexes +FollowSymLinks',
  Array $apache_vhosts_ssl = [],
  Boolean $apache_ignore_missing_ssl_certificate = true,
  Boolean $apache_ssl_no_log = true,
  Array $apache_mods_enabled = ['rewrite', 'ssl'],
  Array $apache_mods_disabled = [],
  Array $apache_conf_enabled = [],
  Array $apache_conf_disabled = [],
  String $apache_state = 'started',
  Boolean $apache_enabled = true,
  String $apache_restart_state = 'restarted',
  String $apache_packages_state = 'present',
  Optional[String] $par_connection = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[Hash] $par_environment = undef,
  Optional[String] $par_working_directory = undef,
  Optional[Array[String]] $par_extra_flags = undef
) {
  # Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = pick($facts['puppet_vardir'], $settings::vardir, '/opt/puppetlabs/puppet/cache')
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/ansible_role_apache/playbook.yml"

  par { 'paw_ansible_role_apache-main':
    ensure            => present,
    playbook          => $playbook_path,
    playbook_vars     => {
      'apache_global_vhost_settings'          => $apache_global_vhost_settings,
      'apache_listen_ip'                      => $apache_listen_ip,
      'apache_listen_port'                    => $apache_listen_port,
      'apache_listen_port_ssl'                => $apache_listen_port_ssl,
      'apache_ssl_cipher_suite'               => $apache_ssl_cipher_suite,
      'apache_ssl_protocol'                   => $apache_ssl_protocol,
      'apache_enablerepo'                     => $apache_enablerepo,
      'apache_create_vhosts'                  => $apache_create_vhosts,
      'apache_vhosts_filename'                => $apache_vhosts_filename,
      'apache_vhosts_template'                => $apache_vhosts_template,
      'apache_remove_default_vhost'           => $apache_remove_default_vhost,
      'apache_vhosts'                         => $apache_vhosts,
      'apache_allow_override'                 => $apache_allow_override,
      'apache_options'                        => $apache_options,
      'apache_vhosts_ssl'                     => $apache_vhosts_ssl,
      'apache_ignore_missing_ssl_certificate' => $apache_ignore_missing_ssl_certificate,
      'apache_ssl_no_log'                     => $apache_ssl_no_log,
      'apache_mods_enabled'                   => $apache_mods_enabled,
      'apache_mods_disabled'                  => $apache_mods_disabled,
      'apache_conf_enabled'                   => $apache_conf_enabled,
      'apache_conf_disabled'                  => $apache_conf_disabled,
      'apache_state'                          => $apache_state,
      'apache_enabled'                        => $apache_enabled,
      'apache_restart_state'                  => $apache_restart_state,
      'apache_packages_state'                 => $apache_packages_state,
    },
    connection        => $par_connection,
    timeout           => $par_timeout,
    environment       => $par_environment,
    working_directory => $par_working_directory,
    extra_flags       => $par_extra_flags,
  }
}

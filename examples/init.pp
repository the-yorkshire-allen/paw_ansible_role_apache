# Example usage of paw_ansible_role_apache

# Simple include with default parameters
include paw_ansible_role_apache

# Or with custom parameters:
# class { 'paw_ansible_role_apache':
#   apache_global_vhost_settings => 'DirectoryIndex index.php index.html\n',
#   apache_listen_ip => '*',
#   apache_listen_port => 80,
#   apache_listen_port_ssl => 443,
#   apache_ssl_cipher_suite => 'AES256+EECDH:AES256+EDH',
#   apache_ssl_protocol => 'All -SSLv2 -SSLv3',
#   apache_enablerepo => undef,
#   apache_create_vhosts => true,
#   apache_vhosts_filename => 'vhosts.conf',
#   apache_vhosts_template => 'vhosts.conf.j2',
#   apache_remove_default_vhost => false,
#   apache_vhosts => [{'servername' => 'local.dev', 'documentroot' => '/var/www/html'}],
#   apache_allow_override => 'All',
#   apache_options => '-Indexes +FollowSymLinks',
#   apache_vhosts_ssl => [],
#   apache_ignore_missing_ssl_certificate => true,
#   apache_ssl_no_log => true,
#   apache_mods_enabled => ['rewrite', 'ssl'],
#   apache_mods_disabled => [],
#   apache_conf_enabled => [],
#   apache_conf_disabled => [],
#   apache_state => 'started',
#   apache_enabled => true,
#   apache_restart_state => 'restarted',
#   apache_packages_state => 'present',
# }

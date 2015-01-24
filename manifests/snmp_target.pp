# munin::snmp_target
#
# Configures an snmp target trhough a munin node
# For more information see http://munin.readthedocs.org/en/latest/tutorial/snmp.html
#
define munin::snmp_target (
  $host=$title,
  $snmp_version=2,
  $snmp_community='public',
  $snmp_port=161,
  $snmp_username=undef,
  $snmp_authpassword=undef,
  $snmp_authprotocol=undef,
  $snmp_privpassword=undef,
  $snmp_privprotocol=undef,
  $munin_node_configure_path='/usr/sbin/',
  $node_address='127.0.0.1',
  $mastername='',
  $export_node='enabled'
  ) {
    validate_string($host)
    validate_string($snmp_community)
    validate_re($snmp_version, [ '1', '2', '3'])

    exec { "create symlinks for SNMP target ${host}":
      command   => "munin-node-configure --shell --snmp ${snmp_host} --snmpversion ${snmp_version} --snmpcommunity ${snmp_community} | sh",
      path      => [$munin_node_configure_path, '/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      logoutput => true,
    }

    $config_name = "snmp_${host}_*"
    $label = "snmp_${host}_*"
    $config = [
      "env.community ${snmp_community}",
      "env.version ${snmp_version}"
    ]

    file{ "${munin::node::config_root}/plugin-conf.d/snmp_${host}.conf":
      ensure  => present,
      content => template('munin/plugin_conf.erb'),
      notify  => Service[$munin::node::service_name],
    }

    if $export_node == 'enabled' {
      @@munin::master::node_definition{ $title:
        address         => $node_address,
        mastername      => $mastername,
        config          => [
          'use_node_name no'
        ],
        tag             => [ "munin::master::${mastername}" ],
        node_is_virtual => true
      }
    }

}

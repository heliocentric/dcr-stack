package { "unzip":
	ensure => "present",
} ->
class { "::epel":
} ->
class { "::erlang": 
} ->
class  {"::rabbitmq":
	package_provider => "rpm",
	package_source => 'https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.1/rabbitmq-server-3.6.1-1.noarch.rpm',
} ->
class  {"::consul":
  config_hash => {
    'bootstrap_expect' => 1,
    'data_dir'         => '/opt/consul',
    'datacenter'       => 'vagrant',
    'log_level'        => 'INFO',
    'node_name'        => 'server',
    'server'           => true,
	'addresses' => {
		"http" => "0.0.0.0",
	},
  }
} ->
class { "::docker":
}
rabbitmq_user { 'vagrant':
  admin    => true,
  password => 'vagrant',
}
rabbitmq_user_permissions { 'vagrant@/':
  configure_permission => '.*',
  read_permission      => '.*',
  write_permission     => '.*',
}
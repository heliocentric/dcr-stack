service { "firewalld":
	ensure => "stopped",
	enable => true,
} ->
package { "unzip":
	ensure => "present",
} ->
package { "lvm2":
	ensure => "absent",
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
	tcp_bind        => ['tcp://127.0.0.1:2375'],
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
docker::run { 'swarm':
  image           => 'swarm',
  command         => 'join --advertise=127.0.0.1:2375 consul://127.0.0.1:8500',
  detach          => true,
}
docker::run { 'swarm-master':
  image           => 'swarm',
  command         => 'manage -H :4000 --replication --advertise 127.0.0.1:4000 consul://127.0.0.1:8500',
  ports           => ['4000'],
  expose          => ['4000'],
  detach          => true,
}
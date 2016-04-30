class { "::epel":
} ->
class { "::erlang": 
} ->
class  {"::rabbitmq":
	package_provider => "rpm",
	package_source => 'https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.1/rabbitmq-server-3.6.1-1.noarch.rpm',
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
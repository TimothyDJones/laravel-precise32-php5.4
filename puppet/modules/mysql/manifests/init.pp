class mysql {
	
	package {
		"mysql-server":
			ensure => present,
			require => Exec["apt-get-update"]
	}
	
	service {
		"mysql":
			ensure => running,
			enable => true,
			require => Package["mysql-server"],
			subscribe => [
				File["/etc/mysql/my.cnf"],
			],
	}
	
	# Copy custom 'my.cnf' configuration file for MySQL.
	file { "/etc/mysql/my.cnf":
		notify => Service["mysql"],
		mode => 644,
		owner => "root",
		group => "root",
		require => Package["mysql-server"],
		source => "${config::filepath}/mysql/my.cnf",
		target => "/etc/mysql/my.cnf",
	}
	
	# Set 'root' password for MySQL to blank (null/empty).
	exec {
		"set-root-password":
			onlyif => "mysqladmin -uroot -proot status",	# Only change if 'root' password is *NOT* (already) blank.
			command => "mysqladmin -uroot -proot password $root_password",
			require => Service["mysql"]
	}
	
	# Create new 'laravel' database (only if it doesn't already exist).
	exec {
		"create-laravel-database":
			unless => "mysql -uroot -p$root_password laravel",
			command => "mysql -uroot -p$root_password -e 'create database `laravel`;'",
			require => [
				Service["mysql"],
				Exec["set-root-password"],
			]
	}
	
	# Grant *ALL* permissions to 'laravel' database to 'root' user.
	exec {
		"grant-db-priv-root":
			command => "mysql -uroot -p$root_password -e 'grant all on `laravel`.* to `root@localhost`;'",
			require => [
				Service["mysql"],
				Exec["create-laravel-database"],
			]
	}
	
	# TODO - Add creation of user and password for 'laravel' database.
	
}
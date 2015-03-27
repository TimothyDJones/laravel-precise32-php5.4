class laravel {
	# Delete files from /vagrant directory before creating project.
	# Only delete files if /vagrant/laravel/composer.json does *NOT* exist.
	exec { "clean-vagrant-dir":
		unless => [ "test -f /vagrant/laravel/composer.json",
			"test -d /vagrant/laravel/app"
		],
		require => Package["apache2"],
		command => "/bin/sh -c 'cd /vagrant && rm -rf laravel'",
	}
	
	exec { "add-laravel-installer":
		require => Exec['composer-global'],	# From 'composer' Puppet module
		command => "composer global require 'laravel/installer=~1.1'",
		creates => "/usr/local/bin/laravel",
		timeout => 1800,
		logoutput => true,
	}
	
	exec { "create-laravel-project":
		require => [
			Package["git-core", "php5", "php5-cli"],
			Exec["add-laravel-installer"],
		],
		#command => "/bin/bash -c 'cd /vagrant/ && shopt -s dotglob nullglob; composer create-project laravel/laravel temp --prefer-dist ${config::laravel_version}.* && mv temp laravel'",
		command => "/bin/bash -c 'cd /vagrant/ ; composer create-project laravel/laravel temp --prefer-dist ${config::laravel_version}.* && mv temp laravel'",  # Do *NOT* use Composer global options if installing specific version of Laravel.
		creates => "/vagrant/laravel/composer.json",
		timeout => 1800,
		logoutput => true,
	}
	
	# Set "full write" permissions on Laravel storage directory.
	file {
		"/vagrant/laravel/app/storage":
			require => Exec["create-laravel-project"],
			mode => 777,
			owner => "www-data",
			group => "www-data",
	}
	
	# Change ownership of Laravel public directory.
	file {
		"/vagrant/laravel/public":
			require => Exec["create-laravel-project"],
			mode => 644,
			owner => "www-data",
			group => "www-data",			
	}
	
	# Copy the "PHP info" file to Laravel directory
	file { "/vagrant/laravel/public/vagrant-phpinfo.php":
		#unless => "[ -f /vagrant/laravel/public/vagrant-phpinfo.php ]",
		notify => Service["apache2"],
		mode => 644,
		owner => "www-data",
		group => "www-data",
		require => Exec["create-laravel-project"],
		source => "${config::filepath}/custom/vagrant-phpinfo.php",
	}
}
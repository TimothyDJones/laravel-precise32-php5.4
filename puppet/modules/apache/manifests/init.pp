class apache {
	package {
		"apache2":
			ensure => present,
			require => [
				Exec["apt-get-update"],
				Package["php5"],
				Package["php5-cli"]				
			]
	}
	
	service {
		"apache2":
			ensure => running,
			enable => true,
			require => Package["apache2"],
			subscribe => [
				File["/etc/apache2/sites-available/default"],
				File["/etc/php5/apache2/conf.d/20-xdebug.ini"],
			],
	}
	
	# Copy the default "site" configuration
	file { "/etc/apache2/sites-available/default":
		notify => Service["apache2"],
		mode => 644,
		owner => "root",
		group => "root",
		require => Package["apache2"],
		source => "/vagrant/puppet/files/apache/default",
		target => "/etc/apache2/sites-available/default",
	}
	
	# Copy the XDebug configuration file for remote debugging.
	file { "/etc/php5/apache2/conf.d/20-xdebug.ini":
		notify => Service["apache2"],
		mode => 644,
		owner => "root",
		group => "root",
		require => Package["apache2"],
		source => "/vagrant/puppet/files/custom/20-xdebug.ini",
		target => "/etc/php5/apache2/conf.d/20-xdebug.ini",
	}
	
}
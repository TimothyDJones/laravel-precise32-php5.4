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
			],
	}
	
	# Copy the default "site" configuration
	file { "/etc/apache2/sites-available/default":
		notify => Service["apache2"],
		mode => 644,
		owner => "root",
		group => "root",
		require => Package["apache2"],
		source => "${config::filepath}/apache/default",
	}
	
	# Enable mod_rewrite
	exec { "/usr/sbin/a2enmod rewrite":
		notify => Service["apache2"],
		require => Package["apache2"]
	}	
}
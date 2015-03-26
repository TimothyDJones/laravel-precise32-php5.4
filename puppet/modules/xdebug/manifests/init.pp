class xdebug {
	package {
		"php5-xdebug":
			ensure => present,
			require => Exec["apt-get-update"],
			subscribe => [
				File["/etc/php5/apache2/conf.d/20-xdebug.ini"],
			],
	}
	
	# Copy the XDebug configuration file for remote debugging.
	file { "/etc/php5/apache2/conf.d/20-xdebug.ini":
		notify => Service["apache2"],
		mode => 644,
		owner => "root",
		group => "root",
		require => [Package["apache2"], Service["apache2"] ],
		source => "${config::filepath}/custom/20-xdebug.ini",
		target => "/etc/php5/apache2/conf.d/20-xdebug.ini",
	}
}
class xdebug {
	
	# Copy the XDebug configuration file for remote debugging.
	file { "/etc/php5/apache2/conf.d/20-xdebug.ini":
		notify => Service["apache2"],
		mode => 644,
		owner => "root",
		group => "root",
		require => Package["php5-xdebug"],
		source => "${config::filepath}/custom/20-xdebug.ini",
	}
}
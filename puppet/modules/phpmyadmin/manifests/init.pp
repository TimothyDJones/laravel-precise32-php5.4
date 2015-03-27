class phpmyadmin {
	package {
		"phpmyadmin":
			ensure => present,
			require => [
				Exec["apt-get-update"],
				Package["php5", "php5-mysql", "apache2"],
			],
			
	}
	
	file {
		"/etc/php5/apache2/conf.d/phpmyadmin.conf":
			ensure => link,
			target => "/etc/phpmyadmin/apache.conf",
			notify => Service["apache2"],
			require => Package["apache2"],
	}
	
	file {
		"/etc/phpmyadmin/config.inc.php":
			ensure => present,
			mode => 775,
			owner => root,
			group => root,
			notify => Service["apache2"],
			source => "${config::filepath}/phpmyadmin/config.inc.php",
			require => [
				Package["phpmyadmin"],
				Package["apache2"],
			],
	}
}
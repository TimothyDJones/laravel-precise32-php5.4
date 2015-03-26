class php54 {

	# Install prerequisite package to use 'apt-add-repository'.
	package { [ "python-software-properties" ] :
		ensure => present,
		require => Exec["apt-get-update"]
	}
	
	# Add repository for PHP 5.4
	exec { "php5-oldstable":
		command => "/usr/bin/sudo /usr/bin/apt-add-repository ppa:ondrej/php5-oldstable -y ; /usr/bin/sudo /usr/bin/apt-get update",
		require => Package["python-software-properties"]
	}
	
	# Update repository lists
	exec { "php54-update":
		require => Exec["apt-get-update"]
	}	

}
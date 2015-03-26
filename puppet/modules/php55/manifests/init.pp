class php55 {

	# Install prerequisite package to use 'apt-add-repository'.
	package { [ "python-software-properties" ] :
		ensure => present,
		require => Exec["apt-get-update"]
	}
	
	# Add repository for PHP 5.5
	exec { "php55":
		command => "/usr/bin/sudo /usr/bin/apt-add-repository ppa:ondrej/php5 -y ; /usr/bin/sudo /usr/bin/apt-get update",
		require => Package["python-software-properties"]
	}
	
	# Update repository lists
	exec { "php55-update":
		require => Exec["apt-get-update"]
	}	

}
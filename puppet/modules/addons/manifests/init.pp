class addons {
	package {
		"vim":
			ensure => present,
			require => Exec["apt-get-update"]
	}
	
	package {
		"curl":
			ensure => present,
			require => Exec["apt-get-update"]
	}
	
	package {
		"htop":
			ensure => present,
			require => Exec["apt-get-update"]
	}
	
	package {
		"sqlite":
			ensure => present,
			require => Exec["apt-get-update"]
	}
	
	package {
		"git":
			ensure => present,
			require => Exec["apt-get-update"]
	}
	
	package {
		"git-core":
			ensure => present,
			require => Exec["apt-get-update"]
	}
	
	# Install any additional packages specified by user in 'config.pp'.
	package {
		$config::extra_packages:
			ensure => present,
			require => Exec["apt-get-update"]
	}
}
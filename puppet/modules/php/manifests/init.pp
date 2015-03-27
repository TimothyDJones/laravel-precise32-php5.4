class php {
	$packages = [
		"php5",
		"php5-cli",
		"php5-curl",
		"php5-mysql",
		"php5-mcrypt",
		"libapache2-mod-php5",
	]
	
	# Add any other packages specified by user.
	#$packages = ($packages+$config::extra_php_packages).flatten.join(',')
	notify { "PHP packages after combining with 'extra': ${packages}.":
		withpath => true,
	}
	
	package {
		$packages:
			ensure => latest,
			require => [
				Exec["apt-get-update"],
				Package["python-software-properties"]
			]
	}
	
	# Install 'extra' PHP packages specified by user, if any.
	# TODO: This is a workaround due to problems with combining arrays.
	package {
		$config::extra_php_packages:
			ensure => latest,
			require => [
				Exec["apt-get-update"],
				Package["python-software-properties"]
			]
	}
}
class composer {
	exec { "composer-install":
		unless => "[ -f /usr/local/bin/composer ]",
		require => Package["php5-cli", "curl"],
		command => "/usr/bin/curl -s https://getcomposer.org/installer | /usr/bin/php -- --install-dir=/usr/local/bin",
	}
	
	exec { "composer-global":
		unless => "[ -f /usr/local/bin/composer ]",
		require => Exec["composer-install"],
		command => "sudo mv /usr/local/bin/composer.phar /usr/local/bin/composer",
	}
}
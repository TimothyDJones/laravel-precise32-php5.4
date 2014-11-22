class init {
	exec { "apt-get-update":
		command => "/usr/bin/apt-get update ; apt-get -f -y install"
	}
	
	package { [ "python-software-properties" ] :
		ensure => present,
		require => Exec["apt-get-update"]
	}

	# Add repository for PHP 5.4
	exec { "php5-oldstable":
		command => "/usr/bin/apt-add-repository ppa:ondrej/php5-oldstable -y ; /usr/bin/apt-get update",
		require => Package["python-software-properties"]
	}

	package { [ "vim", "git", "mysql-client", "php5", "php5-curl", "php5-mysql", "php5-cli", "curl", "apache2", "libapache2-mod-php5", "php5-mcrypt", "php5-xdebug", "mysql-server" ] :
		ensure => present,
		require => Exec["php5-oldstable"]
	}

	service { "apache2":
		ensure => running,
		require => Package["apache2"],
	}

	exec { "/usr/sbin/a2enmod rewrite":
		notify => Service["apache2"],
		require => Package["apache2"]
	}
	
#	exec { "/usr/sbin/php5enmod mcrypt":
#		notify => Service["apache2"],
#		require => Package["apache2"]
#	}

	file { "/etc/apache2/sites-available/default":
		notify => Service["apache2"],
		mode => 644,
		owner => "root",
		group => "root",
		require => Package["apache2"],
		source => "/vagrant/puppet/files/apache/default"
	}

	service { "mysql":
		ensure => running, 
		require => Package["mysql-server"]
	}

	exec { "create-db-schema-and-user":
		command => "/usr/bin/mysql -uroot -e \"CREATE DATABASE IF NOT EXISTS laravel; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES;\"",
		require => Service["mysql"]
	}

	file { "/etc/mysql/my.cnf":
		notify => Service["mysql"],
		mode => 644,
		owner => "root",
		group => "root",
		require => Package["mysql-server"],
		source => "/vagrant/puppet/files/mysql/my.cnf"
	}
	
	exec { "composer":
		command => "/usr/bin/curl -s https://getcomposer.org/installer | /usr/bin/php ; mv composer.phar /usr/local/bin/composer"
	}
	
	exec { "laravel":
		command => "/bin/rmdir /vagrant/laravel ; /usr/local/bin/composer create-project laravel/laravel /vagrant/laravel --prefer-dist 4.2.* ; /bin/chmod -R 777 /vagrant/laravel/app/storage",
		require => Exec["composer"]
	}
	
#	exec { "laravel-packages":
#		command => 'chdir /vagrant/laravel ; composer require "way/generators":"3.*" --prefer-dist --no-update ; composer require "laravelbook/ardent":"2.*" --prefer-dist --no-update ; composer require "aws/aws-sdk-php-laravel":"1.*@dev" --prefer-dist --no-update ; composer require "anahkiasen/former":"1.*@dev" --prefer-dist --no-update ; composer require "patricktalmadge/bootstrapper":"5.*@dev" --prefer-dist --no-update ; composer update',
#		require => Exec["laravel"],
#		path => "/usr/local/bin"
#	}
}

include init


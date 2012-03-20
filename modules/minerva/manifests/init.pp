class minerva {
    apache::vhost { "minerva":
        ensure => present,
        source => "puppet:///modules/minerva/minerva.conf"
    }

    file { "/etc/php5/apache2/conf.d/minerva.ini":
        ensure => present,
        source => "puppet:///modules/minerva/minerva.ini"
    }

    file { "/etc/ldap/ldap.conf":
        ensure => present,
        source => "puppet:///modules/minerva/ldap.conf"    
    }
}

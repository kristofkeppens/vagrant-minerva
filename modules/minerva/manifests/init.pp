class minerva {
    apache::vhost { "minerva":
        ensure => present,
        source => "puppet:///modules/minerva/minerva.conf"
    }
}

import '../config.pp'

class {'openstack::firewall': }
class {'osnailyfacter::tinyproxy': }

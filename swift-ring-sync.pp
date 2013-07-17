include stdlib

$master_swift_proxy_ip = '127.0.0.1'

swift::ringsync { 'account': ring_server => $master_swift_proxy_ip }
swift::ringsync { 'object': ring_server => $master_swift_proxy_ip }
swift::ringsync { 'container': ring_server => $master_swift_proxy_ip }

import 'config.pp'

nova::manage::floating{$floating_hash:}

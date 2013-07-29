if $::role {
  notify{"My role is ${::role}" :}
} else {
  fail('I have no role of nailyfacts are not working!')
}

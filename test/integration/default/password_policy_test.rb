# # encoding: utf-8

# Inspec test for recipe .::password_policy

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/
#
#
#
#
#
#

#options = {
    #assignment_regex: /^\s*[A-Z_a-z]+\s+[A-Za-z0-9]+\s*$,
#    assignment_regex: /^\s*[A-Z_a-z]+\s+[A-Za-z0-9]+\s*$/,
#    assignment_regex: /^\s*([^:]*?)\s*:\s*(.*?)\s*$/,
#    comment_char: '#'
#}


#describe parse_config_file('/etc/login.defs', options) do
# its('PASS_MIN_LEN') { should eq '14' }
#end

describe file('/etc/login.defs') do
  its('content') { should match /^PASS_MIN_LEN.*14$/ }
  #its('content') { should match /^PASS_MIN_LEN.*i<%= node['fai_linux_baseline']['password_length'] %>/ }
end

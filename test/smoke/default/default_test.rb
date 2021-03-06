# # encoding: utf-8

# Inspec test for recipe task1_jboss::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/


  # This is an example test, replace with your own test.
describe user('root') do
  it { should exist }
end

# This is an example test, replace it with your own test.
describe port(80) do
  it { should_not be_listening }
end

describe port(8080) do
  it { should be_listening }
end

describe http('http://192.168.56.222:8080') do
  its('status') { should cmp 200 }
end

describe service("jboss") do
  it { should be_enabled }
  it { should be_running }
end
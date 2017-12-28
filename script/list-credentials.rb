#!/usr/local/bin/ruby -w
require 'json'
require 'pp'

app = ARGV[0]

puts "Reading env from '#{app}'..."
app_env = `cf env #{app}`

sys_env = app_env.split('System-Provided:').last.split("{\n \"VCAP_APP").first.gsub("\n", "")
sys_env = JSON.parse(sys_env)
secret_service = sys_env["VCAP_SERVICES"]["user-provided"].select { |s| s["name"].include?("credentials") }.first

pp secret_service['credentials']

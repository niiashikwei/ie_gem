require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'ie'

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec

namespace :ie9 do
  desc "get ie9 vm ip"
  task :guest_ip do
    (IE.get_ie9_vm_ip.size > 0) ? (puts "found VM with name #{IE.get_ie9_vm_name}") : (puts "couldn't find VM with name #{IE.get_ie9_vm_name}")
  end

  desc "download IE9 and set it up"
  task :setup_vm do
    IE.download_ie9_vm
    IE.unzip_appliance
    IE.import_appliance
  end

  desc "run all cucumber tests against ie vm"
  task :cucumber do
    IE.setup_ie9_env
    `cucumber`
    IE.tear_down_ie9_env
  end
end
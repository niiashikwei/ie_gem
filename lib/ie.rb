require 'ie/version'

module IE
  def self.setup_ie9_env
    ENV[IE9_VM_NAME] = get_ie_vm_ip(9)

    if ENV[IE9_VM_NAME].present? and ( ENV[IE9_VM_NAME].size > 0 )
      setup_ie_env(IE19_VM_NAME)
    end
  end

  def self.setup_ie10_env
    ENV[IE10_VM_NAME] = get_ie_vm_ip(10)

    if ENV[IE10_VM_NAME].present? and ( ENV[IE10_VM_NAME].size > 0 )
      setup_ie_env(IE10_VM_NAME)
    end
  end

  private

  def self.setup_ie_env(ie_vm_name)
    puts "configuring selenium driver to point to #{ie_vm_name} VM at #{ENV[ie_vm_name]}"
    ie_vm_ip = `VBoxManage guestproperty get "#{ie_vm_name}" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{print $NF}'`[0..-2]
    selenium_server_url = "http://#{ie_vm_ip}:4444/wd/hub"

    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app,
                                     :browser => :remote,
                                     :url => selenium_server_url,
                                     :desired_capabilities => :internet_explorer
      )
    end
  end
end

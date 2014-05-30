
module IE
  IE9_VM_NAME = "IE9 - Win7"
  DOWNLOAD_DIR = 'tmp'
  DEPENDENCIES = ['vagrant', 'VBoxManage', 'awk', 'curl', 'unrar']
  CMD_SUCCESSFUL = 0
  CMD_FAILED= 1

  def self.get_ie9_vm_name
    IE9_VM_NAME
  end

  def self.get_ie9_vm_ip
    `VBoxManage guestproperty get "#{IE9_VM_NAME}" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{print $NF}'`[0..-2]
  end

  def self.get_host_ip
    `ifconfig en0 inet | grep inet | awk '{print $2}'`
  end

  def self.setup_ie9_env
    ENV[IE9_VM_NAME] = get_ie9_vm_ip

    if ENV[IE9_VM_NAME].present? and ( ENV[IE9_VM_NAME].size > 0 )
      puts "configuring selenium driver to point to #{IE9_VM_NAME} VM at #{ENV[IE9_VM_NAME]}"
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

  def self.tear_down_ie9_env
    ENV[IE9_VM_NAME] = ""
    Capybara.default_driver = :selenium
  end

  def self.download_ie9_vm
    Dir.mkdir(DOWNLOAD_DIR) unless Dir.entries('.').include?(DOWNLOAD_DIR)
    mac_os? ? download_ie_vm() : puts("Sorry ie gem currently only supports mac os")
  end

  def self.download_ie_vm(ie_version=9)
    Dir.chdir(DOWNLOAD_DIR)
    puts "getting ready to download and setup IE#{ie_version} vm...this takes ~ 14 mins "
    `curl -O -L "http://www.modern.ie/vmdownload?platform=mac&virtPlatform=virtualbox&browserOS=IE9-Win7&parts=4&filename=VMBuild_20131127/VirtualBox/IE9_Win7/Mac/IE9.Win7.For.MacVirtualBox.part{1.sfx,2.rar,3.rar,4.rar}"`
  end

  def self.unzip_appliance
    puts "unziping appliance..."
    system "chmod +x *.sfx"
    system "unrar e IE9.Win7.For.MacVirtualBox.part1.sfx"
  end

  def self.import_appliance
    appliance_path = "#{IE9_VM_NAME}.ova"
    if ie_vm_exists?
      puts "vm with name #{IE9_VM_NAME} already exists!"
    else
      puts "importing '#{appliance_path}' as appliance..."
      system "VboxManage import '#{appliance_path}'"
    end
  end

  def self.ie_vm_exists?
    `VBoxManage list vms | grep '#{IE9_VM_NAME}' | awk '{ print $1 $2 $3}'` == "IE9-Win7"
  end

  def self.dependencies_met?
    missing_dependencies = []
    puts "checking command line tools dependencies...."
    DEPENDENCIES.each do |command_line_tool|
      tool_exists = system "which #{command_line_tool}"
      if tool_exists
        puts "#{command_line_tool} dependency met"
      else
        missing_dependencies << command_line_tool
      end
    end
    puts "Please install the following missing dependencies: \n #{missing_dependencies}" if (missing_dependencies.size > 0)
  end

  def self.mac_os?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

end

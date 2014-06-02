
module IE
  IE9_VM_NAME = "IE9 - Win7"
  IE10_VM_NAME = "IE10 - Win7"
  DOWNLOAD_DIR = 'tmp'
  DEPENDENCIES = ['vagrant', 'VBoxManage', 'awk', 'curl', 'unrar']
  CMD_SUCCESSFUL = 0
  CMD_FAILED = 1

  def self.get_ie10_vm_name
    IE10_VM_NAME
  end

  def self.get_ie9_vm_name
    IE9_VM_NAME
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

  def self.get_host_ip
    `ifconfig en0 inet | grep inet | awk '{print $2}'`
  end

  def self.get_ie_vm_ip(ie_vm_name)
    `VBoxManage guestproperty get "#{ie_vm_name}" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{print $NF}'`[0..-2]
  end

  def self.download_ie_vm(ie_version)
    if mac_os?
      Dir.mkdir(DOWNLOAD_DIR) unless Dir.entries('.').include?(DOWNLOAD_DIR)
      Dir.chdir(DOWNLOAD_DIR)
      puts "getting ready to download and setup IE#{ie_version} vm...this takes ~ 14 mins "
      `curl -O -L "http://www.modern.ie/vmdownload?platform=mac&virtPlatform=virtualbox&browserOS=IE#{ie_version}-Win7&parts=4&filename=VMBuild_20131127/VirtualBox/IE#{ie_version}_Win7/Mac/IE#{ie_version}.Win7.For.MacVirtualBox.part{1.sfx,2.rar,3.rar,4.rar}"`
    else
      puts("Sorry ie gem currently only supports mac os")
    end
  end

  def self.unzip_appliance(ie_version)
    puts "unziping appliance..."
    system "chmod +x *.sfx"
    system "unrar e IE#{ie_version}.Win7.For.MacVirtualBox.part1.sfx"
  end

  def self.import_appliance(ie_vm_name)
    appliance_path = "#{ie_vm_name}.ova"
    if ie_vm_exists?
      puts "vm with name #{ie_vm_name} already exists!"
    else
      puts "importing '#{appliance_path}' as appliance..."
      system "VboxManage import '#{appliance_path}'"
    end
  end

  def self.ie_vm_exists? (ie_vm_name, ie_version)
    `VBoxManage list vms | grep '#{ie_vm_name}' | awk '{ print $1 $2 $3}'` == "IE#{ie_version}-Win7"
  end

  def self.tear_down_ie_env(ie_vm_name)
    ENV[ie_vm_name] = ""
    Capybara.default_driver = :selenium
  end


  def self.mac_os?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end
end

class UrlBuilder
  #platform=mac&virtPlatform=virtualbox&browserOS=IE9-Win7&filename=VirtualBox/IE9_Win7/Mac/
  #parts = ["IE9.Win7.For.MacVirtualBox.part1.sfx", "IE9.Win7.For.MacVirtualBox.part2.rar", "IE9.Win7.For.MacVirtualBox.part3.rar", "IE9.Win7.For.MacVirtualBox.part4.rar"]

  BASE_URL = "http://www.modern.ie/vmdownload?"
  PLATFORM = "mac"
  VIRT_PLATFORM = "virtualbox"
  BROWSER_OS = "IE9-Win7"
  FILENAME = "VirtualBox/IE9_Win7/Mac/IE9.Win7.For.MacVirtualBox.part{1.sfx,2.rar,3.rar,4.rar}"

  def initialize
    self.url = BASE_URL
  end

  def platform
    self.platform = PLATFORM
  end



end
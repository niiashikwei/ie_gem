
module IE
  IE9_VM_NAME = "IE9 - Win7"
  IE10_VM_NAME = "IE10 - Win7"

  def self.get_ie_vm_ip(ie_vm_name)
    `VBoxManage guestproperty get "#{ie_vm_name}" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{print $NF}'`[0..-2]
  end
end

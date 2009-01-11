#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

network(Mash.new)

require_plugin "hostname"
require_plugin "#{os}::network"

def find_ip_and_mac(addresses)
  addresses.each do |addr|
    ipaddress addr["address"] if addr["family"].eql?("inet")
    macaddress addr["address"] if addr["family"].eql?("lladdr")
  end
  [ipaddress, macaddress]
end

if attribute?("default_interface")
  ipaddress, macaddress = find_ip_and_mac(network["interfaces"][iface]["addresses"])
else
  network["interfaces"].keys.each do |iface|
    if network["interfaces"][iface]["encapsulation"].eql?("Ethernet")
      ipaddress, macaddress = find_ip_and_mac(network["interfaces"][iface]["addresses"])
      return if (ipaddress and macaddress)
    end
  end
end
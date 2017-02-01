# File is managed by chef.  Any edits will be overwritten
# encoding: UTF-8
# Ver 1.0
#
# Author:: Chaz Ruhl <cruhl@cars.com>
# License:: Apache License, Version 2.0
# Adapted from the rpm plugin by Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
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
## See the License for the specific language governing permissions and
# limitations under the License.
#
Ohai.plugin(:Lvm) do
  provides 'lvm'

  def create_objects
    lvm Mash.new
  end

  collect_data(:default) do
    create_objects

    # lvm = {}

    lv, _junk, _junk, _junk, _junk, _junk = `mount|grep 'on / '`.split(' ')
    root_vg, root_lv = lv.sub('/dev/mapper/', '').split('-')

    vgs_output = `vgs --nosuffix --units m `.split("\n")
    vgs_output.each do |vg_line|
      vg_name, num_pv, num_lv, _junk, _junk, size, free = vg_line.split(' ')
      unless vg_name == 'VG'
        lvm["#{vg_name}"] = { 'num_pvs' => "#{num_pv}", 'num_lvs' => "#{num_lv}", 'size' => "#{size}", 'free' => "#{free}", 'lvs' => {}, 'pvs' => {} }
      end
    end

    lvs_output = `lvs  --nosuffix --units m `.split("\n")
    lvs_output.each do |lv_line|
      lv_name, vg_name, _junk, size, _junk = lv_line.split(' ')
      unless lv_name == 'LV'
        lvm["#{vg_name}"]['lvs']["#{lv_name}"] = { 'size' => "#{size}" }
        if vg_name == root_vg && lv_name == root_lv
          lvm["#{vg_name}"]['lvs']["#{lv_name}"]['root'] = true
        end
      end
    end

    pvs_output = `pvs  --nosuffix --units m `.split("\n")
    pvs_output.each do |pv_line|
      pv_name, vg_name, _junk, _junk, size, free = pv_line.split(' ')
      unless pv_name == 'PV'
        lvm["#{vg_name}"]['pvs']["#{pv_name}"] = { 'size' => "#{size}", 'free' => "#{free}"  }
      end
    end
  end
end

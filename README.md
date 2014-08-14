ohai-lvm
========

ohai plug-in to gather lvm layout

Install & Config
================

Copy lvm.rb to your ohai plug-ins directory


Use
===

Creates ohai data which looks somthing like this (for each volume group):
```json
{
  "rootvg": {
    "num_pvs": "1",
    "num_lvs": "7",
    "size": "40832.00",
    "free": "5504.00",
    "lvs": {
      "dynalv": {
        "size": "512.00"
      },
      "optlv": {
        "size": "4096.00"
      },
      "rootlv": {
        "size": "2048.00",
        "root": true
      },
      "swaplv": {
        "size": "16384.00"
      },
      "tmplv": {
        "size": "4096.00"
      },
      "usrlv": {
        "size": "4096.00"
      },
      "varlv": {
        "size": "4096.00"
      }
    },
    "pvs": {
      "/dev/mapper/mpath0p2": {
        "size": "40832.00",
        "free": "5504.00"
      }
    }
  }
}
```

import os
import subprocess
import time
import collections
import json
import re
import shutil
import sys
import glob
import datetime
import asciitable
import edalize

from toolchain import Toolchain
from utils import Timed


class VPR(Toolchain):
    '''VPR using Yosys for synthesis'''
    carries = (False, )

    def __init__(self, rootdir):
        Toolchain.__init__(self, rootdir)
        self.toolchain = 'vpr'
        self.files = []

    def run(self):
        with Timed(self, 'bit-all'):
            os.makedirs(self.out_dir, exist_ok=True)

            for f in self.srcs:
                self.files.append(
                    {
                        'name': os.path.realpath(f),
                        'file_type': 'verilogSource'
                    }
                )

            if self.pcf:
                self.files.append(
                    {
                        'name': os.path.realpath(self.pcf),
                        'file_type': 'PCF'
                    }
                )
            if self.sdc:
                self.files.append(
                    {
                        'name': os.path.realpath(self.sdc),
                        'file_type': 'SDC'
                    }
                )

            if self.xdc:
                self.files.append(
                    {
                        'name': os.path.realpath(self.xdc),
                        'file_type': 'xdc'
                    }
                )

            chip = self.family + self.device

            self.edam = {
                'files': self.files,
                'name': self.project_name,
                'toplevel': self.top,
                'tool_options':
                    {
                        'symbiflow':
                            {
                                'part': chip,
                                'package': self.package,
                                'vendor': 'xilinx',
                                'builddir': '.'
                            }
                    }
            }
            self.backend = edalize.get_edatool('symbiflow')(
                edam=self.edam, work_root=self.out_dir
            )
            self.backend.configure("")
            self.backend.build()

    def max_freq(self):

        freqs = {}
        route_log = self.out_dir + '/route.log'
        processing = False

        with open(route_log, 'r') as fp:
            for l in fp:

                if l == "Intra-domain critical path delays (CPDs):\n":
                    processing = True
                    continue

                if processing is True:
                    if len(l.strip('\n')) == 0:
                        processing = False
                        continue

                    fields = l.split(':')
                    group = fields[0].split()[0]
                    freqs[group] = 1e9 / float(fields[1].split()[0].strip())

        return freqs

    def get_vpr_resources(self):
        """
        pack.log:
        (...)
        Pb types usage...
          GND          : 1
          BLK-TL-IOPAD : 2
          lut          : 1
          IOB33_MODES  : 2
          COMMON_LUT_AND_F78MUX : 1
          ALUT         : 1
          COMMON_SLICE : 6
          FDRE         : 24
          REG_FDSE_or_FDRE : 24
          SYN-GND      : 1
          BLK-TL-SLICEL : 6
          CEUSEDMUX    : 6
          CARRY4_VPR   : 6
          outpad       : 1
          A5LUT        : 1
          SLICEL0      : 6
          IOB33        : 2
          CE_VCC       : 24
          SRUSEDMUX    : 6
          inpad        : 1
          SLICE_FF     : 6
          SR_GND       : 24
        (...)
        """
        pack_logfile = self.out_dir + "/pack.log"
        resources = {}
        with open(pack_logfile, 'r') as fp:
            processing = False
            for l in fp:
                l = l.strip()
                if l == "Pb types usage...":
                    processing = True
                    continue

                if not processing:
                    continue
                else:
                    if len(l) == 0:
                        break
                    res = l.split(":")
                    restype = res[0].strip()
                    rescount = int(res[1].strip())
                    resources[restype] = rescount

        return resources

    def resources(self):
        lut = 0
        dff = 0
        carry = 0
        iob = 0
        pll = 0
        bram = 0

        res = self.get_vpr_resources()

        if 'lut' in res:
            lut = res['lut']
        if 'REG_FDSE_or_FDRE' in res:
            dff = dff = res['REG_FDSE_or_FDRE']
        if 'CARRY4_VPR' in res:
            carry = carry + res['CARRY4_VPR']
        if 'outpad' in res:
            iob = iob + res['outpad']
        if 'inpad' in res:
            iob = iob + res['inpad']
        if 'BRAM' in res:
            bram = res['BRAM']
        if 'PLLE2_ADV' in res:
            pll = res['PLLE2_ADV']

        ret = {
            "LUT": str(lut),
            "DFF": str(dff),
            "BRAM": str(bram),
            "CARRY": str(carry),
            "GLB": "unsupported",
            "PLL": str(pll),
            "IOB": str(iob),
        }
        return ret

    @staticmethod
    def yosys_ver():
        # Yosys 0.7+352 (git sha1 baddb017, clang 3.8.1-24 -fPIC -Os)
        return subprocess.check_output(
            "yosys -V", shell=True, universal_newlines=True
        ).strip()

    @staticmethod
    def vpr_version():
        '''
        vpr  --version

        VPR FPGA Placement and Routing.
        Version: 8.0.0-dev+vpr-7.0.5-6027-g94a747729
        Revision: vpr-7.0.5-6027-g94a747729
        Compiled: 2018-06-21T16:45:11 (release build)
        Compiler: GNU 6.3.0 on Linux-4.9.0-5-amd64 x86_64
        University of Toronto
        vtr-users@googlegroups.com
        This is free open source code under MIT license.
        '''
        out = subprocess.check_output(
            "vpr --version", shell=True, universal_newlines=True
        ).strip()
        version = None
        revision = None
        for l in out.split('\n'):
            l = l.strip()
            if l.find('Version:') == 0:
                version = l
            if l.find('Revision:') == 0:
                revision = l
        assert version is not None
        assert revision is not None
        return version + ', ' + revision

    def versions(self):
        return {
            'yosys': VPR.yosys_ver(),
            'vpr': VPR.vpr_version(),
        }

    @staticmethod
    def seedable():
        return True

    @staticmethod
    def check_env():
        return {
            'yosys': have_exec('yosys'),
            'vpr': have_exec(VPR.vpr_bin()),
        }
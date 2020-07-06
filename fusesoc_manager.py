#!/usr/bin/env python3

import os
import subprocess
import sys

root_dir = os.path.dirname(os.path.abspath(__file__))
fusesoc_dir = os.path.join(root_dir, ".cores")


class FuseSoCManager():
    '''Set of functionalities wrapping FuseSoC'''

    def __init__(self):
        args = "--init"

        env = os.environ.copy()
        env["XDG_CACHE_HOME"] = fusesoc_dir
        env["XDG_DATA_HOME"] = fusesoc_dir
        env["XDG_CONFIG_HOME"] = fusesoc_dir
        self.env = env

        if not os.path.exists(fusesoc_dir):
            os.mkdir(fusesoc_dir)
            self.cmd(root_dir + "/fusesoc_manager.sh", args, env=env)

    def setup(self, core, tool, target):
        args = "--setup %s %s %s %s" % (core, fusesoc_dir, tool, target)
        print(args)
        env = os.environ.copy()
        self.cmd(root_dir + "/fusesoc_manager.sh", args, env=env)

    def cmd(self, cmd, argstr, env=None):
        cmdstr = "%s %s" % (cmd, argstr)
        subprocess.check_call(
            cmdstr,
            shell=True,
            executable='bash',
            env=self.env
        )

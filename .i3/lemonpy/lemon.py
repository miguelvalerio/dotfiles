import sys
import asyncio
import subprocess
import configparser
import importlib


config = configparser.ConfigParser()
config.read('config.ini')

p1 = subprocess.Popen(["lemonbar", "-f", "Font Awesome:regular:size=10"],
                      stdin=subprocess.PIPE, universal_newlines=True)
loop = asyncio.get_event_loop()
sys.stdout = p1.stdin
for section in config.sections():
    module_name = config[section]['module']
    module = importlib.import_module('modules.{}'.format(module_name))
    loop.run_until_complete(module.run())
loop.close()

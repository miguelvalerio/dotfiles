import asyncio
import sys
import ast
from utils import set_fg_bg


@asyncio.coroutine
def run():
    proc = yield from asyncio.create_subprocess_exec(
        sys.executable, '-c', "import i3; i3.subscribe('workspace', '')",
        stdout=asyncio.subprocess.PIPE)

    while True:
        line = yield from proc.stdout.readline()
        line = line.decode('utf-8')
        layout = ast.literal_eval(line)
        workspaces = []
        for ws in layout:
            if ws['focused']:
                workspaces.append(set_fg_bg(ws['name'], fg='#FF0000'))
            else:
                workspaces.append(set_fg_bg(ws['name']))
        output = ''.join(workspaces)
        print(output)
        sys.stdout.flush()

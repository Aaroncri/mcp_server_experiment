from fastmcp import FastMCP, Contextimport
import subprocess
import os 
from make_filesystem import root, make_all

mcp = FastMCP("File Explorer")

@mcp.tool()
def cd(dir: str) -> str:
    '''
    If: 
    1. dir the name of a directory which is a direct child of the 
    working directoy
    2. 
    '''
    try: 
        root_path = root()
    except Exception as e: 
        raise RuntimeError(f"Failed to get root_path!: {e}")
    
    try: 
        if not os.path.exists(root_path):
            make_all()
            curr = root_path
        else:
            curr = os.getcwd()
            escaped = os.path.commonpath([root_path, curr]) !=  root_path
            if escaped: 
                os.chdir(root_path)
                curr = os.getcwd()
                
    except Exception as e: 
        raise RuntimeError(f"Failed to build file system: {e}")

    try: 
        p = os.path.abspath(os.path.join(curr, dir))
    except: 
        raise RuntimeError("Failed to create dir path object!")
    
    in_root = os.path.commonpath([root_path, p]) == root_path

    if not in_root:
        return "You may not escape the containment area!"
    
    if os.path.exists(p):
        os.chdir(p)
        return f"Success, now in dir: {os.path.relpath(os.getcwd(), root_path)}!"
    else:
        return "Failure, no such directory!"

@mcp.resource("greeting://{name}")
def get_greeting(name: str) -> str:
    return f"Hello, {name}!"


import subprocess
import os 
from pathlib import Path

from __future__ import annotations
from pathlib import Path

class RootedPath:
    """
    Path wrapper that never escapes *project_root*.

    >>> root = ProjectPath("/home/aaron/proj")       # anchor once
    >>> src  = root / "src" / "server"
    >>> print(src)                                   # /home/aaron/proj/src/server
    >>> src.parent()                                 # /home/aaron/proj/src
    >>> (root / "..")                                # ValueError: path escapes project root
    """

    # ── construction ────────────────────────────────────────────
    def __init__(self, project_root: str | Path, rel: str | Path = "."):
        project_root = Path(project_root).resolve()
        full         = (project_root / rel).resolve()

        if not full.is_relative_to(project_root):
            raise ValueError(f"{full} escapes project root {project_root}")

        self._root: Path = project_root
        self._abs : Path = full                      # absolute current path

    # ── core helpers ────────────────────────────────────────────
    def root(self) -> Path:
        """Return the immutable project root."""
        return self._root

    def path(self) -> Path:
        """Return the absolute Path this object represents."""
        return self._abs

    def rel(self) -> Path:
        """Path relative to the project root."""
        return self._abs.relative_to(self._root)

    # ── joining / traversal ────────────────────────────────────
    def __truediv__(self, part: str | Path) -> "RootedPath":
        return RootedPath(self._root, self.rel() / part)

    def parent(self) -> "RootedPath":
        if self._abs == self._root:
            raise RuntimeError("Already at project root; cannot go higher")
        return RootedPath(self._root, self.rel().parent)

    # ── string and fspath protocol ─────────────────────────────
    def __str__(self) -> str:
        return str(self._abs)

    __fspath__ = __str__          # lets open(), pathlib, etc. accept us

    # ── delegation of common Path predicates ───────────────────
    exists   = lambda self: self._abs.exists()
    is_file  = lambda self: self._abs.is_file()
    is_dir   = lambda self: self._abs.is_dir()
    iterdir  = lambda self: (self / p.name for p in self._abs.iterdir())

def FileExplorer:

def project_root(marker: str = ".project-root") -> Path:
    """Walk up from this file until *marker* is found; return that directory."""
    here = Path(__file__).resolve()
    for parent in here.parents:
        if (parent / marker).exists():
            return parent
    raise RuntimeError(f"Could not find project root containing {marker!r}")

def challenge_dir():
    return project_root() / "data/challenge_dir"

def go_up(): 
    os.chdir("../")    

def reset(): 
    rt = root()
    os.chdir(rt)

def make_all():
    try:
        rt = root()
        root_name = os.path.abspath(rt)
    except Exception as e: 
        raise RuntimeError(f"Could not extract root path in make_all() call: {e}")
    
    try: 
        if os.path.exists(rt): 
            subprocess.run(["rm",  "-r",  root_name])
    except: 
        raise RuntimeError("Failed to clear root directory in make_all")

    try:
        #Set up directory
        create_parent = ["mkdir",  "-p",  root_name]
        subprocess.run(create_parent)
    except: 
        raise RuntimeError("Failed to create root directory!")

    def reset(): 
        os.chdir(rt)

    try: 
        reset() 
    except: 
        raise RuntimeError("Failed to change dir to root")

    #Make child command
    make_child = (lambda name: ["mkdir", "-p", f"./{name}"])

    #Create random text files
    names = [f"dir_{chr(c)}" for c in range(ord('a'), ord('f'))]

    for name in names: 
        subprocess.run(make_child(name))
        os.chdir(f"{name}")
        for name2 in names: 
            subprocess.run(make_child(name2))
            os.chdir(f"{name2}")

            for i in range(3):
                path = f"./file_{i}.txt"
                subprocess.run(["touch", path])
                message = os.urandom(16).hex()
                with open(path, 'w') as f: 
                    f.write(message)
            go_up()
        go_up()
        
    return rt
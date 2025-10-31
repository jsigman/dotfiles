# ~/.pdbrc.py — unified config supporting pdbp and pdb
import atexit, os, readline
from os.path import expanduser

# Try to import pdbp if available
try:
    import pdbp as pdb
    USING_PDBP = True
except ImportError:
    import pdb
    USING_PDBP = False

# Common persistent history setup
HISTFILE = expanduser("~/.pdb_history")
try:
    readline.read_history_file(HISTFILE)
except FileNotFoundError:
    pass
atexit.register(readline.write_history_file, HISTFILE)
readline.set_history_length(1000)

# pdbp-specific config
if USING_PDBP and hasattr(pdb, "DefaultConfig"):
    from pygments.styles import get_style_by_name

    class Config(pdb.DefaultConfig):
        filename_color = pdb.Color.fuchsia
        line_number_color = pdb.Color.turquoise
        truncate_long_lines = False
        sticky_by_default = True
        use_pygments = True
        highlight = True
        use_terminal256formatter = True
        colorscheme = None
        bg = "dark"

        # optional pygments theme override (examples: 'monokai', 'native', 'solarized-dark')
        pygments_style = get_style_by_name("native")

        # persistent history path
        histfile = HISTFILE
        history = 1000

    pdb.DefaultConfig = Config

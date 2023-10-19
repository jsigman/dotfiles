import pdb
from fancycompleter import Color

def _pdbrc_init():
    """Save history across sessions."""

    import atexit
    import readline
    from os import getenv
    from pathlib import Path

    XDG_CACHE_HOME = getenv("XDG_CACHE_HOME", "~/.cache")

    HIST_FILE = getenv("PDB_HIST_FILE", f"{XDG_CACHE_HOME}/python/pdb_history")
    HIST_SIZE = getenv("PDB_HIST_SIZE", "10000")

    history_file = Path(HIST_FILE).expanduser().resolve()
    history_length = int(HIST_SIZE)

    if not history_file.exists():
        history_file.parent.mkdir(parents=True, exist_ok=True)
        history_file.touch()

    readline.read_history_file(history_file)
    readline.set_history_length(history_length)

    atexit.register(readline.write_history_file, history_file)

_pdbrc_init()

del _pdbrc_init

class Config(pdb.DefaultConfig):
        
    prompt = "(Pdb++) "
    highlight = True
    sticky_by_default = True
    bg = "dark"
    use_pygments = True
    colorscheme = None
    use_terminal256formatter = None  # Defaults to `"256color" in $TERM`.
    editor = "${EDITOR:-vi}"  # use $EDITOR if set, else default to vi
    stdin_paste = None  # for emacs, you can use my bin/epaste script
    truncate_long_lines = True
    exec_if_unfocused = None
    disable_pytest_capturing = False
    encodings = ("utf-8", "latin-1")

    enable_hidden_frames = True
    show_hidden_frames_count = True

    line_number_color = Color.red
    filename_color = Color.red
    current_line_color = "39;49;7"  # default fg, bg, inversed

    show_traceback_on_error = True
    show_traceback_on_error_limit = None

    # Default keyword arguments passed to ``Pdb`` constructor.
    default_pdb_kwargs = {}

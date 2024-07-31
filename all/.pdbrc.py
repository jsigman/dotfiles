import pdb
import pdbp
from pygments.styles import get_style_by_name


if hasattr(pdb, "DefaultConfig"):
    pdb.DefaultConfig.filename_color = pdb.Color.fuchsia
    pdb.DefaultConfig.line_number_color = pdb.Color.turquoise
    pdb.DefaultConfig.truncate_long_lines = False
    pdb.DefaultConfig.sticky_by_default = True
    pdb.DefaultConfig.use_pygments = True
    pdb.DefaultConfig.highlight = True
    pdb.DefaultConfig.use_terminal256formatter = True
    pdb.DefaultConfig.colorscheme = None
    pdb.DefaultConfig.bg = "dark"

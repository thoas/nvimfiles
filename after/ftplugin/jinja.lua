vim.bo.commentstring = "{# %s #}"

-- if, ifelse, block, url, static + <Tab> (see snippets/jinja.json)
require("config.snippets").tab_expand("jinja")

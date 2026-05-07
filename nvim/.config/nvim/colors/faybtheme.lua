vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.g.colors_name = "faybtheme"

local colors = {
  bg = "#1e181e",
  fg = "#c3c0b5",
  sidebar_bg = "#211421",
  sidebar_fg = "#c3c0b5",
  cursorline = "#211925",
  selection = "#56036b",
  search = "#ff7b00",
  inc_search = "#4b6153",
  pmenu_bg = "#003f2f",
  pmenu_sel = "#211421",
  border = "#000000",

  -- Code colors
  comment = "#8B8772",
  string = "#CED87F",
  keyword = "#FF0080",
  function_name = "#54FE50",
  variable = "#FF8040",
  type = "#FEF93A",           -- Classes, Types, Enums
  property = "#8D81FE",
  parameter = "#57E6FF",
  constant = "#FE61FA",       -- Numbers, Constants, Macros
  namespace = "#B7B7DB",
  label = "#BA55D3",
  event = "#B0E0E6",

  -- UI/Git
  error = "#fc618d",
  warning = "#fd9353",
  info = "#5ad4e6",
  hint = "#4f4f4f",
  git_add = "#7bd88f",
  git_change = "#fd9353",
  git_delete = "#fc618d",
}

local highlights = {
  -- Base editor
  Normal = { fg = colors.fg, bg = colors.bg },
  NormalFloat = { fg = colors.fg, bg = colors.sidebar_bg },
  ColorColumn = { bg = colors.cursorline },
  Cursor = { fg = colors.bg, bg = "#fce566" },
  CursorLine = { bg = colors.cursorline },
  CursorColumn = { bg = colors.cursorline },
  LineNr = { fg = colors.fg },
  CursorLineNr = { fg = "#fce566", bold = true },
  Visual = { bg = colors.selection },
  Search = { bg = colors.search, fg = colors.bg },
  IncSearch = { bg = colors.inc_search, fg = colors.fg },
  SignColumn = { bg = colors.sidebar_bg },
  VertSplit = { fg = colors.border },
  WinSeparator = { fg = colors.border },

  -- Pmenu (Autocomplete)
  Pmenu = { fg = colors.fg, bg = colors.pmenu_bg },
  PmenuSel = { bg = colors.pmenu_sel, fg = colors.fg },
  PmenuSbar = { bg = colors.pmenu_bg },
  PmenuThumb = { bg = colors.fg },

  -- Syntax
  Comment = { fg = colors.comment },
  String = { fg = colors.string },
  Number = { fg = colors.constant },
  Boolean = { fg = colors.constant },
  Float = { fg = colors.constant },
  Identifier = { fg = colors.variable },
  Function = { fg = colors.function_name, bold = true },
  Statement = { fg = colors.keyword },
  Conditional = { fg = colors.keyword },
  Repeat = { fg = colors.keyword },
  Label = { fg = colors.label, bold = true },
  Operator = { fg = colors.keyword },
  Keyword = { fg = colors.keyword },
  Exception = { fg = colors.keyword },
  PreProc = { fg = colors.constant },
  Include = { fg = colors.keyword },
  Define = { fg = colors.keyword },
  Macro = { fg = colors.constant, bold = true },
  Type = { fg = colors.type, bold = true },
  StorageClass = { fg = colors.type },
  Structure = { fg = colors.type },
  Typedef = { fg = colors.type },
  Special = { fg = colors.property },
  Delimiter = { fg = colors.fg },
  Debug = { fg = colors.constant },

  -- Diagnostics
  DiagnosticError = { fg = colors.error },
  DiagnosticWarn = { fg = colors.warning },
  DiagnosticInfo = { fg = colors.info },
  DiagnosticHint = { fg = colors.hint },
  DiagnosticUnderlineError = { undercurl = true, sp = colors.error },
  DiagnosticUnderlineWarn = { undercurl = true, sp = colors.warning },

  -- GitSigns
  GitSignsAdd = { fg = colors.git_add, bg = colors.sidebar_bg },
  GitSignsChange = { fg = colors.git_change, bg = colors.sidebar_bg },
  GitSignsDelete = { fg = colors.git_delete, bg = colors.sidebar_bg },

  -- TreeSitter Specific
  ["@namespace"] = { fg = colors.namespace },
  ["@class"] = { fg = colors.type, bold = true },
  ["@type"] = { fg = colors.type, bold = true },
  ["@property"] = { fg = colors.property, bold = true },
  ["@parameter"] = { fg = colors.parameter, bold = true },
  ["@variable"] = { fg = colors.variable },
  ["@variable.builtin"] = { fg = colors.variable },
  ["@function"] = { fg = colors.function_name, bold = true },
  ["@function.builtin"] = { fg = colors.function_name },
  ["@keyword"] = { fg = colors.keyword },
  ["@constructor"] = { fg = colors.type },
  ["@operator"] = { fg = colors.keyword },

  -- NeoTree / NvimTree
  NeoTreeNormal = { fg = colors.sidebar_fg, bg = colors.sidebar_bg },
  NeoTreeNormalNC = { fg = colors.sidebar_fg, bg = colors.sidebar_bg },
  NeoTreeWinSeparator = { fg = colors.border, bg = colors.sidebar_bg },

  -- Telescope
  TelescopeBorder = { fg = colors.border, bg = colors.bg },
  TelescopeNormal = { bg = colors.bg },
  TelescopePromptNormal = { bg = colors.sidebar_bg },
  TelescopePromptBorder = { fg = colors.border, bg = colors.sidebar_bg },
  TelescopeSelection = { bg = colors.pmenu_bg },
}

for group, hl in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, hl)
end

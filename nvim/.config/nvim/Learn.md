# Learn

# Basic
- @: to repeat last command

# Gitsigns
- step through stage hunks
- view diff in hunk

# LSP
Completion
- <Enter>: Confirms selection.
- <Ctrl-y>: Confirms selection.
- <Up>: Navigate to previous item on the list.
- <Down>: Navigate to the next item on the list.
- <Ctrl-p>: Navigate to previous item on the list.
- <Ctrl-n>: Navigate to the next item on the list.
- <Ctrl-u>: Scroll up in the item's documentation.
- <Ctrl-f>: Scroll down in the item's documentation.
- <Ctrl-e>: Toggles the completion.
- <Ctrl-d>: Go to the next placeholder in the snippet.
- <Ctrl-b>: Go to the previous placeholder in the snippet.
- <Tab>: Enables completion when the cursor is inside a word. If the completion menu is visible it will navigate to the next item in the list.
- <S-Tab>: When the completion menu is visible navigate to the previous item in the list.

Jumping
- K: Displays hover information about the symbol under the cursor in a floating window. See :help vim.lsp.buf.hover().
- gd: Jumps to the definition of the symbol under the cursor. See :help vim.lsp.buf.definition().
- gD: Jumps to the declaration of the symbol under the cursor. Some servers don't implement this feature. See :help vim.lsp.buf.declaration().
- gi: Lists all the implementations for the symbol under the cursor in the quickfix window. See :help vim.lsp.buf.implementation().
- go: Jumps to the definition of the type of the symbol under the cursor. See :help vim.lsp.buf.type_definition().
- gr: Lists all the references to the symbol under the cursor in the quickfix window. See :help vim.lsp.buf.references().
- <Ctrl-k>: Displays signature information about the symbol under the cursor in a floating window. See :help vim.lsp.buf.signature_help(). If a mapping already exists for this key this function is not bound.
- <F2>: Renames all references to the symbol under the cursor. See :help vim.lsp.buf.rename().
- <F4>: Selects a code action available at the current cursor position. See :help vim.lsp.buf.code_action().

Diagnostics
- gl: Show diagnostics in a floating window. See :help vim.diagnostic.open_float().
- [d: Move to the previous diagnostic in the current buffer. See :help vim.diagnostic.goto_prev().
- ]d: Move to the next diagnostic. See :help vim.diagnostic.goto_next().

Command line window mode
q: for command line window
while in command line mode, ctrl-f for command line window

Netrw
- Vexplore, then move through explore and preview files with p. Allows you to quickly view files in directory
- cd to cd into current directory
- Exploring: N before command is the window size
    - Lexplore: traditional file tree explorer
        - vexplore will split the current window whereas Lexplore will spilt the whole tab (more traditional)
    - Texplore: explorer in tab
- i to toggle modes (tree mode) (aka liststyle)
- mc and mF
- X execute filename under cursor via system
- Maybe make a open Lexplore with tree plugin?
- u to go to previous directory (can repeat) - think as a back button
    - U for opposite

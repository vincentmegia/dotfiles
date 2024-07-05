-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local basepath = '/Users/vincem'
local workspace_dir = basepath .. '/Repository/' .. project_name
--                                               ^^
--                                               string concattenation in Lua
local config = {
  --[[   cmd = { '/opt/homebrew/bin/jdtls' }, ]]
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- ??
    'java', -- or '/path/to/java17_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '-javaagent:/Users/vincem/Repository/tools/jdtls/lombok.jar',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- ??
    '-jar', '/opt/homebrew/Cellar/jdtls/1.37.0/libexec/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version


    -- ??
    '-configuration', '/opt/homebrew/Cellar/jdtls/1.37.0/libexec/config_mac_arm',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.


    -- ??
    -- See `data directory configuration` section in the README
    '-data', workspace_dir
  },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },
  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {
      vim.fn.glob(basepath .. "/Repository/tools/java-debug/bin/com.microsoft.java.debug.plugin*.jar", 1)
    }
  },
  on_attach = function()
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "" })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "" })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "" })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "" })
    --[[ vim.keymap.set('n', '<leader>df', '<Cmd>lua require("jdtls").test_class()<CR>')
    vim.keymap.set('n', '<leader>dn', '<Cmd>lua require("jdtls").test_nearest_method()<CR>') ]]
  end
}
require('jdtls').start_or_attach(config)
--[[ require("jdtls.dap").setup_dap_main_class_configs() -- discover main class ]]
--[[ require("jdtls.setup").add_commands()               -- not related to debugging but you probably want this ]]

local bo = vim.bo

bo.tabstop = 4
bo.shiftwidth = 4
bo.expandtab = true
bo.softtabstop = 4

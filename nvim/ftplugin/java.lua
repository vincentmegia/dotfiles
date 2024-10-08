local fn = vim.fn
local project_name = fn.fnamemodify(fn.getcwd(), ":p:h:t")
local basepath = "/Users/vincem"
local workspace_dir = basepath .. "/Repository/tools/jdtls-workspace/" .. project_name
local jdtls_dir = "/opt/homebrew/Cellar/jdtls/1.40.0"

local bundles = {}
local java_test_bundle =
	vim.split(fn.glob(basepath .. "/repository/tools/java-debug/bin/com.microsoft.java.debug.plugin-*.jar"), "\n")
if java_test_bundle[1] ~= "" then
	vim.list_extend(bundles, java_test_bundle)
end

local java_debug_bundle = vim.split(fn.glob(basepath .. "/repository/tools/vscode-java-test/server/*.jar"), "\n")
if java_debug_bundle[1] ~= "" then
	vim.list_extend(bundles, java_debug_bundle)
end
-- This is the new part

local config = {
	cmd = {
		"java", -- or '/path/to/java17_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=DEBUG",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"-javaagent:" .. basepath .. "/Repository/tools/jdtls/lombok.jar",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- ??
		"-jar",
		jdtls_dir .. "/libexec/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
		-- Must point to the                                                     Change this to
		-- eclipse.jdt.ls installation                                           the actual version

		-- ??
		"-configuration",
		jdtls_dir .. "/libexec/config_mac_arm",
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.

		-- ??
		-- See `data directory configuration` section in the README
		"-data",
		workspace_dir,
	},
	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			signatureHelp = {
				enabled = true,
				description = { enabled = true },
			},
		},
	},
	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = bundles,
	},
	--[[ 	on_attach = function() end, ]]
}
require("jdtls").start_or_attach(config)

local bo = vim.bo
bo.tabstop = 4
bo.shiftwidth = 4
bo.expandtab = true
bo.softtabstop = 4

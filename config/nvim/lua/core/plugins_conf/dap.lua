-- lua/core/plugins_conf/dap.lua
local dap = require("dap")
local dapui = require("dapui")

-- Basic DAP setup
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- Keymaps (add these to your keymaps.lua or here)
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug: Kill debugger" })
vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Debug: Open REPL" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })

dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        args = { require("mason-registry").get_package("js-debug-adapter"):get_install_path() .. "/js-debug/src/dapDebugServer.js", "${port}" },
    },
}


require("dap.ext.vscode").load_launchjs(nil, { ["pwa-node"] = { "javascript", "typescript" } })

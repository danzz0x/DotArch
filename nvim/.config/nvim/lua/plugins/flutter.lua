return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "dart" },
    config = function()
      require("flutter-tools").setup({
        lsp = {
          on_attach = function(_, bufnr)
            local map = function(keys, func, desc)
              if desc then
                desc = "LSP: " .. desc
              end
              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            end

            map("gd", vim.lsp.buf.definition, "Ir a definición")
            map("K", vim.lsp.buf.hover, "Mostrar documentación")
            map("<leader>rn", vim.lsp.buf.rename, "Renombrar símbolo")
            map("<leader>ca", vim.lsp.buf.code_action, "Acción de código")
            map("<leader>f", function()
              vim.lsp.buf.format({ async = true })
            end, "Formatear documento")
          end,
        },
        flutter_path = "flutter",
        dev_log = {
          enabled = true,
          open_cmd = "tabedit",
        },
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "Comment",
          prefix = "// ",
          enabled = true,
        },
      })
    end,
  },
}

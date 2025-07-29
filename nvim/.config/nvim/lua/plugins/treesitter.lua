return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Asegura que estos lenguajes estén instalados
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "blade", "php", "html" })

      -- Agrega soporte automático para archivos .blade.php
      vim.filetype.add({
        pattern = {
          [".*%.blade%.php"] = "blade",
        },
      })

      -- Agrega manualmente el parser Blade desde GitHub
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }
    end,
  },
}

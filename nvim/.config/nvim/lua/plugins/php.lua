return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "intelephense" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              environment = {
                phpVersion = "8.2",
                includePaths = {
                  "vendor/laravel/framework/src",
                  "vendor/livewire/livewire/src",
                  "vendor/illuminate",
                },
              },
              files = {
                maxSize = 5000000,
              },
              stubs = {
                "laravel",
                "eloquent",
                "blade",
                "helpers",
                "core",
                "collections",
                "phpunit",
                "filesystem",
                "support",
              },
            },
          },
        },
      },
    },
  },
}

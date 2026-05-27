return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 1. Disable the standard servers
        pyright = { enabled = false },
        basedpyright = { enabled = false },

        -- 2. Setup Astral's ty
        ty = {
          settings = {
            ty = {
              analysis = {
                -- This activates the "Strict" behavior manually
                -- ty currently uses a granular rule system for strictness
                typeCheckingMode = "strict",
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                -- Explicit strict rules if 'strict' mode isn't enough
                reportMissingTypeStubs = "error",
                reportUntypedFunctionDecorator = "error",
                reportUnknownParameterType = "error",
                reportUnknownArgumentType = "error",
                reportUnknownLambdaType = "error",
                reportUnknownVariableType = "error",
                reportUnknownMemberType = "error",
                reportMissingParameterType = "error",
                reportMissingReturnType = "error",
              },
            },
          },
        },
      },
    },
  },
}

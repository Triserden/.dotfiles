{lib, config, ...}: 
{
  options = {
    nixvim.enable = lib.mkEnableOption "Enable nixvim";
  };
  
  config = lib.mkIf config.nixvim.enable {
    programs.nixvim = {
      enable = true;

      colorschemes.catppucin.enable = true;

      opts = {
        number = true;
        relativenumber = true;

        shiftwidth = 4;
      };
      
      clipboard.providers.wl-copy.enable = true;

      lsp.servers = {
        "*" = {
          settings = {
            capabilities = {
              textDocument = {
                semanticTokens = {
                  multilineTokenSupport = true;
                };
              };
            };
            root_markers = [
              ".git"
            ];
          };
        };
        basedpyright = {
          enable = true;
        };
        tailwindcss-language-server = {
          enable = true;
        };
        rust-analyzer = {
          enable = true;
        };
        arduino-language-server = {
          enabled = true;
        };
        nixd = {
         enable = true;
        };
        clangd = {
          enable = true;
          settings = {
            cmd = [
              "clangd"
              "--background-index"
            ];
            filetypes = [
              "c"
              "cpp"
            ];
            root_markers = [
              "compile_commands.json"
              "compile_flags.txt"
            ];
          };
        };
        luals = {
          enable = true;
        };
      };

      plugins = {
        auto-save.enable = true;
        which-key.enable = true;
        telescope.enable = true;
        lspconfig.enable = true;
        gitsigns.enable = true;
        nvim-surround = true;

        };
      };
    };
}

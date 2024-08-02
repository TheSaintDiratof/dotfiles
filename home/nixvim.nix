{ settings }:
{

  enable = true;
  
  keymaps = [
    { key = "<Space>1"; action = "1gt"; }
    { key = "<Space>2"; action = "2gt"; }
    { key = "<Space>3"; action = "3gt"; }
    { key = "<Space>4"; action = "4gt"; }
    { key = "<Space>5"; action = "5gt"; }
    { key = "<Space>6"; action = "6gt"; }
    { key = "<Space>7"; action = "7gt"; }
    { key = "<Space>8"; action = "8gt"; }
    { key = "<Space>9"; action = "9gt"; }
    { key = "<Space>0"; action = "10gt"; }
    { key = "ф"; action = "a"; }
    { key = "к"; action = "p"; }
    { key = "е"; action = "y"; }
    { key = "ю"; action = "v"; }
    { key = "<F5>"; action = "!./.build.sh"; }
  ];
  opts = {
    number = true;
    relativenumber = false;

    shiftwidth = 2;
    tabstop = 2;
    smartindent = true;
    expandtab = true;
  };


  files = {
    "ftplugin/json.lua".opts = {
      shiftwidth = 2;
      tabstop = 2;
    };
    "ftplugin/nix.lua".opts = {
      shiftwidth = 2;
      tabstop = 2;
    };
  };

  plugins = {
		cmp = {
      enable = true;

      settings = {
        snippet.expand = "luasnip";

        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-Space>" = "cmp.mapping.complete()";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };

        sources = [
          { name = "path"; }
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "cmp_tabby"; }
          { name = "treesitter"; }
        ];
      };
    };
    lsp = {
      enable = true;

      servers = {
        clangd.enable = true;
        tsserver.enable = true;

        nil-ls = {
          enable = true;
          settings = {
            formatting.command = [ "nixpkgs-fmt" ];
          };
        };
      };
    };

    neo-tree.enable = true;
    nix.enable = true;
    nvim-autopairs.enable = true;

    treesitter = {
      enable = true;
      nixvimInjections = true;
      indent = true;
    };
  };
  colorschemes.base16 = {
    colorscheme = {
      base00 = "#${settings.colors.base00}"; 
      base01 = "#${settings.colors.base01}";
      base02 = "#${settings.colors.base02}";
      base03 = "#${settings.colors.base03}";
      base04 = "#${settings.colors.base04}";
      base05 = "#${settings.colors.base05}";
      base06 = "#${settings.colors.base06}";
      base07 = "#${settings.colors.base07}";
      base08 = "#${settings.colors.base08}";
      base09 = "#${settings.colors.base09}";
      base0A = "#${settings.colors.base0A}";
      base0B = "#${settings.colors.base0B}";
      base0C = "#${settings.colors.base0C}";
      base0D = "#${settings.colors.base0D}";
      base0E = "#${settings.colors.base0E}";
      base0F = "#${settings.colors.base0F}";
    };
    enable = true;
  };
}


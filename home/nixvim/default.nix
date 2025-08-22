{ settings, pkgs}:
{
  programs.nixvim = {
    enable = true;
    extraConfigLua = ''
      function GoToDefinitionInTab()
        local params = vim.lsp.util.make_position_params()
        vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, _)
          if err then
            vim.notify("Error fetching definition: " .. err.message, vim.log.levels.ERROR)
            return
          end
          if not result or vim.tbl_isempty(result) then
            vim.notify("No definition found", vim.log.levels.INFO)
            return
          end
          local location = result[1]
          if location.uri then
            local bufnr = vim.uri_to_bufnr(location.uri)
            if not vim.api.nvim_buf_is_loaded(bufnr) then
                vim.fn.tabnew() -- Open a new tab
                vim.api.nvim_win_set_buf(0, bufnr) -- Set the buffer in the new tab
            else
                vim.cmd("tabedit " .. vim.uri_to_fname(location.uri)) -- Open in a new tab
            end
            vim.api.nvim_win_set_cursor(0, { location.range.start.line + 1, location.range.start.character })
          end
        end)
      end
    '';

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
      { key ="<Space>p"; action = "lua GoToDefinitionInTab()"; }
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
          ts_ls.enable = true;
          matlab_ls = {
            enable = true;
            cmd = [ "${pkgs.matlab-language-server}/bin/matlab-language-server" "--stdio" ];
            filetypes = [ "m" ];
          };
          nil_ls = {
            enable = true;
            settings = {
              formatting.command = [ "nixpkgs-fmt" ];
            };
          };
        };
      };

      neo-tree.enable = true;
      neo-tree.filesystem.cwdTarget.sidebar = "left";
      nix.enable = true;
      nvim-autopairs.enable = true;
      web-devicons.enable = true;

      treesitter = {
        enable = true;
        nixvimInjections = true;
        settings.indent.enable = true;
      };
    };
    colorschemes.base16 = {
      colorscheme = (builtins.listToAttrs 
        (builtins.map (x: { name = "base0${x}"; value = "#"+settings.colors."base0${x}";}) 
        [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" ]));
      enable = true;
    };
  };
}


{ pkgs }:
{
  enable = true;
  withNodeJs = true;
  withRuby = false;
  withPython3 = false;
  vimAlias = false;
  viAlias = false;
  extraConfig = ''set ts=4
    set softtabstop=0 noexpandtab
    set shiftwidth=4
    syntax on
    set number
    set mouse=a
    colorscheme gruvbox
    set background=dark
    map <Space>1 1gt
    map <Space>2 2gt
    map <Space>3 3gt
    map <Space>4 4gt
    map <Space>5 5gt
    map <Space>6 6gt
    map <Space>7 7gt
    map <Space>8 8gt
    map <Space>9 9gt
    map <Space>0 10gt
    map ф a
    map <F5> !./.build.sh
    
    " use <tab> to trigger completion and navigate to the next complete item
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    
    inoremap <silent><expr> <Tab>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
'';
  plugins = with pkgs.vimPlugins; [
    vim-nix
    lightline-vim
    indent-blankline-nvim
    gruvbox
    clangd_extensions-nvim
    coc-nvim
  ];
  coc = {
    enable = false;
    settings = {
      languageserver = {
        nix = {
          command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
          filetypes = [ "nix" ];
        };
        clangd = {
          command = "${pkgs.clang-tools}/bin/clangd";
          rootPatterns = ["compile_flags.txt" "compile_commands.json"];
          filetypes = ["c" "cc" "cpp" "c++" "objc" "objcpp"];
        };
      };
    };
  };
}

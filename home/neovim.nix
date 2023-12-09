{ pkgs }:
{
  enable = true;
  withNodeJs = false;
  withRuby = false;
  withPython3 = false;
  vimAlias = true;
  viAlias = false;
  coc.enable = true;
  extraConfig = ''set ts=2
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
'';
  plugins = with pkgs.vimPlugins; [
    vim-nix
    lightline-vim
    fzf-vim
    coc-nvim
    indent-blankline-nvim
    nerdtree
    gruvbox
  ];
}

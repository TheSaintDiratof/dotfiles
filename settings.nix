{ pkgs }:
let 
  colors = {
    ultrablack    = "000000";
  
    brightBlack   = "928374";
    brightRed     = "FB4934";
    brightGreen   = "B8BB26";
    brightYellow  = "FABD2F";
    brightBlue    = "83A598";
    brightPurple  = "D3869D";
    brightAqua    = "8EC07C";
    brightGray    = "EBDBB2";
  
    black         = "282828";
    red           = "CC241D";
    green         = "98971A";
    yellow        = "D79921";
    blue          = "458588";
    purple        = "B16286";
    aqua          = "689D6A";
    gray          = "A89984";
  };
  st = (import ./xorg/st.nix { inherit pkgs colors; }).st;
in{
  videoDrivers = [ "amdgpu" ];
  vulkanLoader = [ pkgs.amdvlk ];
  vulkanLoader32 = [ pkgs.driversi686Linux.amdvlk ];

  colors = colors;

  #terminal = "${st}/bin/st";
  terminal = "${pkgs.foot}/bin/foot";
}

{ pkgs, settings }: let 
  i3lock = pkgs.writeShellScriptBin "i3lock.sh" ''
    ${pkgs.i3lock-color}/bin/i3lock -e -i /etc/nixos/assets/wallpaper.png -F --keylayout 2\
           --pass-media-keys --pass-volume-keys\
           --time-str='%H:%M:%S' --date-str='%a, %d/%m/%y'\
           --time-color=999999 --time-pos='1200:700'\
           --date-color=999999 --layout-col=999999\
           --time-size=80 &
    if [ "$1" == "-s" ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
  screenshot = pkgs.writeShellScriptBin "screenshot.sh" ''
    FILE=$HOME/.local/tmp/$(date +%d%m%y_%H%M%S).png
    if [ "$1" == "-p" ]; then
      export FLAGS="-s -u -o $FILE"
    else
      export FLAGS="-u -o $FILE"
    fi
    echo $FLAGS
    if ${pkgs.maim}/bin/maim $FLAGS; then
      ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i < $FILE
    fi
  '';
  bash = "${pkgs.bash}/bin/bash";
in {
  mydwm = pkgs.dwm.override {
    conf = pkgs.writeText "config.h" ''
      /* appearance */
      //static const int barheight = 4;
      static const unsigned int borderpx  = 1;        /* border pixel of windows */
      static const unsigned int snap      = 32;       /* snap pixel */
      static const int showbar            = 1;        /* 0 means no bar */
      static const int topbar             = 1;        /* 0 means bottom bar */
      static const char *fonts[]          = { "Terminus:size=12:style=Bold" };
      static const char dmenufont[]       = "Terminus:size=12:style=Bold";
      static const char col_bg[]          = "#${settings.colors.black}";
      static const char col_fg[]          = "#${settings.colors.brightGray}";
      static const char col_gray[]        = "#${settings.colors.gray}";
      static const char col_black[]       = "#${settings.colors.ultrablack}";
      static const char col_white[]       = "#${settings.colors.brightGray}";
      static const char *colors[][3]      = {
      	/*               fg         bg         border   */
      	[SchemeNorm] = { col_fg, col_bg, col_gray },
      	[SchemeSel]  = { col_black, col_white,  col_gray  },
      };
      
      /* tagging */
      static const char *tags[] = { "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX" };
      
      static const Rule rules[] = {
      	/* xprop(1):
      	 *	WM_CLASS(STRING) = instance, class
      	 *	WM_NAME(STRING) = title
      	 */
      	/* class      instance    title       tags mask     isfloating   monitor */
      	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
      	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
        { "Steam",    NULL,       NULL,       1 << 7,       0,           -1 },
      };
      
      /* layout(s) */
      static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
      static const int nmaster     = 1;    /* number of clients in master area */
      static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
      static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
      
      static const Layout layouts[] = {
      	/* symbol     arrange function */
      	{ "[]=",      tile },    /* first entry is default */
      	{ "><>",      NULL },    /* no layout function means floating behavior */
      	{ "[M]",      monocle },
      };
      
      /* key definitions */
      #define MODKEY Mod4Mask
      #define TAGKEYS(KEY,TAG) \
      	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
      	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
      	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
      	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },
      
      /* helper for spawning shell commands in the pre dwm-5.0 fashion */
      #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
      
      /* commands */
      static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
      static const char *dmenucmd[] = { "${pkgs.dmenu}/bin/dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_bg, "-nf", col_fg, "-sb", col_white, "-sf", col_black, NULL };
      static const char *termcmd[]  = { "${settings.terminal}", NULL };
      static const char *tmuxtermcmd[] = {"${settings.terminal}", "-e", "${pkgs.tmux}/bin/tmux", "a", NULL};
      static const char *rofi[] = {"${pkgs.rofi}/bin/rofi", "-show", "drun", NULL};
      static const char *lock[] = {"${i3lock}/bin/i3lock.sh", NULL};
      static const char *suspend[] = {"${i3lock}/bin/i3lock.sh", "-s", NULL};
      static const char *screenshot[] = {"${screenshot}/bin/screenshot.sh", NULL};
      static const char *screenshotpart[] = {"${screenshot}/bin/screenshot.sh", "-p", NULL};
      static const char *mprisprev[] = {"${pkgs.playerctl}/bin/playerctl", "previous", NULL};
      static const char *mprisnext[] = {"${pkgs.playerctl}/bin/playerctl", "next", NULL};
      static const char *mprisplay[] = {"${pkgs.playerctl}/bin/playerctl", "play-pause", NULL};
      static const char *mprisstop[] = {"${pkgs.playerctl}/bin/playerctl", "stop", NULL};
      static const char *pulselower[] = {"${pkgs.pulseaudio}/bin/pactl", "set-sink-volume", "@DEFAULT_SINK@",   "-1%",    NULL};
      static const char *pulseraise[] = {"${pkgs.pulseaudio}/bin/pactl", "set-sink-volume", "@DEFAULT_SINK@",   "+1%",    NULL};
      static const char *micmute[] =    {"${pkgs.pulseaudio}/bin/pactl", "set-source-mute", "@DEFAULT_SOURCE@", "toggle", NULL};
      static const char *outmute[] =    {"${pkgs.pulseaudio}/bin/pactl", "set-sink-mute",   "@DEFAULT_SINK@",   "toggle", NULL};
      
      static const Key keys[] = {
      	/* modifier                     key        function        argument */
      	{ MODKEY,                       XK_d,      spawn,          {.v = dmenucmd } },
      	{ MODKEY|ShiftMask,             XK_d,      spawn,          {.v = rofi } },
      	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
      	{ MODKEY,                       XK_Return, spawn,          {.v = tmuxtermcmd } },
      	{ 0,                            XK_Pause,  spawn,          {.v = lock } },
        { MODKEY|ShiftMask,             XK_Pause,  spawn,          {.v = suspend } },
      	{ MODKEY,                       XK_grave,  spawn,          {.v = screenshotpart } },
        { 0,                            XK_Print,  spawn,          {.v = screenshot } },
        { MODKEY,                       XK_F5,     spawn,          {.v = mprisstop } },
        { MODKEY,                       XK_F6,     spawn,          {.v = mprisprev } },
        { MODKEY,                       XK_F7,     spawn,          {.v = mprisplay } },
        { MODKEY,                       XK_F8,     spawn,          {.v = mprisnext } },
        { MODKEY,                       XK_F2,     spawn,          {.v = pulselower } },
        { MODKEY,                       XK_F3,     spawn,          {.v = pulseraise } },
        { MODKEY,                       XK_F4,     spawn,          {.v = outmute } },
        { 0,                            XK_Menu,   spawn,          {.v = micmute } },
      	{ MODKEY,                       XK_b,      togglebar,      {0} },
      	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
      	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
      	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
      	{ MODKEY,                       XK_o,      incnmaster,     {.i = -1 } },
      	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
      	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
      	//{ MODKEY,                       XK_Return, zoom,           {0} },
      	{ MODKEY,                       XK_Tab,    view,           {0} },
      	{ MODKEY|ShiftMask,             XK_q,      killclient,     {0} },
      	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
      	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
      	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
      	{ MODKEY|Mod1Mask,              XK_x,      setlayout,      {0} },
      	{ MODKEY|ShiftMask,             XK_x,      togglefloating, {0} },
      	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
      	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
      	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
      	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
      	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
      	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
      	TAGKEYS(                        XK_1,                      0)
      	TAGKEYS(                        XK_2,                      1)
      	TAGKEYS(                        XK_3,                      2)
      	TAGKEYS(                        XK_4,                      3)
      	TAGKEYS(                        XK_5,                      4)
      	TAGKEYS(                        XK_6,                      5)
      	TAGKEYS(                        XK_7,                      6)
      	TAGKEYS(                        XK_8,                      7)
      	TAGKEYS(                        XK_9,                      8)
      	{ MODKEY|ShiftMask,             XK_e,      quit,           {0} },
      };
      
      /* button definitions */
      /* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
      static const Button buttons[] = {
      	/* click                event mask      button          function        argument */
      	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
      	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
      	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
      	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
      	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
      	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
      	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
      	{ ClkTagBar,            0,              Button1,        view,           {0} },
      	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
      	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
      	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
      };
    '';
  };
}

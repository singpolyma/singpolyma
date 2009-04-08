/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]            = "-*-terminus-medium-r-normal-*-14-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#cccccc";
static const char normbgcolor[]     = "#cccccc";
static const char normfgcolor[]     = "#000000";
static const char selbordercolor[]  = "#0066ff";
static const char selbgcolor[]      = "#0066ff";
static const char selfgcolor[]      = "#ffffff";
static unsigned int borderpx        = 1;        /* border pixel of windows */
static unsigned int snap            = 32;       /* snap pixel */
static Bool showbar                 = True;     /* False means no bar */
static Bool topbar                  = True;     /* False means bottom bar */
static Bool readin                  = True;     /* False means do not read stdin */
static Bool usegrab                 = False;    /* True means grabbing the X server
                                                   during mouse-based resizals */

/* tagging */
static const char tags[][MAXTAGLEN] = { "www", "term", "im", "mail", "irc", "6", "7", "8", "media" };
static unsigned int tagset[] = {2, 2}; /* after start, first tag is selected */

static Rule rules[] = {
	/* class      instance    title       tags mask     isfloating */
	{ "Gimp",     NULL,       NULL,       0,            True },
	{ NULL,       NULL,       "Passphrase",       0,    True },
	{ NULL,       NULL,       "Network Settings", 0, True },
	{ NULL,       NULL,       "gksu",             0, True },
	{ NULL,       NULL,       "System Monitor",   0, True },
	{ "Firefox",  NULL,       NULL,       1 << 0,       False },
	{ "X-www-browser",  NULL, NULL,       1 << 0,       False },
	{ "URxvt",    NULL,       NULL,       1 << 1,       False },
	{ "Gedit",    NULL,       NULL,       1 << 1,       False },
	{ "Thunar",   NULL,       NULL,       1 << 1,       False },
	{ NULL,       NULL,       "Psi",      1 << 2,       False },
	{ NULL,       NULL,       "mutt",     1 << 3,       False },
	{ NULL,       NULL,       "irssi",    1 << 4,       False },
	{ NULL,       NULL,       "cmus",     1 << 8,       False },
	{ NULL,       NULL,       "mediacentre",      1 << 8,       False },
};

/* layout(s) */
static float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static Bool resizehints = True; /* False means respect size hints in tiled resizals */

static Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[] = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "rxvt", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY|ControlMask,           XK_space,  spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ 0,                            XK_F4,     spawn,          {.v = termcmd } },
	{ 0,                            XK_F5,     spawn,          SHCMD("thunar ~/") },
	{ 0,                            XK_F6,     spawn,          SHCMD("exec xterm -name cmus -e cmus") },
	{ MODKEY,                       XK_F6,     spawn,          SHCMD("exec xterm -name mediacentre -e ssh singpolyma.dnsalias.net") },
	{ 0,                            XK_F7,     spawn,          SHCMD("sensible-browser") },
	{ MODKEY,                       XK_F7,     spawn,          SHCMD("psi") },
	{ 0,                            XK_F8,     spawn,          SHCMD("exec xterm -name mutt -e mutt") },
	{ MODKEY,                       XK_F8,     spawn,          SHCMD("exec xterm -name irssi -e irssi") },
	{ MODKEY|ControlMask,           XK_l,      spawn,          SHCMD("sleep 0.1 && slock") },
	{ MODKEY|ControlMask,           XK_Delete, spawn,          SHCMD("gnome-power-cmd.sh shutdown") },
	{ MODKEY,                       XK_Tab,    focusstack,     {.i = -1} },
	{ MODKEY,                       XK_Tab,    zoom,           {0} },
	{ MODKEY,                       XK_F4,     killclient,     {0} },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be a tag number (starting at 0),
 * ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
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


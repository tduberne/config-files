--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
-- pour eviter les plantages d'interfaces java
import XMonad.Hooks.SetWMName

import XMonad.Layout.Maximize
-- import XMonad.Layout.MosaicAlt
-- import XMonad.Layout.Tabbed
-- import XMonad.Layout.SimpleFloat
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Reflect

-- for video fullscreen
-- import XMonad.Hooks.ManageHelpers

-- permettre redimensionnement les zones à la souris (non présent):
-- import XMonad.Layout.BorderResize

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
-- myTerminal = "Terminal"
myTerminal = "gnome-terminal"

-- Width of the window border in pixels.
--
myBorderWidth = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt"). You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2 Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
-- myNumlockMask = mod2Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces = ["1:web","2:mail","3","4","5","6","7","8","9","10:ide"]

-- Border colors for unfocused and focused windows, respectively.
--
-- myNormalBorderColor = "#cdf9cd"
-- myNormalBorderColor = "#dddddd"
myFocusedBorderColor = "#ffc018"
myNormalBorderColor = "#ffe9ad"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launch a terminal
    [ ((modMask, xK_Return), spawn $ XMonad.terminal conf)
    -- launch internet navigator
    , ((modMask, xK_f ), spawn "firefox")
    -- launch file Explorator
    , ((modMask .|. shiftMask, xK_t ), spawn "thunar")
    -- lanch mail client
    , ((modMask, xK_c ), spawn "thunderbird")
	-- launch VYM
	, ((modMask, xK_v), spawn "vym")
	-- launch Vlc
	, ((modMask .|. shiftMask, xK_v), spawn "vlc")
    -- launch dmenu
    , ((modMask, xK_d ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    -- launch xfce4-launcher
    -- equivalent à alt+F2
    -- mod P utilisé pour Mendeley
    -- , ((modMask, xK_p ), spawn "xfrun4")
    -- lanch Mendeley
   , ((modMask, xK_p ), spawn "mendeleydesktop")
    -- launch gmrun
    , ((modMask .|. shiftMask, xK_p ), spawn "xfce4-appfinder")
    -- close focused window
    , ((modMask .|. shiftMask, xK_c ), kill)
     -- Rotate through the available layout algorithms
    , ((modMask, xK_space ), sendMessage NextLayout)
    -- Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modMask, xK_n ), refresh)
    -- Move focus to the next window
    , ((modMask, xK_Tab ), windows W.focusDown)
    -- Move focus to the next window
    , ((modMask, xK_j ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modMask, xK_k ), windows W.focusUp )
    -- Move focus to the master window
    , ((modMask .|. shiftMask, xK_m ), windows W.focusMaster )
    -- Maximize the focused window temporarily
    , ((modMask, xK_m ), withFocused $ sendMessage . maximizeRestore)
    -- Swap the focused window and the master window
    , ((modMask .|. shiftMask, xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j ), windows W.swapDown )
    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k ), windows W.swapUp )
    -- Shrink the master area
    , ((modMask, xK_h ), sendMessage Expand)
    -- Expand the master area
    , ((modMask, xK_l ), sendMessage Shrink)
    -- Push window back into tiling
    , ((modMask, xK_t ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modMask , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modMask , xK_period), sendMessage (IncMasterN (-1)))
    -- , ((modMask , xK_semicolon), sendMessage (IncMasterN (-1)))
    -- TODO, update this binding with avoidStruts , ((modMask , xK_b ),
    -- Quit xmonad
    --, ((modMask .|. shiftMask, xK_q ), io (exitWith ExitSuccess))
    , ((modMask .|. shiftMask, xK_q ), spawn "xfce4-session-logout")
    -- Restart xmonad
    , ((modMask , xK_q ), restart "xmonad" True)
    -- to hide/unhide the panel
    , ((modMask , xK_b), sendMessage ToggleStruts)
	-- resizable tile bindings
	, ((modMask , xK_a), sendMessage MirrorShrink)
	, ((modMask , xK_z), sendMessage MirrorExpand)
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        -- | (i, k) <- zip (XMonad.workspaces conf) [0x26,0xe9,0x22,0x27,0x28,0x2d,0xe8,0x5f,0xe7,0xe0]
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_e, xK_w, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts. Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout =  smartBorders( reflectHoriz $ ResizableTall 1 (3/100) (1/2) [] ) ||| smartBorders(Mirror(ResizableTall 1 (3/100) (1/2) [])) ||| noBorders Full --- ||| simpleFloat -- ||| MosaicAlt M.empty -- ||| simpleTabbed
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio = 1/2

     -- Percent of screen to increment by when resizing panes
     delta = 3/100


------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer" --> doFloat
    , className =? "Gimp" --> (ask >>= doF . W.sink)
    , className =? "Xfce4-appfinder" --> doFloat
    , className =? "Xfrun4" --> doFloat
    , className =? "Xfce4-notes-plugin" --> doFloat
    , className =? "Xfce4-settings-manager" --> doFloat
    , className =? "orage" --> doFloat
    -- 2 instances suivantes: pop ups Scid (et sûrement d'autres...)
    , className =? "tipsWin" --> doFloat
    , className =? "Toplevel" --> doFloat
    -- fenetre telechargements iceweasel
    , className =? "Download" --> doFloat
    , title =? "Téléchargements" --> doFloat
    -- calendrier claws mail
    , title =? "Nouveau rendez-vous" --> doFloat
    -- recherche Claws mail
    , title =? "Chercher dans le message" --> doFloat
    -- fenetre preferences de beaucoup de logiciels
    , title =? "Préférences" --> doFloat
    , className =? "nm-editor" --> doFloat
    , className =? "Orage" --> doFloat
    , className =? "vtk" --> doFloat
    , className =? "bluetooth-sendto" --> doFloat
	, title =? "Authentification" --> doFloat
    -- , resource =? "desktop_window" --> doIgnore
    , resource =? "kdesktop" --> doIgnore 
	, title =? "R Graphics: Device 2 (ACTIVE)" --> doFloat
	-- mixer xfce
	, title =? "Mixer - HDA Intel (Alsa mixer)" --> doFloat
	, className =? "xfce4-mixer" --> doFloat
	-- attacher aux workspaces
	, className =? "Navigator" --> doF (W.shift "1:web")
	, className =? "Iceweasel" --> doF (W.shift "1:web")
	, className =? "Icedove" --> doF (W.shift "2:mail")
	, className =? "Eclipse" --> doF (W.shift "10:ide")
	, className =? "Rambox" --> doF (W.shift "9")
	-- pour un vrai full-screen
	-- TODO: retrouver un moyen de tiller les full-screen (comme avec ancienne
	-- version)
	-- , isFullscreen --> doFullFloat
	]

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False


------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
-- myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q. Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad $ ewmh defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal = myTerminal,
        focusFollowsMouse = myFocusFollowsMouse,
        borderWidth = myBorderWidth,
        modMask = myModMask,
        -- numlockMask = myNumlockMask,
        workspaces = myWorkspaces,
        normalBorderColor = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys = myKeys,
        mouseBindings = myMouseBindings,

      -- hooks, layouts
        -- layoutHook = ewmhDesktopsLayout $ avoidStruts $ myLayout,
        layoutHook = avoidStruts $ myLayout,
        manageHook = manageDocks <+> myManageHook,
        logHook = ewmhDesktopsLogHook >> setWMName "LG3D",
        startupHook = myStartupHook
    }

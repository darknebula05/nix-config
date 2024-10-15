{
  lib,
  pkgs,
  inputs,
  config,
  osConfig,
  ...
}:
let
  cfg = config.camms.hyprland;
in
with lib;
{
  options.camms.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = { };
      extraConfig = ''
        monitor=eDP-1,highrr,auto,1.5667
        monitor=DP-3,highrr,auto,1
        monitor=,1920x1080@60,auto,1

        xwayland {
            force_zero_scaling = true
        }

        env = GDK_SCALE,1.5
        env = XCURSOR_SIZE,24

        input {
            numlock_by_default=true
            follow_mouse=1

            touchpad {
                natural_scroll=yes
            }

            touchdevice {
                output=DP-1
            }
        }

        general {
            gaps_in=0
            gaps_out=0
            border_size=2
            # col.active_border=0xff6666aa
            # col.inactive_border=0xff000000

            #cursor_inactive_timeou.enablet=5
        }

        animations {
            true=true
            animation=windows,1,4,default,slide
            animation=border,1,10,default
            animation=fade,1,10,default
            animation=workspaces,1,3,default,fade
        }

        gestures {
            workspace_swipe=no
        }

        misc {
            disable_hyprland_logo=true
            disable_splash_rendering=true
        }

        # example window rules
        # for windows named/classed as abc and xyz
        #windowrule=move 69 420,abc
        #windowrule=size 420 69,abc
        #windowrule=tile,xyz
        #windowrule=float,abc
        #windowrule=pseudo,abc
        #windowrule=monitor 0,xyz
        windowrule=float,title:Picture-in-Picture
        windowrule=pin,title:Picture-in-Picture
        windowrule=float,title:Picture in picture
        windowrule=pin,title:Picture in picture

        # some nice mouse binds
        bindm=SUPER,mouse:272,movewindow
        bindm=SUPER,mouse:273,resizewindow

        # example binds
        bind=CTRL_ALT,DELETE,exec,systemctl suspend
        bind=SUPER,Q,exec,kitty
        bind=SUPER,RETURN,exec,alacritty
        bind=SUPER,C,killactive,
        bind=SUPER,M,exit,
        bind=SUPER,E,exec,dolphin
        bind=SUPER,V,togglefloating,
        bind=SUPER,F,fullscreen
        bind=SUPER,R,exec,fuzzel
        bind=SUPER_SHIFT,R,exec,wofi -d -o DP-3 | xargs hyprctl dispatch exec
        bind=SUPER,P,pseudo
        bind=SUPER,p,togglefloating
        bind=SUPER,p,pin

        bind=SUPER,left,movefocus,l
        bind=SUPER,right,movefocus,r
        bind=SUPER,up,movefocus,u
        bind=SUPER,down,movefocus,d
        bind=SUPER,h,movefocus,l
        bind=SUPER,l,movefocus,r
        bind=SUPER,k,movefocus,u
        bind=SUPER,j,movefocus,d

        bind=SUPER_SHIFT,h,movewindow,l
        bind=SUPER_SHIFT,l,movewindow,r
        bind=SUPER_SHIFT,k,movewindow,u
        bind=SUPER_SHIFT,j,movewindow,d

        bind=SUPER,1,workspace,1
        bind=SUPER,2,workspace,2
        bind=SUPER,3,workspace,3
        bind=SUPER,4,workspace,4
        bind=SUPER,5,workspace,5
        bind=SUPER,6,workspace,6
        bind=SUPER,7,workspace,7
        bind=SUPER,8,workspace,8
        bind=SUPER,9,workspace,9
        bind=SUPER,0,workspace,10

        bind=SUPER_SHIFT,1,movetoworkspace,1
        bind=SUPER_SHIFT,2,movetoworkspace,2
        bind=SUPER_SHIFT,3,movetoworkspace,3
        bind=SUPER_SHIFT,4,movetoworkspace,4
        bind=SUPER_SHIFT,5,movetoworkspace,5
        bind=SUPER_SHIFT,6,movetoworkspace,6
        bind=SUPER_SHIFT,7,movetoworkspace,7
        bind=SUPER_SHIFT,8,movetoworkspace,8
        bind=SUPER_SHIFT,9,movetoworkspace,9
        bind=SUPER_SHIFT,0,movetoworkspace,10

        bind=SUPER,mouse_down,workspace,e+1
        bind=SUPER,mouse_up,workspace,e-1

        bind=,XF86AudioRaiseVolume,exec,pamixer -i 5
        bind=,XF86AudioLowerVolume,exec,pamixer -d 5
        bind=,XF86AudioStop,exec,playerctl stop
        bind=,XF86AudioPrev,exec,playerctl previous
        bind=,XF86AudioPlay,exec,playerctl play-pause
        bind=SUPER_SHIFT,F10,exec,playerctl play-pause
        bind=,XF86AudioNext,exec,playerctl next
        bind=SHIFT,XF86AudioPrev,exec,playerctld shift
        bind=SHIFT,XF86AudioPlay,exec,playerctl -a play-pause
        bind=SHIFT,XF86AudioNext,exec,playerctld unshift
        bind=,XF86MonBrightnessUp,exec,brightnessctl s +10%
        bind=,XF86MonBrightnessDown,exec,brightnessctl s 10%-

        bind=SUPER,Delete,submap,pass_keys
        submap=pass_keys
        bind=SUPER,Delete,submap,reset
        submap=reset

        bind=ALT,r,submap,resize
        submap=resize
        binde=,l,resizeactive,10 0
        binde=,h,resizeactive,-10 0
        binde=,k,resizeactive,0 -10
        binde=,j,resizeactive,0 10

        binde=SHIFT,l,resizeactive,-10 0
        binde=SHIFT,h,resizeactive,10 0
        binde=SHIFT,k,resizeactive,0 10
        binde=SHIFT,j,resizeactive,0 -10

        binde=SHIFT,l,moveactive,10 0
        binde=SHIFT,h,moveactive,-10 0
        binde=SHIFT,k,moveactive,0 -10
        binde=SHIFT,j,moveactive,0 10

        bind=ALT,r,submap,reset
        submap=reset

        bind=,XF86AudioMedia,exec,sleep 1 && hyprctl dispatch dpms off
        bind=SHIFT,XF86AudioMedia,exec,sleep 1 && hyprctl dispatch dpms on
        bind=SUPER_SHIFT,F11,exec,sleep 1 && hyprctl dispatch dpms off
        bind=SUPER,F11,exec,sleep 1 && hyprctl dispatch dpms on
        bind=,Print,exec,grimshot copy area


        exec-once=hyprpaper
        exec-once=$POLKIT_BIN
        exec-once=eww open bar
        exec-once=udiskie -ANt
        exec-once=fcitx5
        exec-once=blueman-applet
        exec-once=[workspace 1 silent] kitty
        exec-once=[workspace 2 silent] brave
        #exec-once=[workspace 3 silent] obsidian
        exec-once=[workspace 10 silent;fullscreen] kitty btop
      '';
    };

    home.packages = with pkgs; [
      gammastep
      hyprpaper
      networkmanagerapplet
      pamixer
      pavucontrol
      playerctl
      sway-contrib.grimshot
      tigervnc
      waypipe
      wl-clipboard
      xdg-desktop-portal-hyprland
      zoom-us
    ];
    services.playerctld.enable = true;
    # home.file.".config/hypr/hyprpaper.conf".text = ''
    #   preload = ~/Pictures/wallpapers/black-sand-dunes.jpg
    #   wallpaper = DP-3,~/Pictures/wallpapers/black-sand-dunes.jpg 
    #   preload = ~/Pictures/wallpapers/death_star.jpg
    #   wallpaper = eDP-1,/home/cameron/Pictures/wallpapers/death_star.jpg
    # '';
    programs = {
      eww = mkIf (osConfig.camms.variables.ewwDir or null != null) {
        enable = true;
        package = pkgs.eww;
        configDir = osConfig.camms.variables.ewwDir;
      };
      fuzzel = {
        enable = true;
        settings = {
          main.show-actions = true;
        };
      };
    };
  };
}

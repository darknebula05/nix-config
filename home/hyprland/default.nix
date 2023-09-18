{ config, pkgs, ... }:

{
  imports = [ ./packages.nix ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [ ", highrr, auto, 1" ];
      input = {
        kb_options = "ctrl:nocaps";
        numlock_by_default = true;
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "0x66ee1111";
        "col.inactive_border" = "0x66333333";
      };

      animations = {
        enabled = true;
        animation = [
          "windows, 1, 4, default, slide"
          "border, 1, 10, default"
          "fade, 1, 10, default"
          "workspaces, 1, 3, default, fade"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      windowrule = [
        "float, title:Picture-in-Picture"
        "pin, title:Picture-in-Picture"
        "float, title:Picture in Picture"
        "pin, title:Picture in Picture"
      ];

      bind = [
        "CTRL_ALT,DELETE,exec,systemctl suspend"
        "SUPER,Q,exec,kitty"
        "SUPER,RETURN,exec,alacritty"
        "SUPER,C,killactive,"
        "SUPER,M,exit,"
        "SUPER,E,exec,dolphin"
        "SUPER,V,togglefloating,"
        "SUPER,F,fullscreen"
        "SUPER,R,exec,wofi --show drun -o DP-3"
        "SUPER,P,pseudo,"

        "SUPER,left,movefocus,l"
        "SUPER,right,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,down,movefocus,d"
        "SUPER,h,movefocus,l"
        "SUPER,l,movefocus,r"
        "SUPER,k,movefocus,u"
        "SUPER,j,movefocus,d"

        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER,8,workspace,8"
        "SUPER,9,workspace,9"
        "SUPER,0,workspace,10"

        "SUPER_SHIFT,1,movetoworkspace,1"
        "SUPER_SHIFT,2,movetoworkspace,2"
        "SUPER_SHIFT,3,movetoworkspace,3"
        "SUPER_SHIFT,4,movetoworkspace,4"
        "SUPER_SHIFT,5,movetoworkspace,5"
        "SUPER_SHIFT,6,movetoworkspace,6"
        "SUPER_SHIFT,7,movetoworkspace,7"
        "SUPER_SHIFT,8,movetoworkspace,8"
        "SUPER_SHIFT,9,movetoworkspace,9"
        "SUPER_SHIFT,0,movetoworkspace,10"

        "SUPER,mouse_down,workspace,e+1"
        "SUPER,mouse_up,workspace,e-1"

        ",XF86AudioRaiseVolume,exec,pamixer -i 5"
        ",XF86AudioLowerVolume,exec,pamixer -d 5"
        ",XF86AudioStop,exec,playerctl stop"
        ",XF86AudioPrev,exec,playerctl previous"
        ",XF86AudioPlay,exec,playerctl play-pause"
        "SUPER_SHIFT,F10,exec,playerctl play-pause"
        ",XF86AudioNext,exec,playerctl next"
        "SHIFT,XF86AudioPrev,exec,playerctld shift"
        "SHIFT,XF86AudioPlay,exec,playerctl -a play-pause"
        "SHIFT,XF86AudioNext,exec,playerctld unshift"
        ",XF86MonBrightnessUp,exec,brightnessctl s +10%"
        ",XF86MonBrightnessDown,exec,brightnessctl s 10%-"

        "SUPER_SHIFT,F11,exec,sleep 1 && hyprctl dispatch dpms off"
        "SUPER,F11,exec,sleep 1 && hyprctl dispatch dpms on"
        ",Print,exec,grimshot copy area"
      ];
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
      exec-once = [
        
      ];
    };
  };
}

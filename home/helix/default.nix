{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight";
      editor = {
        line-number = "relative";
        bufferline = "always";
        lsp.display-messages = true;
        cursor-shape.insert = "bar";
      };
      keys = {
        normal = {
          esc = [ "collapse_selection" "keep_primary_selection" ];
          space.w = ":w";
          space.q = ":q";
          "C-[" = [ "collapse_selection" "keep_primary_selection" ];
        };
        insert."C-[" = "normal_mode";
      };
    };
    languages = [
      {
        name = "rust";
        auto-format = true;
        config.checkOnSave.command = "clippy";
      }
    ];
  };
}

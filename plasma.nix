{ ... }:

{
  programs.plasma = {
    enable = true;

    # Global keyboard shortcuts
    shortcuts = {
      kwin = {
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
	"Switch to Desktop 5" = "Meta+5";
	"Switch to Desktop 6" = "Meta+6";
	"Switch to Desktop 7" = "Meta+7";
        "Window Close" = "Meta+C";
      };

      plasmashell = {
        "activate task manager entry 1" = "Meta+F1";
        "activate task manager entry 2" = "Meta+F2";
        "activate task manager entry 3" = "Meta+F3";
        "activate task manager entry 4" = "Meta+F4";
        "activate task manager entry 5" = "Meta+F5";
        "activate task manager entry 6" = "Meta+F6";
	"activate task manager entry 7" = "Meta+F7";
      };

      "services/org.kde.konsole.desktop" = {
        "_launch" = "Meta+Return";
      };

      "services/org.kde.krunner.desktop" = {
        "_launch" = "Meta+Space";
        "RunClipboard" = "Meta+Shift+Space";
      };
    };

    # Four virtual desktops, one row.
    configFile = {
      kwinrc.Desktops = {
        Number = 6;
        Rows = 1;
      };
    };
  };
}

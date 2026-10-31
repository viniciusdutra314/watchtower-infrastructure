
{lib,... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "timer"];
      theme = "bira";
    };
    localVariables = {
      TIMER_PRECISION = 2;
      TIMER_FORMAT = "⏱ %d";
      TIMER_THRESHOLD = 0;
    };
  };
}

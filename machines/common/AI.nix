{ pkgs, ... }:
{
  home.file.".agents/skills" = {
    source = ../../chloe/skills;
    recursive = true;
  };
  home.packages = with pkgs; [
    codex
  ];
}

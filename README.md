# TAS Kit
VScript tools for Left 4 Dead 2 TAS

Note: The core of **TASK** is Library of Utils which greatly expands the possibilities in scripting

# Features
* Timer

* Countdown

* Auto Bunnyhop

* Aimbot

* Ragebot

* Simple Autostrafer

* Auto Spitterboost

* Auto Climb for ladders

* Auto Shove

* Fill bot

* Advanced hooks for convenient using

* Custom Spawn for CI

* Various tools package

* Chat commands

# Installing
Download the release archive, place **tas_kit.vpk** and **finales_hook_master.vpk** in ***Left 4 Dead 2/left4dead2/addons/*** folder

You can use **remove_timer.vpk** addon to hide Timer during demo playback

Place **main.nut** file in ***Left 4 Dead 2/left4dead2/scripts/vscripts/*** folder

Find **sm_input_emulator.smx** plugins (needed for Auto Climb) in the archive and place it in your SourceMod folder with plugins

# Documentation
HTML files placed in ***docs*** folder: description of functions, chat commands and name of items/weapons

# Main file / Point of entry
During restart of speedrun ***main.nut*** file will be executed, see the comments in the file to clarify how to work with it

Two ways to (re)start speedrun: chat command ***!restart*** or via bind ***bind b "script RestartSpeedrun()"***

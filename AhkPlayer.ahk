/*
��һ��:^+F5
��һ��: ^+F3
��ͣ:^+P
�����б�:!F10
��ʾ���ظ��:!F8
����������!F9
��ת��ָ��ʱ�䣺!F3
�༭��ʣ�!F5
��ʾ���ؽ��棺!F7
�ƶ����λ�ã�!F6
�˳���^+E
*/


#Persistent
#NoTrayIcon
#SingleInstance force
SetBatchLines, 10ms
#MaxThreads,255
CoordMode, ToolTip
SingleCycle := false
run_iniFile = %A_ScriptDir%\settings\setting.ini
IniRead, AhkMediaLib, %run_iniFile%, AhkPlayer, AhkMediaLib
IniRead, AutoUpdateMediaLib, %run_iniFile%, AhkPlayer, AutoUpdateMediaLib
IniRead, Lrcfontcolor, %run_iniFile%, AhkPlayer, Lrcfontcolor
IniRead, LrcPath, %run_iniFile%, AhkPlayer, LrcPath
IniRead, followmouse, %run_iniFile%, AhkPlayer, followmouse
IniRead, PlayListdefalut, %run_iniFile%, AhkPlayer, PlayListdefalut
IniRead, PlayRandom, %run_iniFile%, AhkPlayer, PlayRandom
IniRead, huifushangci, %run_iniFile%, AhkPlayer, huifushangci

hidelrc=0
PlaylistIndex:=0
AhkMediaLibFile = %A_ScriptDir%\settings\mp3s.txt
AhkMediaListFile =  %A_ScriptDir%\settings\playlist.txt
SingleCycleFile = %A_ScriptDir%\settings\SingleCycle.txt
If (PlayListdefalut="t")
NowPlayFile := AhkMediaListFile
else
NowPlayFile := AhkMediaLibFile

Gui, 2: +alwaysontop -Caption +Owner -SysMenu
Gui, 2:Margin, 0
Gui, 2:Color, FF0F0F
Gui, 2:Font, s24,msyh    ;Gui, 2:Font, s24 bold
Gui, 2:add, Text, w1000 r1.9 c%Lrcfontcolor% vlrc,
posy:=A_ScreenHeight-130
Gui, 2:Show, Hide x150 y%posy%

Menu, FileMenu, Add, �����ļ�(&F), MenuFileAdd
Menu, FileMenu, Add, �����ļ���(&D), MenuFolderAdd
Menu, FileMenu, Add, �˳�(&X), Exit
Menu, EditMenu, Add, ������ѡ(��ѡ)(&O), MenuOpen
Menu, EditMenu, Add, ɾ����ѡ(&R), MenuRemove
Menu, EditMenu, Add, ����б�(&C), MenuClear
Menu, EditMenu, Add, ���ļ�λ��(��ѡ)(&C), MenuOpenFilePath

Menu, PlayBack, Add, ��ͣ/����(&P), MyPause
Menu, PlayBack, Add, ֹͣ(&S), Stop
Menu, PlayBack, Add, �������(&R), GoRandom
Menu, PlayBack, Add, ��ת��(&J), Jump
Menu, PlayBack, Add, ��һ��(&V), Prev
Menu, PlayBack, Add, ��һ��(&N), Next
Menu, PlayBack, Add
Menu, PlayBack, Add, ����ѭ��(&D), PSingleCycle
Menu, PlayBack, Add, �����б�(&L), PTList
Menu, PlayBack, Add, --�����겥��(&F), PTLF
Menu, PlayBack, Add, ����ý���(&M), PTLib

Menu, Lib, Add, �򿪸�ʿ�(&L), OpenLrc
Menu, Lib, Add, ��ý���(&M), OpenLib
Menu, Lib, Add, �������ļ���(&F), OpenOptionFolder
Menu, Lib, Add
Menu, Lib, Add, �༭���(&E), EditLrc
Menu, Lib, Add, �༭�����ļ�(&O), EditOption
Menu, Lib, Add
Menu, Lib, Add, �����ָ��ϴβ���(&H),HuiFuShangCiPlay
Menu, Lib, Add, ����ý���(&U),UpdateMediaLib
Menu, Lib, Add, �����Զ�����ý���(&A),AutoUpdateMediaLib

Menu, Help, Add, ����(&A), About
Menu,PlayBack,Disable,--�����겥��(&F)
If (PlayRandom="t")
Menu,PlayBack,Check,�������(&R)

If (PlayListdefalut="t")
{
Menu,PlayBack,Enable,--�����겥��(&F)
Menu,PlayBack,Check,�����б�(&L)
If (followmouse="t")
Menu,PlayBack,Check,--�����겥��(&F)
Menu,PlayBack,Disable,�����б�(&L)
}
Else
{
Menu, PlayBack, Check,����ý���(&M)
Menu,PlayBack,Disable,����ý���(&M)
}

if (AutoUpdateMediaLib="t")
Menu, Lib, Check,�����Զ�����ý���(&A)
if (huifushangci = "t")
Menu, Lib, Check,�����ָ��ϴβ���(&H)


Menu, MyMenuBar, Add, �ļ�(&F), :FileMenu
Menu, MyMenuBar, Add, �༭(&E), :EditMenu
Menu, MyMenuBar, Add, ����(&P), :PlayBack
Menu, MyMenuBar, Add, ѡ��(&O), :Lib
Menu, MyMenuBar, Add, ����(&H), :Help

OnExit ExitSub

Gosub,GuiShow
SetTimer,CheckStatus,250
SetTimer,Updatevolume,1000

if (AutoUpdateMediaLib="t")
Gosub, UpdateMediaLib
Else{
sleep,1000
IfNotExist,%AhkMediaLibFile%
Gosub, UpdateMediaLib
}

if (huifushangci = "t")
Gosub,HuifuPlay
else
Gosub, StarPlay
Return

HuiFuShangCiPlay:
IniRead, huifushangci, %run_iniFile%, AhkPlayer,huifushangci
If (huifushangci ="t")
{
Menu,Lib,unCheck,�����ָ��ϴβ���(&H)
IniWrite,f, %run_iniFile%, AhkPlayer, huifushangci
}
Else
{
Menu,Lib,Check,�����ָ��ϴβ���(&H)
IniWrite,t, %run_iniFile%, AhkPlayer, huifushangci
}
Return


AutoUpdateMediaLib:
IniRead, AutoUpdateMediaLib, %run_iniFile%, AhkPlayer,AutoUpdateMediaLib
If (AutoUpdateMediaLib ="t")
{
Menu,Lib,unCheck,�����Զ�����ý���(&A)
IniWrite,f, %run_iniFile%, AhkPlayer, AutoUpdateMediaLib
}
Else
{
Menu,Lib,Check,�����Զ�����ý���(&A)
IniWrite,t, %run_iniFile%, AhkPlayer, AutoUpdateMediaLib
}
Return


UpdateMediaLib:
			Count = 0
			FileDelete, %AhkMediaLibFile%
			Fileappend, , %AhkMediaLibFile%
	Loop, %AhkMediaLib%\*.*, 0,1
		{
			mp3 := A_loopfilename

			 Splitpath, mp3,,,Extension
			 if (Extension != "mp3" && Extension != "wma")
						 Continue
			 			 else
			{
							FileAppend, %a_loopfilefullpath%`n, %AhkMediaLibFile%
							Count++
			}
		}

	Count -= 1
	IniWrite, %Count%, %run_iniFile%, AhkPlayer, Count
			Tooltip, ����ý������!%a_tab%%a_tab%
	Sleep 1000
	Tooltip
Return

HuifuPlay:
IniRead, Mp3Playing, %run_iniFile%, AhkPlayer, Mp3Playing
mp3 := Mp3Playing
;���ļ�
	hSound := MCI_Open(Mp3, "myfile")

    SetTimer UpdateSlider,off
    GUIControl,,Slider,0
    GUIControl,Disable,Slider
;�����ļ�
	Gosub, MyPause
	len := MCI_Length(hSound)
	GUIControl,Enable,Slider
    SetTimer,UpdateSlider,100
	SetTimer,CheckStatus,250
	Gosub, ToolTipMP3
    ;Gosub���������ת��ToolTipMP3��ǩ��ִ�б�ǩ�µ���䣬����Return���أ��ż���ִ�и����������伴����ִ��Gosub, StarPlay   Goto�����򲻻᷵��
	Gosub, StarPlay
Return

StarPlay:
	Count :=TF_CountLines(NowPlayFile)
	If hSound {
			MCI_Stop(hSound)
			MCI_Close(hSound)
	      }
		IniRead, PlayRandom, %run_iniFile%, AhkPlayer, PlayRandom
        IniRead, followmouse, %run_iniFile%, AhkPlayer, followmouse
        IniRead, PlayListdefalut, %run_iniFile%, AhkPlayer, PlayListdefalut

		if (PlayRandom = "t")
	{
		if (PlayListdefalut="t")
 		{
		if (followmouse="t")
		{
		if (PlaylistIndex != LV_GetNext(Row))
		{
		PlaylistIndex:=LV_GetNext(Row)
		LV_GetText(Mp3,PlaylistIndex,4)
	}
	else
		{
	    Random, Rand, 1, %Count%
	    FileReadLine, Mp3, %NowPlayFile%, %Rand%
				LV_Modify(0,"-Select")
		LV_Modify(Rand,"+Select +Focus +Vis")
		PlaylistIndex:=LV_GetNext(Row)
	    }
	    }
	    }
	    else
		{
	    Random, Rand, 1, %Count%
	    FileReadLine, Mp3, %NowPlayFile%, %Rand%
	    }
	}
		else
	{
		if (PlayListdefalut="t")
 		{
		if (PlaylistIndex>=LV_GetCount())
        PlaylistIndex:=0
		if (followmouse="t")
		{
		if (PlaylistIndex=LV_GetNext(Row))
        PlayListIndex++
		Else
		PlaylistIndex:=LV_GetNext(Row)
	    }
	    Else
		PlayListIndex++

		LV_GetText(Mp3,PlaylistIndex,4)
		LV_Modify(0,"-Select")
        LV_Modify(PlaylistIndex,"+Select +Focus +Vis")
		}
        else
	    {
			IniRead, PlayIndex, %run_iniFile%, AhkPlayer, PlayIndex
			PlayIndex++
			IniWrite, %PlayIndex%, %run_iniFile%, AhkPlayer, PlayIndex
			;IniRead, PlayListSize, %A_ScriptDir%\tmp\setting.ini, AhkPlayer, PlayListSize
        if (PlayIndex>Count) {
		PlayIndex = 1
		Iniwrite, %PlayIndex%, %run_iniFile%,AhkPlayer, PlayIndex
	    }
		FileReadLine, Mp3, %NowPlayFile%, %PlayIndex%
		}
	}

	hSound := MCI_Open(Mp3, "myfile")

	IniWrite, %mp3%, %run_iniFile%, AhkPlayer, Mp3Playing
	lastptime = 1
    SetTimer UpdateSlider,off
    GUIControl,,Slider,0
    GUIControl,Disable,Slider
	Gosub, MyPause
	len := MCI_Length(hSound)
	GUIControl,Enable,Slider
    SetTimer,UpdateSlider,100
	SetTimer,CheckStatus,250
	Gosub, ToolTipMP3
    ;Gosub���������ת��ToolTipMP3��ǩ��ִ�б�ǩ�µ���䣬����Return���أ��ż���ִ�и����������伴����ִ��Gosub, StarPlay   Goto�����򲻻᷵��

	;������һ�׸���
	Gosub, StarPlay
Return

GuiShow:
Gui, Menu, MyMenuBar

Menu, Context, Add, ����(��ѡ), PlayLV
Menu, Context, Add, ���ļ�λ��(��ѡ), OpenfilePath
Menu, Context, Add, ���ӵ��б�, AddList
Menu, Context, Add, ���б���ɾ��, Remove
Menu, Context, Add, ����б�, Remove
Menu, Context, Add, ����б��е��ظ�����Ч��, RemoveDuplicateInvalid

Gui, Add,Button,  y5 gPTList,�����б�
Gui, Add,Button, x+5 yp gPTLib,����ý���
Gui, Add,Edit, x+5 yp  w250 vfind
Gui, Add,Button, x+5 yp h20 gfind Default,����
Gui, Add,Button, x+5 yp h20 grefreshList,�����б�
Gui, Add,Button, x+5 yp h20 gFindToList,׷�ӵ��б�

Gui, Add,ListView ,xm Grid w600 h400 gListView vListView Altsubmit, ���|����|����|λ��
Gui, Add,Slider,xm w600 h25 +Disabled +ToolTip vSlider gSlider
Gui, Add,Picture,xm+150 y+10 vstop gStop,%A_ScriptDir%\pic\AhkPlayer\stop.bmp
Gui, Add,Picture,x+1 yp-1 gprev,%A_ScriptDir%\pic\AhkPlayer\prev.bmp
Gui, Add,Picture,x+1 yp-10 gMyPause vpausepic,%A_ScriptDir%\pic\AhkPlayer\play.bmp
Gui, Add,Picture,x+1 yp+10 gnext,%A_ScriptDir%\pic\AhkPlayer\next.bmp
Gui, Add,Picture, x+10 yp w32 h32 gmute vvol, %A_ScriptDir%\pic\vol.ico
Gui, Add,Slider, x+1 yp+10 w100 h20 vVSlider Range0-100 +ToolTip  gVolumeC
Gui, font,cred bold s24,Verdana
Gui, Add, text, x+5 yp-15  vLrcS  gLrcShow ,Lrc
Gui, font
Gui, Add, StatusBar, xm yp w600 h30 , δ�����ļ�
vol_Master := VA_GetVolume()
Guicontrol,,VSlider,%vol_Master%
SB_SetParts(300,100,220)
SB_SetProgress(0 ,3,+Smooth BackgroundYellow cBlue)
If (PlayListdefalut="t"){
Gui,Show,,�����б� - AhkPlayer
Loop, read, %AhkMediaListFile%
	{
	xuhao++
	SetFormat, float ,03
	mp3 = %A_LoopReadline%
	SplitPath, Mp3,,,ext, name
    LV_Add("", xuhao+0.0,name, ext,mp3)
    LV_ModifyCol()
}
}
else
Gui,Show,,����ý��� - AhkPlayer
Return

Stop:
SetTimer,CheckStatus,Off
playing=0
MCI_Stop(hSound)
Menu, PlayBack, Check,ֹͣ(&S)

SetTimer, clock,Off
gosub,CheckStatus
Return

ToolTipMP3:
	if (Exit = true)
		Exit
	;   ����ǰһ���ȼ�����ִ��ʱ�ְ�����һ���ȼ�����ô��ǰ�߳̽����ж�(��ʱ��ֹͣ)�������µ��̱߳�ɵ�ǰ���߳�
	;	  StarPlay�е�ToolTipMP3Ϊ��ǰ���̣�����!F9�󣬵�ǰ������ֹ��������״̬,!F1��ToolTipMP3��Ϊ��ǰ���߳�
	;   ��!F9��ToolTipMP3�߳��������֮��StarPlay�е�ToolTipMP3�ָ�
	;   ���԰���!F9���ź��ȼ����߳��ڳ�������ʱ���ٴΰ����ȼ�û�ã���Ϊ��һ�ε��ȼ���û�н���
	Exit = false
	Gosub, sNameTrim
	len := MCI_Length(hSound)

	Loop {
	IniRead, ToolMode, %run_iniFile%, AhkPlayer, ToolMode
	IniRead, ToolX, %run_iniFile%, AhkPlayer, ToolX
	IniRead, ToolY, %run_iniFile%, AhkPlayer, ToolY
			Sleep 100
			pos := MCI_Position(hSound)
			If(pos >= len){
			IniWrite, %mp3%, %run_iniFile%, AhkPlayer, LastPlay
			Break
	}

	MCI_ToHHMMSS2(pos, hh, mm, ss)
	MCI_ToHHMMSS2(len, lhh, lm, ls)
	If (ToolMode = 0)
			ToolTip
	Else If (ToolMode = 1){
		    if lhh=0
			ToolTip, %sName%`n%mm%:%ss% / Length %lm%:%ls%, %ToolX%, %ToolY%
			else
			ToolTip, %sName%`n%hh%:%mm%:%ss% / Length %lhh%:%lm%:%ls%, %ToolX%, %ToolY%
			}
	Else If (ToolMode = 2)
	{
		if lhh=0
		ToolTip, %sName%`n%mm%:%ss% / Length %lm%:%ls%`n%mp3%, %ToolX%, %ToolY%
        else
		ToolTip, %sName%`n%hh%:%mm%:%ss% / Length %lhh%:%lm%:%ls%`n%mp3%, %ToolX%, %ToolY%
}
}
Return


PlayfromList: 
FileReadLine, Mp3, %AhkMediaLibFile%, %PlayIndex%
	If hSound {
			  MCI_Close(hSound)
		      }
	hSound := MCI_Open(Mp3, "myfile")
    MCI_Play(hSound)
   if(hidelrc=0)
	 Gosub, Lrc
    Gosub, sNameTrim
	len := MCI_Length(hSound)
	MCI_ToHHMMSS2(pos, hh, mm, ss)
	MCI_ToHHMMSS2(len, hh, lm, ls)
Return 

ListReadWrite: ;() {

	IniRead, Count, %run_iniFile%, AhkPlayer, Count
	IniRead, PlayIndex, %run_iniFile%, AhkPlayer, PlayIndex

if (A_ThisHotkey="PgUp")
	PlayIndex-=1
if (A_ThisHotkey="PgDn")
	PlayIndex+=1

if (PlayIndex=0)
	PlayIndex := Count
if (PlayIndex > Count)
	PlayIndex = 1

	IniWrite, %PlayIndex%, %run_iniFile%, AhkPlayer, PlayIndex

Return ;}



sNameTrim:
StringLen, sLength, mp3
	StringGetPos, cTrim, mp3, \, R1
	cTrim += 2
	fName := (sLength+1) - cTrim
	StringMid, sName, mp3, %cTrim%, %fName%
	Return

Lrc:
lrcclear()
SetTimer, clock, Off
SplitPath, Mp3,,,ext, name
IfExist,%LrcPath%\%name%.lrc
{
Menu,Lib,Enable,�༭���(&E)
lrcECHO(LrcPath . "\" . name . ".lrc",name)
}
Else{
Gui, 2:Show, NoActivate, %name% - AhkPlayer
Gui, 2:Hide
Menu,Lib,Disable,�༭���(&E)
}
Return

;��һ��
^+F3::
prev:
if (PlayListdefalut="t")
{
if (PlaylistIndex>1)
{
PlaylistIndex:=PlaylistIndex-1
		LV_GetText(Mp3,PlaylistIndex,4)
		LV_Modify(0,"-Select")
        LV_Modify(PlaylistIndex,"+Select +Focus +Vis")
If hSound {
	MCI_Close(hSound)
}
	SetTimer UpdateSlider,off
    GUIControl,,Slider,0
    GUIControl Disable,Slider
hSound := MCI_Open(Mp3, "myfile")
Gosub, MyPause
GUIControl Enable,Slider
SetTimer UpdateSlider,100
SetTimer,CheckStatus,250
    Gosub, sNameTrim
	len := MCI_Length(hSound)
	MCI_ToHHMMSS2(pos, hh, mm, ss)
	MCI_ToHHMMSS2(len, hh, lm, ls)
}
}
Else
{
	if(lastptime =1)
	{
IniRead, mp3, %run_iniFile%, AhkPlayer, LastPlay
If hSound {
	MCI_Close(hSound)
}
	SetTimer UpdateSlider,off
    GUIControl,,Slider,0
    GUIControl Disable,Slider
hSound := MCI_Open(Mp3, "myfile")
Gosub, MyPause
GUIControl Enable,Slider
SetTimer UpdateSlider,100
SetTimer,CheckStatus,250
    Gosub, sNameTrim
	len := MCI_Length(hSound)
	MCI_ToHHMMSS2(pos, hh, mm, ss)
	MCI_ToHHMMSS2(len, hh, lm, ls)
	lastptime = 0
}
else
MCI_Seek(hSound, MCI_Length(hSound))
}
Return

;��ͣ
^+P::
MyPause:
	Status := MCI_Status(hSound)
	If(Status = "stopped" OR Status = "Paused"){
		If Status = stopped
		       {
				MCI_Play(hSound)
				Menu, PlayBack, UnCheck,ֹͣ(&S)
				Menu, PlayBack, UnCheck,��ͣ/����(&P)
        if(hidelrc=0)
				Gosub, Lrc
				SetTimer,CheckStatus,100
				}
			Else{
				MCI_Resume(hSound)
        if(hidelrc=0)
         {
				lrcPause(0)
        Gui,2:show 
         }
				Menu, PlayBack, ToggleCheck,��ͣ/����(&P)
			}
		GuiControl,,pausepic,	%A_ScriptDir%\pic\AhkPlayer\play.bmp
		playing = 1
    }
    Else{
		Pausetime:=A_TickCount
		MCI_Pause(hSound)
		if(hidelrc=0)
    {
     lrcPause(1)
     hidelrc=2
		 gosub lrcshow
    }
		Menu, PlayBack, ToggleCheck,��ͣ/����(&P)
		playing = 0
		GuiControl,,pausepic,%A_ScriptDir%\pic\AhkPlayer\pause.bmp
	}
Return

;��һ��
^+F5::
Next:
	MCI_Seek(hSound, MCI_Length(hSound))
if (hidelrc=0)
Gosub, Lrc
Return

^+E::
Exit:
ExitSub:
	If hSound {
		MCI_Stop(hSound)
		MCI_Close(hSound)
	}
    If(SingleCycle=true)
    FileDelete, %SingleCycleFile%
	ExitApp
Return

;���Ű����ؼ��ֵĸ���
!F9::
PlayMusic:
;Exit = true

	InputBox,userInput,����,����Ҫ���ҵĸ���
	IfEqual,userInput,, Return

	Loop, read, %AhkMediaLibFile%
		{
			mp3 = %A_LoopReadline%
			Found = Yes
			Loop, Parse, UserInput, %a_Space%
			IfNotInString, mp3, %A_LoopField%, SetEnv, Found, No

			IfEqual, Found, Yes
				{
			    If hSound {
				MCI_Stop(hSound)
			    MCI_Close(hSound)
						  }
	SetTimer UpdateSlider,off
    GUIControl,,Slider,0
    GUIControl, Disable,Slider
				hSound := MCI_Open(mp3, "myfile")
				IniWrite, %mp3%, %run_iniFile%, AhkPlayer, Mp3Playing
				Found = No
				Break
				}
		}

    Gosub, MyPause
	;Goto, ToolTipMP3
	GUIControl Enable,Slider
	SetTimer UpdateSlider,100
	    Gosub, sNameTrim
	len := MCI_Length(hSound)
	MCI_ToHHMMSS2(pos, hh, mm, ss)
	MCI_ToHHMMSS2(len, hh, lm, ls)
Return


!F3::
Jump:
	InputBox, Seek,��ת,����Ҫ��ת����ʱ�䣬��ʲ�֧����ת`n���ӣ�Ҫ��ת��2:20����220
	IfEqual,Seek,, Return
	StringLen, Length, Seek
	If Length = 4
		{
			StringLeft, MinS, Seek, 2
			StringRight, SecS, Seek, 2
		}
	Else If Length = 3
		{
			StringLeft, MinS, Seek, 1
			StringRight, SecS, Seek, 2
		}
	Else If Length = 2
			StringRight, SecS, Seek, 2
	Else If Length = 1
			StringRight, SecS, Seek, 1

	lrcpos := SecS * 1000
    lrcpos += (MinS * 60) * 1000
	MCI_Seek(hSound, lrcpos)

	IfWinExist, %name% - AhkPlayer
	{
	SetTimer, clock, off
    gosub,LRC
   }

Return


!F5::
IfExist,%LrcPath%\%name%.lrc
{
run,notepad.exe %LrcPath%\%name%.lrc
run,notepad.exe D:\Program Files\foobar2000\lyrics\%name%.lrc
}
Else{
ToolTip,����ļ�������!
Sleep,3000
ToolTip
}
Return

!F6::
if caption{
Gui, 2:-Caption
WinSet, ExStyle, +0x20
caption=0
}
Else{
caption=1
Gui, 2:+Caption	;�����ԣ���ȷ��Ҫ����д���ܹ��ڵ�һ��ʹ�õ�ʱ����Ч
Gui, 2:-Caption
Gui, 2:+LastFound
WinSet, ExStyle, -0x20
Gui, 2:+Caption
}
Return

!F8::
LrcShow:
if (hidelrc=1)
{
Gui, Font,cred bold s24,Verdana
GuiControl,font,LrcS
hidelrc=0
;IniWrite, 1, %A_ScriptDir%\tmp\setting.ini, AhkPlayer, ToolMode
Gui,2:show
}
Else if (hidelrc=0)
{
Gui, Font, cgreen bold s24,Verdana
GuiControl,font,LrcS
hidelrc=1
Gui,2:Hide
}
Else if (hidelrc=2)
{
hidelrc=0
Gui,2:Hide
}
Return

!F7::
If hide=1
{
SetTimer,Updatevolume,1000
Sleep,150
gui,Show
hide=0
}
Else
{
IfWinNotActive,�����б� - AhkPlayer
WinActivate,�����б� - AhkPlayer
else
{
gui,hide
SetTimer,Updatevolume,off
hide=1
}
IfWinNotActive,����ý��� - AhkPlayer
WinActivate,����ý��� - AhkPlayer
else
{
gui,hide
SetTimer,Updatevolume,off
hide=1
}
}
Return

;�����ڲ��ŵ��ļ����뵽�����б�
!F10::
FileRead, NoDoubles, %AhkMediaListFile%
IfNotInString, NoDoubles, %mp3%
	Fileappend, %mp3%`n, %AhkMediaListFile%
else
MsgBox,,����ʧ��,���ļ����ڲ����б���!
Return

PgUp::
Gosub, ListReadWrite
Gosub, PlayfromList
Return

PgDn::
Pagedown:
Gosub, ListReadWrite
Gosub, PlayfromList
Return

mute:
Send {Volume_Mute}
Gosub,Updatevolume
GUIControl Focus,Stop
Return

VolumeC:
VA_SetVolume(VSlider)
Return

;�˵������ļ����б�
MenuFileAdd:
Gui,Submit, NoHide
FileSelectFile, File, M,, �����ļ�, ��Ƶ�ļ� (*.mp3; *.wma; *.wav; *.mid;)
if !File
	return
LV_Modify(0, "-Select")
StringSplit, File, File, `n
Loop, % File0-1
{
	xuhao++
	NextIndex := A_Index+1
	w:=File%NextIndex%
	mp3 =  %File1%\%w%
	SplitPath, mp3,,,ext, name
	If ext in mp3,wma,wmv,wav,mpg,mid			;������Ŀǰ��֪������soundplay���ŵĸ�ʽ
	{
	SetFormat, float ,03
	LV_Add("Focus Select",xuhao+0.0,name,ext, mp3)
	Fileappend,%mp3%`n, %AhkMediaListFile%
	}
}
LV_ModifyCol()
LV_Modify(xuhao,"+Vis")
Return

;�˵������ļ��е��б�
MenuFolderAdd:
Gui,Submit, NoHide
FileSelectFolder,  Folder,,, ѡ����Ƶ�ļ������ļ���
If !Folder
	return
LV_Modify(0, "-Select")
Loop, %Folder%\*.*,0,1
{
	xuhao++
	SplitPath, A_LoopFileFullPath,,, ext, name
	If ext in mp3,wma,wav,mid
	{
  SetFormat, float ,03
	LV_Add("Focus Select",xuhao+0.0, name,ext, A_LoopFileFullPath)
	Fileappend,%A_LoopFileFullPath%`n, %AhkMediaListFile%
	}
}
LV_ModifyCol()
LV_Modify(xuhao,"+Vis")
return

;��ק�ļ�������
GuiDropFiles:
Gui, Submit, NoHide
LV_Modify(0, "-Select")
SetFormat,float ,3.0
Loop, Parse, A_GuiEvent, `n
{
	xuhao++
	SplitPath, A_LoopField,,,ext, name
	If ext in mp3,wma,wmv,wav,mpg,mid			;������Ŀǰ��֪������soundplay���ŵĸ�ʽ
	{
	SetFormat, float ,03
	LV_Add("Focus Select",xuhao+0.0, name,ext, A_LoopField)
	Fileappend,%A_LoopField%`n, %AhkMediaListFile%
	}
}
    LV_ModifyCol()
LV_Modify(xuhao,"+Vis")
Return

;�˵�������ѡ(��ѡ)
MenuOpen:
LV_GetText(Mp3, LV_GetNext(Row), 4)
PlaylistIndex:=LV_GetNext(Row)
if FileExist(Mp3)
{
	IniWrite, %mp3%, %run_iniFile%, AhkPlayer, Mp3Playing
	SetTimer UpdateSlider,off
    GUIControl,,Slider,0
    GUIControl Disable,Slider
	If hSound {
	MCI_Close(hSound)
	}
    hSound := MCI_Open(Mp3, "myfile")
    Gosub, MyPause
    Gosub, sNameTrim

	len := MCI_Length(hSound)
	MCI_ToHHMMSS2(pos, hh, mm, ss)
	MCI_ToHHMMSS2(len, hh, lm, ls)

	GUIControl Enable,Slider
    SetTimer UpdateSlider,100
	SetTimer,CheckStatus,on
	}
Return

;�˵�����ѡ�ļ�λ��(��ѡ)
MenuOpenFilePath:
LV_GetText(Mp3, LV_GetNext(Row), 4)
If Fileexist(Mp3)
Run,% "explorer.exe /select," Mp3
 Return

;�˵�ɾ����ѡ(�ɶ�ѡ)
MenuRemove:
Loop, % LV_GetCount()			;%
	Row := LV_GetNext(Row), LV_Delete(Row)

FileDelete, %AhkMediaListFile%
	Loop, % LV_GetCount()
	{
	LV_GetText(Mp3, A_Index, 4)
	Fileappend,%Mp3%`n, %AhkMediaListFile%
    }
gosub,refreshList
Return

MenuClear:
MsgBox,4,����б�,ȷʵҪ���б�������ƶ��б��ļ�������Backups�ļ��У�ֻ����һ�����ݣ���
IfMsgBox Yes
{
LV_Delete()
FileGetSize, playlistfilesize, %AhkMediaListFile%
if (playlistfilesize <> 0)
FileDelete,%A_ScriptDir%\Backups\playlist.txt

	FileMove, %AhkMediaListFile%,%A_ScriptDir%\Backups,0
if ErrorLevel
MsgBox,,����б�ʧ��,�б��Ѿ�Ϊ�ջ��ļ����ɶ�д
	Fileappend, , %AhkMediaListFile%
}
Return

;����ѭ��
PSingleCycle:
SingleCycle := !SingleCycle
if(SingleCycle=true)
{
Menu,PlayBack,Check,����ѭ��(&D)
OldNowPlayFile = %NowPlayFile%
FileDelete, %SingleCycleFile%
FileAppend,%Mp3%,%SingleCycleFile%
NowPlayFile = %SingleCycleFile%
}
else
{
Menu,PlayBack,UnCheck,����ѭ��(&D)
NowPlayFile = %OldNowPlayFile%
OldNowPlayFile =
FileDelete, %SingleCycleFile%
}
Return

;�����б�
PTList:
NowPlayFile = %AhkMediaListFile%
FileGetSize, playlistfilesize, %AhkMediaListFile%
if (playlistfilesize = 0)
NowPlayFile := AhkMediaLibFile
Else
{
IniWrite,t, %run_iniFile%, AhkPlayer, PlayListdefalut
Menu, PlayBack,Check,�����б�(&L)
Menu, PlayBack,UnCheck,����ý���(&M)
Menu, PlayBack,Disable,�����б�(&L)
Menu, PlayBack, Enable,����ý���(&M)

IniRead, PlayListdefalut, %run_iniFile%, AhkPlayer, PlayListdefalut
If (PlayListdefalut="t")
{
Menu,PlayBack,Enable,--�����겥��(&F)
IniRead, followmouse, %run_iniFile%, AhkPlayer, followmouse
If (followmouse="t")
Menu,PlayBack,Check,--�����겥��(&F)
}
}
gosub,refreshList
Gui,Show,,�����б� - AhkPlayer
Return

;����ý���
PTLib:
NowPlayFile := AhkMediaLibFile
Menu, PlayBack, Check,����ý���(&M)
Menu, PlayBack, Disable,����ý���(&M)
Menu, PlayBack, Enable,�����б�(&L)
Menu, PlayBack, UnCheck,�����б�(&L)
Menu, PlayBack, UnCheck,--�����겥��(&F)
Menu, PlayBack, Disable,--�����겥��(&F)
IniWrite,f, %run_iniFile%, AhkPlayer, PlayListdefalut
LV_Delete()
Gui,Show,,����ý��� - AhkPlayer
Return


PTLF:
IniRead, followmouse, %run_iniFile%, AhkPlayer, followmouse
If (followmouse="t")
{
Menu,PlayBack,unCheck,--�����겥��(&F)
IniWrite,f, %run_iniFile%, AhkPlayer, followmouse
}
Else
{
Menu,PlayBack,Check,--�����겥��(&F)
IniWrite,t, %run_iniFile%, AhkPlayer, followmouse
}
Return

GoRandom:
IniRead, PlayRandom, %run_iniFile%, AhkPlayer, PlayRandom
If (PlayRandom="t")
{
Menu,PlayBack,unCheck,�������(&R)
IniWrite,f, %run_iniFile%, AhkPlayer, PlayRandom
}
Else
{
Menu,PlayBack,Check,�������(&R)
IniWrite,t, %run_iniFile%, AhkPlayer, PlayRandom
}
Return

OpenLrc:
Run,%LrcPath%
Return

OpenLib:
Run,%AhkMediaLib%
Return

OpenOptionFolder:
Run,%A_ScriptDir%\settings\
Return

EditLrc:
Run,%LrcPath%\%name%.lrc
Return

EditOption:
Run,%run_iniFile%
Return

About:
Gui,3:Default
Gui,Add,Text,x y,���ƣ�AhkPlayer`n���ߣ�����С��
Gui,Add,Text,x y+10,��ҳ��
Gui,Add,Text,x y+10  cBlue gLink_1,http://code.google.com/p/ahk-run/
Gui,Add,Text,x y+10,��л��
Gui,Add,Text,x y+10  cBlue gLink_2,Sound.ahk - fincs
Gui,Add,Text,x y+10  cBlue gLink_3,MCI Library - jballi
Gui,Add,Text,x y+10  cBlue gLink_4,QuickSound - Stefan V
Gui,Add,Text,x y+10  cBlue gLink_5,NighPlayer - NiGH(dracula004)
Gui,show,,����
Return

Link_1:
Run,http://code.google.com/p/ahk-run/
Return

Link_2:
Run,http://www.autohotkey.com/forum/topic20666.html
Return

Link_3:
Run,http://www.autohotkey.com/forum/topic35266.html
Return

Link_4:
Run,http://www.autohotkey.com/forum/topic53076.html
Return

Link_5:
Run,http://ahk.5d6d.com/thread-2883-1-1.html
Return

;���Ҹ���
find:
Libxuhao=0
LV_Delete()
Gui, Submit, NoHide
Loop, read, %AhkMediaLibFile%
		{
			Libxuhao++
			SetFormat, float ,04
			mp3 = %A_LoopReadline%
			Found = Yes
			Loop, Parse, find, %a_Space%
			IfNotInString, mp3, %A_LoopField%, SetEnv, Found, No

			IfEqual, Found, Yes
				{
			    SplitPath, mp3,,,ext, name
				LV_Add("Focus",Libxuhao+0.0, name,ext, mp3)
				}
}
LV_ModifyCol()
Return

;ˢ���б�
refreshList:
LV_Delete()
xuhao = 0
SetFormat,float ,3.0
Loop, read, %AhkMediaListFile%
	{
	xuhao++
	mp3 = %A_LoopReadline%
	SplitPath, Mp3,,,ext, name
	SetFormat, float ,03
    LV_Add("",xuhao+0.0, name, ext,mp3)
    LV_ModifyCol()
}
Return

;���ҽ��׷�ӵ��б�
FindToList:
;Findsave:
;FileDelete, %AhkMediaListFile%
;	Fileappend, , %AhkMediaListFile%
;	Loop, % LV_GetCount()
;	{
;	LV_GetText(Mp3, A_Index, 4)
;	Fileappend,%Mp3%`n, %AhkMediaListFile%
;}

FileRead, NoDoubles, %AhkMediaListFile%

	Loop, % LV_GetCount()
	{
	LV_GetText(Mp3, A_Index, 4)
    IfNotInString, NoDoubles, %mp3%
	Fileappend, %mp3%`n, %AhkMediaListFile%
	}
Return

;�Ҽ�����б�����б���ɾ��
Remove:
If (A_ThisMenuItem = "����б�")
   {
MsgBox,4,����б�,ȷʵҪ���б�������ƶ��б��ļ�������Backups�ļ��У�ֻ����һ�����ݣ���
IfMsgBox Yes
{
	LV_Delete()
FileGetSize, playlistfilesize, %AhkMediaListFile%
if (playlistfilesize <> 0)
FileDelete,%A_ScriptDir%\Backups\playlist.txt
	FileMove, %AhkMediaListFile%,%A_ScriptDir%\Backups,0
if ErrorLevel
MsgBox,,����б�ʧ��,�б��Ѿ�Ϊ�ջ��ļ����ɶ�д
	Fileappend, , %AhkMediaListFile%
	}
}
else If (A_ThisMenuItem = "���б���ɾ��")
{
	Loop, % LV_GetCount()			;%
	Row := LV_GetNext(Row), LV_Delete(Row)

	FileDelete, %AhkMediaListFile%
	Loop, % LV_GetCount()
	{
	LV_GetText(Mp3, A_Index, 4)
	Fileappend,%Mp3%`n, %AhkMediaListFile%
	}
gosub,refreshlist
}
Return

;�Ҽ��Ƴ��ظ�����Ч��
RemoveDuplicateInvalid:
TF_RemoveDuplicateLines(AhkMediaListFile, "", "", 0,false)
sleep,200
FileMove,%A_ScriptDir%\settings\playlist_copy.txt,%AhkMediaListFile%,1
sleep,200
newText=
Loop, Read,%AhkMediaListFile%
{
IfExist,%A_LoopReadLine%
newText .= A_LoopReadLine "`n"
}
FileDelete,%AhkMediaListFile%
sleep,200
fileappend,%newText%,%AhkMediaListFile%
sleep,200
gosub,refreshList
Return

;�Ҽ���ѡ�������ӵ������б�
AddList:
RowNumber = 0
FileRead, NoDoubles, %AhkMediaListFile%
Loop, % LV_GetCount()
{
RowNumber := LV_GetNext(RowNumber)
 if not RowNumber
 break
LV_GetText(Mp3,RowNumber, 4)
IfNotInString, NoDoubles, %mp3%
	Fileappend, %mp3%`n, %AhkMediaListFile%
else
Repeat .= mp3 . "`n"
}
if Repeat
MsgBox,,����ʧ��, �����ļ������б���!`n%Repeat%

Repeat =
Return

ListView:
if (A_GuiEvent = "RightClick")
	Menu, Context , Show
else if (A_GuiEvent = "DoubleClick")
gosub,PlayLV
return

;�Ҽ�������ѡ����
PlayLV:
LV_GetText(Mp3, A_EventInfo, 4)
PlaylistIndex:= A_EventInfo
If hSound {
	MCI_Close(hSound)
}
	SetTimer UpdateSlider,off
    GUIControl,,Slider,0
    GUIControl Disable,Slider
hSound := MCI_Open(Mp3, "myfile")
Gosub, MyPause
GUIControl Enable,Slider
SetTimer UpdateSlider,100
SetTimer,CheckStatus,on
    Gosub, sNameTrim
	len := MCI_Length(hSound)
	MCI_ToHHMMSS2(pos, hh, mm, ss)
	MCI_ToHHMMSS2(len, hh, lm, ls)
return

OpenfilePath:
LV_GetText(Mp3,LV_GetNext(), 4)
If Fileexist(Mp3)
Run,% "explorer.exe /select," Mp3
 Return

Slider:
if hSound
    {
    Status:=MCI_Status(hSound)
    if Status in Playing,Paused
        {
        MCI_Play(hSound,"from " . floor(Len*(Slider/100)),"NotifyEndOfPlay")

	IfWinExist, %name% - AhkPlayer
	{
	SetTimer, clock, off
	lrcpos := %	floor(Len*(Slider/100))
    gosub,LRC
   }

            ;-- MCI_Seek is not used to reposition the media in this example
            ;   because the function will cause a Notify interruption for most
            ;   devices.
            ;
            ;   Using the "From" flag, MCI_Play will successfully reposition
            ;   the media for most MCI devices.  Calling MCI_Play (with
            ;   callback) while media is playing will abort the original Notify
            ;   condition (if any) and will create a new Notify condition.

        if Status=Paused
            MCI_Pause(hSound)
        }

    ;-- Reset focus
    GUIControl Focus,Stop
    }

Return

UpdateSlider:
if hSound
    {
    ;-- Only update slider if object is NOT in focus
    GUIControlGet Control,FocusV
    if Control<>Slider
        GUIControl,,Slider,% (MCI_Position(hSound)/Len)*100
    }
return

CheckStatus:
Status := MCI_Status(hSound)
If Status = stopped
    {
    SB_SetText("ֹͣ���� " SName,1)
	SongTime = 0:0:0 / %lhh%:%lm%:%ls%
	SB_SetText(SongTime,2)
	SB_SetProgress(0 ,3)
    }
If Status = Paused
    {
    SB_SetText("��ͣ " SName,1)
    }
If playing = 1
{
 SB_SetText("���ڲ��� " SName ,1)
 SongTime = %hh%:%mm%:%ss% / %lhh%:%lm%:%ls%
 SB_SetText(SongTime,2)
 opos := (pos/Len)*100
 SB_SetProgress(opos ,3)
 }
Return

Updatevolume:
volume := VA_GetVolume()
Guicontrol,,VSlider,%volume%

master_mute:=VA_GetMute()
if master_mute
volimage = %A_ScriptDir%\pic\m_vol.ico
else
volimage = %A_ScriptDir%\pic\vol.ico

   If (volimage != Oldvolimage)
   {
      GuiControl, , vol, %volimage%
      Oldvolimage := volimage
   }
Return


GuiEscape:
GuiClose:
SetTimer,Updatevolume,off
gui,Hide
hide=1
Return

3GuiEscape:
3GuiClose:
SetTimer,Updatevolume,off
gui,3:Destroy
Return

#include %A_ScriptDir%\Lib\VA.ahk
#include %A_ScriptDir%\Lib\MCI.ahk
#include %A_ScriptDir%\Lib\LRC.ahk
#include %A_ScriptDir%\Lib\SB.ahk
"Resource/UI/HUD/HudScriptedMode.res"
{

//========================================================================================================================
//VISIBLE HUD / (c) noa1mbot
//========================================================================================================================

	"Elem00Data" //HUD_LEFT_TOP -> (00:00)
	{
		"fieldName"	"Elem00Data"
		"xpos"		"217"
		"ypos"		"3"
		"wide"		"110"
		"tall"		"21"
		"textAlignment"	"west"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem00Im" //Frame
	{
		"fieldName"	"Elem00Im"
		"xpos"		"285"
		"ypos"		"4"
		"wide"		"70"
		"tall"		"17"
		"textAlignment"	"west"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem00Fl" //BG
	{
		"fieldName"	"Elem00Fl"
		"xpos"		"285"
		"ypos"		"4"
		"wide"		"70"
		"tall"		"17"
		"textAlignment"	"west"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem01Data" //HUD_LEFT_BOT -> (000)
	{
		"fieldName"	"Elem01Data"
		"xpos"		"331"
		"ypos"		"4"
		"wide"		"110"
		"tall"		"21"
		"textAlignment"	"west"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem01Im"
	{
		"fieldName"	"Elem01Im"
		"xpos"		"120"
		"ypos"		"40"
		"wide"		"120"
		"tall"		"25"
		"textAlignment"	"west"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem01Fl"
	{
		"fieldName"	"Elem01Fl"
		"xpos"		"120"
		"ypos"		"40"
		"wide"		"120"
		"tall"		"25"
		"textAlignment"	"west"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem02Data" //HUD_MID_TOP -> qmark
	{
		"fieldName"	"Elem02Data"
		"xpos"		"274"
		"ypos"		"10"
		"wide"		"110"
		"tall"		"21"
		"textAlignment"	"center"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem02Im"
	{
		"fieldName"	"Elem02Im"
		"xpos"		"260"
		"ypos"		"12"
		"wide"		"120"
		"tall"		"25"
		"textAlignment"	"center"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem02Fl"
	{
		"fieldName"	"Elem02Fl"
		"xpos"		"260"
		"ypos"		"12"
		"wide"		"120"
		"tall"		"25"
		"textAlignment"	"center"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}
	
//========================================================================================================================
//NOT VISIBLE HUD
//========================================================================================================================

	"Elem03Data" //HUD_MID_BOT -> (00:00)
	{
		"fieldName"	"Elem03Data"
		"xpos"		"217"
		"ypos"		"-100" //3
		"wide"		"110"
		"tall"		"21"
		"textAlignment"	"center"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem03Im" //Frame
	{
		"fieldName"	"Elem03Im"
		"xpos"		"285"
		"ypos"		"-100" //4
		"wide"		"70"
		"tall"		"17"
		"textAlignment"	"center"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem03Fl" //BG
	{
		"fieldName"	"Elem03Fl"
		"xpos"		"285"
		"ypos"		"-100" //4
		"wide"		"70"
		"tall"		"17"
		"textAlignment"	"center"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem04Data" //HUD_RIGHT_TOP -> (000)
	{
		"fieldName"	"Elem04Data"
		"xpos"		"331"
		"ypos"		"-100" //4
		"wide"		"110"
		"tall"		"21"
		"textAlignment"	"east"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem04Im"
	{
		"fieldName"	"Elem04Im"
		"xpos"		"400"
		"ypos"		"12"
		"wide"		"120"
		"tall"		"25"
		"textAlignment"	"east"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem04Fl"
	{
		"fieldName"	"Elem04Fl"
		"xpos"		"400"
		"ypos"		"12"
		"wide"		"120"
		"tall"		"25"
		"textAlignment"	"east"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem05Data" //HUD_RIGHT_BOT -> qmark
	{
		"fieldName"	"Elem05Data"
		"xpos"		"274"
		"ypos"		"-100" //10
		"wide"		"110"
		"tall"		"21"
		"textAlignment"	"east"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem05Im"
	{
		"fieldName"	"Elem05Im"
		"xpos"		"400"
		"ypos"		"40"
		"wide"		"120"
		"tall"		"25"
		"textAlignment"	"east"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem05Fl"
	{
		"fieldName"	"Elem05Fl"
		"xpos"		"400"
		"ypos"		"40"
		"wide"		"120"
		"tall"		"25"
		"textAlignment"	"east"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}
	
//========================================================================================================================
//DEFAULT
//========================================================================================================================

	"Elem06Data"
	{
		"fieldName"	"Elem06Data"
		"xpos"		"125"
		"ypos"		"72"
		"wide"		"390"
		"tall"		"16"
		"textAlignment"	"center"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem06Im"
	{
		"fieldName"	"Elem06Im"
		"xpos"		"120"
		"ypos"		"70"
		"wide"		"400"
		"tall"		"20"
		"textAlignment"	"center"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem06Fl"
	{
		"fieldName"	"Elem06Fl"
		"xpos"		"120"
		"ypos"		"70"
		"wide"		"400"
		"tall"		"20"
		"textAlignment"	"center"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem07Data"
	{
		"fieldName"	"Elem07Data"
		"xpos"		"35"
		"ypos"		"14"
		"wide"		"65"
		"tall"		"21"
		"textAlignment"	"west"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem07Im"
	{
		"fieldName"	"Elem07Im"
		"xpos"		"30"
		"ypos"		"12"
		"wide"		"75"
		"tall"		"25"
		"textAlignment"	"west"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem07Fl"
	{
		"fieldName"	"Elem07Fl"
		"xpos"		"30"
		"ypos"		"12"
		"wide"		"75"
		"tall"		"25"
		"textAlignment"	"west"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem08Data"
	{
		"fieldName"	"Elem08Data"
		"xpos"		"540"
		"ypos"		"14"
		"wide"		"65"
		"tall"		"21"
		"textAlignment"	"east"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem08Im"
	{
		"fieldName"	"Elem08Im"
		"xpos"		"535"
		"ypos"		"12"
		"wide"		"75"
		"tall"		"25"
		"textAlignment"	"east"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem08Fl"
	{
		"fieldName"	"Elem08Fl"
		"xpos"		"535"
		"ypos"		"12"
		"wide"		"75"
		"tall"		"25"
		"textAlignment"	"east"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem09Data"
	{
		"fieldName"	"Elem09Data"
		"xpos"		"265"
		"ypos"		"16"
		"wide"		"110"
		"tall"		"49"
		"textAlignment"	"north"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem09Im"
	{
		"fieldName"	"Elem09Im"
		"xpos"		"260"
		"ypos"		"12"
		"wide"		"120"
		"tall"		"53"
		"textAlignment"	"north"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem09Fl"
	{
		"fieldName"	"Elem09Fl"
		"xpos"		"260"
		"ypos"		"12"
		"wide"		"120"
		"tall"		"53"
		"textAlignment"	"north"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem10Data"
	{
		"fieldName"	"Elem10Data"
		"xpos"		"105"
		"ypos"		"142"
		"wide"		"430"
		"tall"		"36"
		"textAlignment"	"center"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem10Im"
	{
		"fieldName"	"Elem10Im"
		"xpos"		"100"
		"ypos"		"140"
		"wide"		"440"
		"tall"		"40"
		"textAlignment"	"center"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem10Fl"
	{
		"fieldName"	"Elem10Fl"
		"xpos"		"100"
		"ypos"		"140"
		"wide"		"440"
		"tall"		"40"
		"textAlignment"	"center"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem11Data"
	{
		"fieldName"	"Elem11Data"
		"xpos"		"105"
		"ypos"		"212"
		"wide"		"430"
		"tall"		"16"
		"textAlignment"	"center"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem11Im"
	{
		"fieldName"	"Elem11Im"
		"xpos"		"100"
		"ypos"		"210"
		"wide"		"440"
		"tall"		"20"
		"textAlignment"	"center"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem11Fl"
	{
		"fieldName"	"Elem11Fl"
		"xpos"		"100"
		"ypos"		"210"
		"wide"		"440"
		"tall"		"20"
		"textAlignment"	"center"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem12Data"
	{
		"fieldName"	"Elem12Data"
		"xpos"		"105"
		"ypos"		"242"
		"wide"		"430"
		"tall"		"16"
		"textAlignment"	"center"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem12Im"
	{
		"fieldName"	"Elem12Im"
		"xpos"		"100"
		"ypos"		"240"
		"wide"		"440"
		"tall"		"20"
		"textAlignment"	"center"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem12Fl"
	{
		"fieldName"	"Elem12Fl"
		"xpos"		"100"
		"ypos"		"240"
		"wide"		"440"
		"tall"		"20"
		"textAlignment"	"center"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem13Data"
	{
		"fieldName"	"Elem13Data"
		"xpos"		"105"
		"ypos"		"272"
		"wide"		"430"
		"tall"		"16"
		"textAlignment"	"center"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem13Im"
	{
		"fieldName"	"Elem13Im"
		"xpos"		"100"
		"ypos"		"270"
		"wide"		"440"
		"tall"		"20"
		"textAlignment"	"center"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem13Fl"
	{
		"fieldName"	"Elem13Fl"
		"xpos"		"100"
		"ypos"		"270"
		"wide"		"440"
		"tall"		"20"
		"textAlignment"	"center"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

	"Elem14Data"
	{
		"fieldName"	"Elem14Data"
		"xpos"		"105"
		"ypos"		"302"
		"wide"		"430"
		"tall"		"16"
		"textAlignment"	"center"
		"zpos"		"1"
		"ControlName"	"Label"
		"visible"	"0"
	}

	"Elem14Im"
	{
		"fieldName"	"Elem14Im"
		"xpos"		"100"
		"ypos"		"300"
		"wide"		"440"
		"tall"		"20"
		"textAlignment"	"center"
		"image"		"../vgui/hud/ScalablePanel_bgBlack50_outlineGrey"
		"scaleImage"	"1"
		"ControlName"	"ScalableImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"drawcolor"	"255 255 255 255"
	}

	"Elem14Fl"
	{
		"fieldName"	"Elem14Fl"
		"xpos"		"100"
		"ypos"		"300"
		"wide"		"440"
		"tall"		"20"
		"textAlignment"	"center"
		"zpos"		"-2"
		"scaleImage"	"1"
		"ControlName"	"ImagePanel"
		"visible"	"0"
		"enabled"	"1"
		"fillcolor"	"0 0 0 200"
	}

/////////////////// 
// these are here for someday having a "Bar to fill" type UI on the left

	"ElemVertBarBG"
	{
		"ControlName"		"Label"
		"fieldName"		"ElemVertBarBG"
		"xpos"			"35"
		"ypos"			"70"
		"zpos"			"1"
		"wide"			"35"
		"tall"			"300"
		"visible"		"0"
		"labelText"		"VertBarBG"
		"textAlignment"		"west"
	}

	"ElemVertBar"
	{
		"ControlName"		"Label"
		"fieldName"		"ElemVertBar"
		"xpos"			"35"
		"ypos"			"70"
		"zpos"			"1"
		"wide"			"35"
		"tall"			"300"
		"visible"		"0"
		"labelText"		"VertBar"
		"textAlignment"		"west"
	}
}
 
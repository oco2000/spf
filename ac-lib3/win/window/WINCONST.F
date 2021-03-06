28 CONSTANT /MSG  \ ������ ��������� ������� ���������

: #define
  BASE @ >R
  CREATE 0 0
  BL WORD COUNT
  S" 0x" SEARCH
  IF 2- SWAP 2+ SWAP HEX ELSE DECIMAL THEN
  >NUMBER 2DROP D>S ,
  R> BASE !
  DOES> @
;

\ CreateWindow
#define CW_USEDEFAULT       0x80000000

\ SetWindowPos
#define SWP_NOSIZE          0x0001
#define SWP_NOMOVE          0x0002
#define SWP_NOZORDER        0x0004

\ ShowWindow
#define SW_HIDE             0
#define SW_SHOW             5
#define SW_RESTORE          9

BASE @ DECIMAL
\ SetWindowLong
 -4 CONSTANT GWL_WNDPROC
-16 CONSTANT GWL_STYLE
-20 CONSTANT GWL_EXSTYLE
-21 CONSTANT GWL_USERDATA

\ SetClassLong
 -8 CONSTANT GCL_MENUNAME
-10 CONSTANT GCL_HBRBACKGROUND
-12 CONSTANT GCL_HCURSOR
-14 CONSTANT GCL_HICON
BASE !

\ Window styles
#define WS_OVERLAPPED       0x00000000L
#define WS_POPUP            0x80000000L
#define WS_CHILD            0x40000000L
#define WS_MINIMIZE         0x20000000L
#define WS_VISIBLE          0x10000000L
#define WS_DISABLED         0x08000000L
#define WS_CLIPSIBLINGS     0x04000000L
#define WS_CLIPCHILDREN     0x02000000L
#define WS_MAXIMIZE         0x01000000L
#define WS_CAPTION          0x00C00000L  \   /* WS_BORDER | WS_DLGFRAME  */
#define WS_BORDER           0x00800000L
#define WS_DLGFRAME         0x00400000L
#define WS_VSCROLL          0x00200000L
#define WS_HSCROLL          0x00100000L
#define WS_SYSMENU          0x00080000L
#define WS_THICKFRAME       0x00040000L
#define WS_GROUP            0x00020000L
#define WS_TABSTOP          0x00010000L

#define WS_MINIMIZEBOX      0x00020000L
#define WS_MAXIMIZEBOX      0x00010000L


\ #define WS_TILED            WS_OVERLAPPED
\ #define WS_ICONIC           WS_MINIMIZE
\ #define WS_SIZEBOX          WS_THICKFRAME
\ #define WS_TILEDWINDOW      WS_OVERLAPPEDWINDOW

\ Common Window Styles
WS_OVERLAPPED
WS_CAPTION OR
WS_SYSMENU OR
WS_THICKFRAME OR
WS_MINIMIZEBOX OR
WS_MAXIMIZEBOX OR
CONSTANT WS_OVERLAPPEDWINDOW

WS_POPUP
WS_BORDER OR
WS_SYSMENU OR
CONSTANT WS_POPUPWINDOW

\ #define WS_CHILDWINDOW      (WS_CHILD)

\ Extended Window Styles
#define WS_EX_DLGMODALFRAME     0x00000001L
#define WS_EX_NOPARENTNOTIFY    0x00000004L
#define WS_EX_TOPMOST           0x00000008L
#define WS_EX_ACCEPTFILES       0x00000010L
#define WS_EX_TRANSPARENT       0x00000020L
\ #if(WINVER >= 0x0400)
#define WS_EX_MDICHILD          0x00000040L
#define WS_EX_TOOLWINDOW        0x00000080L
#define WS_EX_WINDOWEDGE        0x00000100L
#define WS_EX_CLIENTEDGE        0x00000200L
#define WS_EX_CONTEXTHELP       0x00000400L

#define WS_EX_RIGHT             0x00001000L
#define WS_EX_LEFT              0x00000000L
#define WS_EX_RTLREADING        0x00002000L
#define WS_EX_LTRREADING        0x00000000L
#define WS_EX_LEFTSCROLLBAR     0x00004000L
#define WS_EX_RIGHTSCROLLBAR    0x00000000L

#define WS_EX_CONTROLPARENT     0x00010000L
#define WS_EX_STATICEDGE        0x00020000L
#define WS_EX_APPWINDOW         0x00040000L


WS_EX_WINDOWEDGE WS_EX_CLIENTEDGE OR CONSTANT WS_EX_OVERLAPPEDWINDOW
WS_EX_WINDOWEDGE WS_EX_TOOLWINDOW OR WS_EX_TOPMOST OR CONSTANT  WS_EX_PALETTEWINDOW


\ ��������� Windows
#define WM_CLOSE                        0x0010
#define WM_QUIT                         0x0012
#define WM_USER                         0x0400
#define WM_LBUTTONDOWN                  0x0201
#define WM_RBUTTONDOWN                  0x0204


\ Edit Control Styles
#define ES_LEFT             0x0000L
#define ES_CENTER           0x0001L
#define ES_RIGHT            0x0002L
#define ES_MULTILINE        0x0004L
#define ES_UPPERCASE        0x0008L
#define ES_LOWERCASE        0x0010L
#define ES_PASSWORD         0x0020L
#define ES_AUTOVSCROLL      0x0040L
#define ES_AUTOHSCROLL      0x0080L
#define ES_NOHIDESEL        0x0100L
#define ES_OEMCONVERT       0x0400L
#define ES_READONLY         0x0800L
#define ES_WANTRETURN       0x1000L
\ #if(WINVER >= 0x0400)
#define ES_NUMBER           0x2000L

\ ����� SP-Forth
  WS_OVERLAPPEDWINDOW WS_VSCROLL OR WS_HSCROLL OR
  ES_AUTOVSCROLL OR ES_AUTOHSCROLL OR
  ES_MULTILINE OR ES_WANTRETURN OR
CONSTANT SPF_STDEDIT

  WS_VSCROLL  WS_HSCROLL OR
  ES_AUTOVSCROLL OR ES_AUTOHSCROLL OR
  ES_MULTILINE OR ES_WANTRETURN OR
CONSTANT SPF_RICHEDIT

\ ��������� ��� RichEdit
WM_USER 53 + CONSTANT EM_EXLIMITTEXT

\ ��������� ListBox

#define LB_ADDSTRING            0x0180
#define LB_DELETESTRING         0x0182
#define LB_SETTOPINDEX          0x0197
#define LB_GETCURSEL            0x0188
-1 CONSTANT LB_ERR

\ ����� ListBox

#define LBS_MULTICOLUMN         0x0200L

\ ����� DialogBox

#define DS_MODALFRAME           0x0080
#define DS_SETFONT              0x0040
#define DS_CENTER               0x0800

1 CONSTANT IDOK
2 CONSTANT IDCANCEL

\ ��������� DialogBox

#define WM_INITDIALOG           0x0110
#define WM_COMMAND              0x0111
#define WM_NOTIFY               0x004E

\ ������ DialogBoxControls
BASE @ HEX
0080 CONSTANT DI_Button 
0081 CONSTANT DI_Edit 
0082 CONSTANT DI_Static 
0083 CONSTANT DI_Listbox 
0084 CONSTANT DI_Scrollbar 
0085 CONSTANT DI_Combobox
BASE !

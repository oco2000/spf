REQUIRE CGLObject ~ygrek/lib/wfl/opengl/GLObject.f
REQUIRE CBMP24 ~ygrek/lib/spec/bmp.f
REQUIRE [IFNDEF] ~nn\lib\ifdef.f

[IFNDEF] glDrawPixels
WINAPI: glDrawPixels OpenGL32.DLL
[THEN]



MODULE: CGLImage-module

0
1 -- r
1 -- g
1 -- b
CONSTANT /rgb

EXPORT

CGLObject SUBCLASS CGLImage
VAR addr
VAR width
VAR height
VAR red
VAR green
VAR blue

: :draw
SUPER :draw
1 GL_UNPACK_ALIGNMENT glPixelStorei DROP
addr @ GL_UNSIGNED_BYTE GL_RGB height @ width @ glDrawPixels DROP ;

: :set-size ( w h -- ) OVER height ! DUP width !
addr @ ?DUP IF FREE THROW THEN
* /rgb * ALLOCATE THROW addr ! ;

: :set-color ( r g b -- ) blue ! green ! red ! ;

: :load-image ( S" pic.bmp" -- addr )
|| CBMP24 img D: data ||
\ ������ CBMP24 �� ����� �� ���� �������, �� �������� � ������������ ������ �� ����� �������� ��������
img :load-file
img :size SWAP :set-size
addr @ data !
img sizeY @ 0 DO
img sizeX @ 0 DO
I J img :rgb ( r g b )
data @
TUCK r C!
TUCK g C!
TUCK b C!
/rgb + data !
LOOP LOOP ;

: :cls 0 0 :set-size ;

: :pixel ( x y -- )
width @ * + /rgb * addr @ +
red @ OVER r !
green @ OVER g !
blue @ OVER b !
DROP ;

init: :cls ;

;CLASS
;MODULE
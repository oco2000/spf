( ���������� �������� ������� ��������.
  ��-����������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

USER S0   \ ����� ��� ����� ������
USER R0   \ ����� ��� ����� ���������
USER WARNING
USER STATE ( -- a-addr ) \ 94
     \ a-addr - ����� ������, ���������� ������ "��������� ����������".
     \ STATE "������" � ������ ����������, ����� "����".
     \ �������� STATE ������ ��������� ����������� �����:
     \ : ; [ ] ABORT QUIT :NONAME
USER BLK
USER CURFILE

VECT OK
VECT <MAIN>
VECT ?LITERAL
VECT ?SLITERAL

: DEPTH ( -- +n ) \ 94
\ +n - ����� ��������� �����, ����������� �� ����� ������ �����
\ ��� ��� ���� ���� �������� +n.
  SP@ S0 @ - NEGATE 4 U/
;
: ?STACK ( -> ) \ ������ ������ "���������� �����", ���� �� ����� ��� ����
  SP@ S0 @ SWAP U< IF S0 @ SP! -4 THROW THEN
;

: ?COMP ( -> )
  STATE @ 0= IF -312 THROW THEN ( ������ ��� ������ ���������� )
;

: WORD ( char "<chars>ccc<char>" -- c-addr ) \ 94
\ ���������� ������� �����������. ������� �������, ������������
\ ������������ char.
\ �������������� �������� ���������, ���� ����� ����������� ������
\ ������ ������������ ����� ������ �� ���������.
\ c-addr - ����� ���������� �������, ���������� ����������� �����
\ � ���� ������ �� ���������.
\ ���� ����������� ������� ����� ��� �������� ������ �����������,
\ �������������� ������ ����� ������� �����.
\ � ����� ������ ���������� ������, �� ���������� � ����� ������.
\ ��������� ����� �������� ������� � ������.
  DUP SKIP PARSE 255 MIN
  DUP SYSTEM-PAD C! SYSTEM-PAD 1+ SWAP QCMOVE
  0 SYSTEM-PAD COUNT + C!
  SYSTEM-PAD
;

: ' ( "<spaces>name" -- xt ) \ 94
\ ���������� ������� �������. �������� name, ������������ ��������. ����� name 
\ � ������� xt, ���������� ����� ��� name. �������������� �������� ���������, 
\ ���� name �� �������.
\ �� ����� �������������  ' name EXECUTE  �����������  name.
  ALSO NON-OPT-WL CONTEXT !
  NextWord SFIND 0= PREVIOUS
  IF -321 THROW THEN (  -? )
;

: CHAR ( "<spaces>name" -- char ) \ 94
\ ���������� ������� �����������. �������� ���, ������������ ���������.
\ �������� ��� ��� ������� ������� �� ����.
  NextWord DROP C@
;

: BYE ( -- ) \ 94 TOOLS EXT
\ ������� ���������� ������������ �������, ���� ��� ����.
  0 
  HALT
;

: EVAL-WORD ( a u -- )
\ ���������������� ( �������������) ����� � ������  a u
    SFIND ?DUP    IF
    STATE @ =  IF 
    COMPILE,   ELSE 
    EXECUTE    THEN
                  ELSE
    -2003 THROW THEN
;

: NOTFOUND ( a u -- )
\ ��������� � ������ � �������� � ����  vocname1::wordname
\ ��� vocname1::vocname2::wordname � �.�.
\ ��� vocname1:: wordname
  2DUP 2>R ['] ?SLITERAL CATCH ?DUP IF NIP NIP 2R>
  2DUP S" ::" SEARCH 0= IF 2DROP 2DROP THROW  THEN \ ������ ���� :: ?
  2DROP ROT DROP
  GET-ORDER  N>R
                         BEGIN ( a u )
    2DUP S" ::" SEARCH   WHILE ( a1 u1 a3 u3 )
    2 -2 D+ ( ������� ����������� :: )  2>R
    R@ - 2 - SFIND              IF
    SP@ >R
    ALSO EXECUTE SP@ R> - 0=
    IF CONTEXT ! THEN
                                ELSE  ( a1 u' )
    R> DROP R> DROP
    NR>  SET-ORDER
    -2011 THROW                 THEN
    2R>                  REPEAT
  NIP 0= IF 2DROP NextWord THEN
  ['] EVAL-WORD CATCH
  NR> SET-ORDER THROW
 ELSE RDROP RDROP THEN
;

: INTERPRET ( -> ) \ ���������������� ������� �����
  BEGIN
    NextWord DUP
  WHILE
    SFIND ?DUP
    IF
         STATE @ =
         IF COMPILE, ELSE EXECUTE THEN
    ELSE
         S" NOTFOUND" SFIND 
         IF EXECUTE
         ELSE 2DROP ?SLITERAL THEN
    THEN
    ?STACK
  REPEAT 2DROP
;

: .SN ( n --)
\ ����������� n ������� ��������� �����
   >R BEGIN
         R@
      WHILE
        SP@ R@ 1- CELLS + @ DUP 0< 
        IF DUP U>D <# #S #> TYPE
           ." (" ABS 0 <# #S [CHAR] - HOLD #> TYPE ." ) " ELSE . THEN
        R> 1- >R
      REPEAT RDROP
;

: OK1
  STATE @ 0=
  IF
    DEPTH 6 < IF
                 DEPTH IF ."  Ok ( " DEPTH .SN  ." )" CR
                       ELSE ."  Ok" CR
                       THEN
               ELSE ."  Ok ( [" DEPTH 0 <# #S #> TYPE ." ].. "
                    5 .SN ." )" CR
               THEN
  THEN
;

: [   \ 94 CORE
\ �������������: ��������� ������������.
\ ����������: ��������� ��������� ����������, ������ ����.
\ ����������: ( -- )
\ ���������� ��������� �������������. [ ����� ������������ ����������.
  STATE 0!
; IMMEDIATE


: ] ( -- ) \ 94 CORE
\ ���������� ��������� ����������.
  TRUE STATE !
;

: MAIN1 ( -- )
  BEGIN
    REFILL
  WHILE
    INTERPRET OK
    SOURCE-ID 0=
    IF  LT LTL @ TO-LOG  THEN
        \ ���� ���� � user-device �������� cr � ���, �� ���� ������ Enter
  REPEAT BYE
;

: QUIT ( -- ) ( R: i*x ) \ CORE 94
\ �������� ���� ���������, �������� ���� � SOURCE-ID.
\ ���������� ����������� ������� ����� � ��������� �������������.
\ �� �������� ���������. ��������� ���������:
\ - ������� ������ �� �������� ������ �� ������� �����, �������� >IN
\   � ���������������.
\ - ������� ��������� �� ���������� ��������� �����������, ����
\   ������� ��������� � ��������� �������������, ��� �������� ���������,
\   � ��� ������������� ��������.

  BEGIN
    CONSOLE-HANDLES
    0 TO SOURCE-ID
    [COMPILE] [
    ['] MAIN1 CATCH
    H-STDERR TO H-STDOUT
    ['] ERROR CATCH DROP
 ( S0 @ SP! R0 @ RP! \ ����� �� ����������, �.�. ��� �� ��� ������ CATCH :)
  AGAIN
;

: EVALUATE-WITH ( ( i*x c-addr u xt -- j*x )
\ ������ c-addr u ������� �������, ��������� � ��������������� xt.
  SOURCE-ID >R TIB >R #TIB @ >R >IN @ >R
  -1 TO SOURCE-ID
  SWAP #TIB ! SWAP TO TIB >IN 0!
  ( ['] INTERPRET) CATCH
  R> >IN ! R> #TIB ! R> TO TIB R> TO SOURCE-ID
  THROW
;

: EVALUATE ( i*x c-addr u -- j*x ) \ 94
\ ��������� ������� ������������ �������� ������.
\ ���������� -1 � SOURCE-ID. ������ ������, �������� c-addr u,
\ ������� ������� � ������� �������, ������������� >IN � 0
\ � ��������������. ����� ������ ��������� �� ����� - ���������������
\ ������������ ����������� �������� ������.
\ ������ ��������� ����� ������������ ������������ �� EVALUATE �������.
  ['] INTERPRET EVALUATE-WITH
;

: (INCLUDE)
   BEGIN
     REFILL
   WHILE
     INTERPRET
   REPEAT
;

: PERCEIVE-WITH ( j*x addr u xt -- i*x ior )
\ ������� addr u - ������� �������, ��������� xt �� CATCH
\ ���� exception #TIB >IN � CURSTR �� ���������������!
   TIB >R #TIB @ >R 
   CURSTR @ >R >IN @ >R
   SWAP #TIB ! SWAP TO TIB 
   >IN 0! CURSTR 0!
   CATCH
   DUP IF RDROP RDROP RDROP
       ELSE R> >IN ! R> CURSTR ! R> #TIB !
       THEN
   R> TO TIB
;

: INCLUDE-FILE ( i*x fileid -- j*x ) \ 94 FILE
\ ������ fileid �� �����. ��������� ������� ������������ �������� ������,
\ ������� ������� �������� SOURCE-ID. �������� fileid � SOURCE-ID.
\ ������� ����, �������� fileid, ������� �������. �������� 0 � BLK.
\ ������ ��������� ����� ������������ ������� �� ����������� �����.
\ ��������� �� ����� �����: �������� ������ �� �����, ��������� �������
\ ����� ���������� ���� ������, ���������� >IN � ���� � ����������������.
\ ������������� ������ ���������� � �������, � ������� ������ �����������
\ ���������� ������ �����.
\ ����� ��������� ����� �����, ������� ���� � ������������ ������������
\ �������� ������ � �� ����������� ���������.
\ �������������� �������� ���������, ���� fileid �������, ���� ���������
\ �������������� �������� �����-������ �� ���� ������ fileid, ���
\ ��������� �������������� �������� ��� �������� �����. ����� �����
\ ����� �������������� ��������, ������ (������ ��� ������) �����
\ ���������������� ������ ������� �� ����������.
  BLK 0! SOURCE-ID >R
  FILE>RSTREAM TO SOURCE-ID
  C/L 2+ DUP ALLOCATE THROW DUP >R
  SWAP ['] (INCLUDE) PERCEIVE-WITH
  DUP IF R@ TIB C/L 2+ QCMOVE THEN  \ ����� ERROR ������ ��������
  SOURCE-ID FREE-RSTREAM CLOSE-FILE THROW
  R> FREE THROW
  R> TO SOURCE-ID
  THROW
;

: INCLUDE-PROBE ( addr u -- ... 0 | ior )
  R/O OPEN-FILE-SHARED ?DUP 
  IF NIP EXIT THEN
  INCLUDE-FILE 0
;

\ : INCLUDED ( i*x c-addr u -- j*x ) \ 94 FILE
\ ������ c-addr u �� �����. ��������� ������� ������������ �������� ������,
\ ������� ������� �������� SOURCE-ID. ������� ����, �������� c-addr u,
\ �������� ���������� fileid � SOURCE-ID � ������� ��� ������� �������.
\ �������� 0 � BLK.
\ ������ ��������� ����� ������������ ������� �� ����������� �����.
\ ��������� �� ����� �����: �������� ������ �� �����, ��������� �������
\ ����� ���������� ���� ������, ���������� >IN � ���� � ����������������.
\ ������������� ������ ���������� � �������, � ������� ������ �����������
\ ���������� ������ �����.
\ ����� ��������� ����� �����, ������� ���� � ������������ ������������
\ �������� ������ � �� ����������� ���������.
\ �������������� �������� ���������, ���� fileid �������, ���� ���������
\ �������������� �������� �����-������ �� ���� ������ fileid, ���
\ ��������� �������������� �������� ��� �������� �����. ����� �����
\ ����� �������������� ��������, ������ (������ ��� ������) �����
\ ���������������� ������ ������� �� ����������.

\  CURFILE @ >R
\  DUP CELL+ ALLOCATE THROW CURFILE !
\  2DUP CURFILE @ SWAP 1+ MOVE

\  R/O OPEN-FILE-SHARED ?DUP 
\  IF NIP CURFILE @ FREE DROP R> CURFILE ! THROW THEN ( ������ �������� ����� )
\  DUP >R
\  ['] INCLUDE-FILE CATCH
\  ?DUP IF R> CLOSE-FILE DROP THROW
\          \ ������� ������������� ���� � �������� ������ ����
\       ELSE R> DROP THEN

\  CURFILE @ FREE THROW R> CURFILE !
\ ;

: HEAP-COPY ( addr u -- addr1 )
\ ����������� ������ � ��� � ������� � ����� � ����
  DUP 0< IF 8 THROW THEN
  DUP 1+ ALLOCATE THROW DUP >R
  SWAP DUP >R MOVE
  0 R> R@ + C! R>
;

: INCLUDED ( i*x c-addr u -- j*x ) \ 94 FILE
\ ������ c-addr u �� �����. ��������� ������� ������������ �������� ������,
\ ������� ������� �������� SOURCE-ID. ������� ����, �������� c-addr u,
\ �������� ���������� fileid � SOURCE-ID � ������� ��� ������� �������.
\ �������� 0 � BLK.
\ ������ ��������� ����� ������������ ������� �� ����������� �����.
\ ��������� �� ����� �����: �������� ������ �� �����, ��������� �������
\ ����� ���������� ���� ������, ���������� >IN � ���� � ����������������.
\ ������������� ������ ���������� � �������, � ������� ������ �����������
\ ���������� ������ �����.
\ ����� ��������� ����� �����, ������� ���� � ������������ ������������
\ �������� ������ � �� ����������� ���������.
\ �������������� �������� ���������, ���� fileid �������, ���� ���������
\ �������������� �������� �����-������ �� ���� ������ fileid, ���
\ ��������� �������������� �������� ��� �������� �����. ����� �����
\ ����� �������������� ��������, ������ (������ ��� ������) �����
\ ���������������� ������ ������� �� ����������.
  CURFILE @ >R
  2DUP HEAP-COPY CURFILE !

  2DUP 2>R INCLUDE-PROBE
  IF 2R@ +LibraryDirName INCLUDE-PROBE IF 2R> +ModuleDirName INCLUDE-PROBE
                                       ELSE 2R> 2DROP 0
                                       THEN
  ELSE 2R> 2DROP 0 THEN
  CURFILE @ FREE THROW R> CURFILE !
  THROW
;
: REQUIRED ( waddr wu laddr lu -- )
  2SWAP SFIND
  IF DROP 2DROP EXIT
  ELSE 2DROP INCLUDED THEN
;
: REQUIRE ( "word" "libpath" -- )
  BL SKIP BL PARSE
  BL SKIP BL PARSE 2DUP + 0 SWAP C!
  REQUIRED
;

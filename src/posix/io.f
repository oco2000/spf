\ $Id$
\ 
\ �������� ����-�����
\ �. �������, 9.05.2007

: CLOSE-FILE ( fileid -- ior ) \ 94 FILE
\ ������� ����, �������� fileid.
\ ior - ������������ ����������� ��� ���������� �����/������.
  1 <( )) close ?ERR NIP
;

: CREATE-FILE ( c-addr u fam -- fileid ior ) \ 94 FILE
\ ������� ���� � ������, �������� c-addr u, � ������� ��� � ������������
\ � ������� ������� fam. ����� �������� fam ��������� �����������.
\ ���� ���� � ����� ������ ��� ����������, ������� ��� ������ ���
\ ������ ����.
\ ���� ���� ��� ������� ������ � ������, ior ����, fileid ��� �������������,
\ � ��������� ������/������ ���������� �� ������ �����.
\ ����� ior - ������������ ����������� ��� ���������� �����/������,
\ � fileid �����������.
  NIP 
  O_CREAT OR O_TRUNC OR 2 <( 0x1A4 ( 0644 = rw-r--r-- ) )) open64 ?ERR
;

: DELETE-FILE ( c-addr u -- ior ) \ 94 FILE
\ ������� ���� � ������, �������� ������� c-addr u.
\ ior - ������������ ����������� ��� ���������� �����/������.
  DROP 1 <( )) unlink ?ERR NIP
;

: FILE-POSITION ( fileid -- ud ior ) \ 94 FILE
\ ud - ������� ������� � �����, ���������������� fileid.
\ ior - ������������ ����������� ��� ���������� �����/������.
\ ud �����������, ���� ior �� ����.
  1 <( 0. SEEK_CUR __ret2 )) lseek64
  2DUP -1. D= IF errno ELSE 0 THEN
;

: OPEN-FILE ( c-addr u fam -- fileid ior ) \ 94 FILE
\ ������� ���� � ������, �������� ������� c-addr u, � ������� ������� fam.
\ ����� �������� fam ��������� �����������.
\ ���� ���� ������� ������, ior ����, fileid ��� �������������, � ����
\ �������������� �� ������.
\ ����� ior - ������������ ����������� ��� ���������� �����/������,
\ � fileid �����������.
  NIP 2 <( )) open64 ?ERR
;

\ � ������� ����� �� ��������� �� �����������.
\ ����� ���������� ��� ������������� � SPF/Win

: CREATE-FILE-SHARED ( c-addr u fam -- fileid ior )
  CREATE-FILE
;
: OPEN-FILE-SHARED ( c-addr u fam -- fileid ior )
  OPEN-FILE
;

: READ-FILE ( c-addr u1 fileid -- u2 ior ) \ 94 FILE
\ �������� u1 �������� � c-addr �� ������� ������� �����,
\ ����������������� fileid.
\ ���� u1 �������� ��������� ��� ����������, ior ���� � u2 ����� u1.
\ ���� ����� ����� ��������� �� ��������� u1 ��������, ior ����
\ � u2 - ���������� ������� ����������� ��������.
\ ���� �������� ������������ ����� ��������, ������������
\ FILE-POSITION ����� ��������, ������������� FILE-SIZE ��� �����
\ ����������������� fileid, ior � u2 ����.
\ ���� �������� �������������� ��������, �� ior - ������������ �����������
\ ��� ���������� �����/������, � u2 - ���������� ��������� ���������� �
\ c-addr ��������.
\ �������������� �������� ���������, ���� �������� �����������, �����
\ ��������, ������������ FILE-POSITION ������ ��� ��������, ������������
\ FILE-SIZE ��� �����, ����������������� fileid, ��� ��������� ��������
\ �������� �������� ������������ ����� �����.
\ ����� ���������� �������� FILE-POSITION ��������� ��������� �������
\ � ����� ����� ���������� ������������ �������.
  -ROT 3 <( )) read ?ERR
;

: REPOSITION-FILE ( ud fileid -- ior ) \ 94 FILE
\ ������������������� ����, ���������������� fileid, �� ud.
\ ior - ������������ ����������� ��� ���������� �����-������.
\ �������������� �������� ���������, ���� ��������������� ���
\ ��� ������.
\ ����� ���������� �������� FILE-POSITION ���������� �������� ud.
  -ROT 3 <( SEEK_SET __ret2 )) lseek64
  -1. D= IF errno ELSE 0 THEN
;


USER _fp1
USER _fp2
USER _addr

: READ-LINE ( c-addr u1 fileid -- u2 flag ior ) \ 94 FILE
\ �������� ��������� ������ �� �����, ��������� fileid, � ������
\ �� ������ c-addr. �������� �� ������ u1 ��������. �� ����
\ ������������ ����������� �������� "����� ������" ����� ����
\ ��������� � ������ �� ������ ������, �� �� �������� � ������� u2.
\ ����� ������ c-addr ������ ����� ������ ��� ������� u1+2 �������.
\ ���� �������� �������, flag "������" � ior ����. ���� ����� ������
\ ������� �� ���� ��� ��������� u1 ��������, �� u2 - ����� �������
\ ����������� �������� (0<=u2<=u1), �� ������ �������� "����� ������".
\ ����� u1=u2 ����� ������ ��� �������.
\ ���� �������� ������������, ����� ��������, ������������
\ FILE-POSITION ����� ��������, ������������� FILE-SIZE ��� �����,
\ ����������������� fileid, flag "����", ior ����, � u2 ����.
\ ���� ior �� ����, �� ��������� �������������� �������� � ior -
\ ������������ ����������� ��� ���������� �����-������.
\ �������������� �������� ���������, ���� �������� �����������, �����
\ ��������, ������������ FILE-POSITION ������ ��� ��������, ������������
\ FILE-SIZE ��� �����, ����������������� fileid, ��� ��������� ��������
\ �������� �������� ������������ ����� �����.
\ ����� ���������� �������� FILE-POSITION ��������� ��������� �������
\ � ����� ����� ���������� ������������ �������.
  DUP >R
  FILE-POSITION IF 2DROP 0 0 THEN _fp1 ! _fp2 !
  LTL @ +
  OVER _addr !

  R@ READ-FILE ?DUP IF NIP RDROP 0 0 ROT EXIT THEN

  DUP >R 0= IF RDROP RDROP 0 0 0 EXIT THEN \ ���� � ����� �����

  _addr @ R@ EOLN SEARCH
  IF   \ ������ ����������� �����
     DROP _addr @ -
     DUP
     LTL @ + S>D _fp2 @ _fp1 @ D+ RDROP R> REPOSITION-FILE DROP
  ELSE \ �� ������ ����������� �����
     2DROP
     R> RDROP  \ ���� ������ ��������� �� ��������� - ����� ���������
  THEN
  TRUE 0
;

: WRITE-FILE ( c-addr u fileid -- ior ) \ 94 FILE
\ �������� u �������� �� c-addr � ����, ���������������� fileid,
\ � ������� �������.
\ ior - ������������ ����������� ��� ���������� �����-������.
\ ����� ���������� �������� FILE-POSITION ���������� ���������
\ ������� � ����� �� ��������� ���������� � ���� ��������, �
\ FILE-SIZE ���������� �������� ������� ��� ������ ��������,
\ ������������� FILE-POSITION.
  -ROT DUP >R
  3 write-adr @ C-CALL 
  DUP -1 = IF 
    R> 2DROP errno
  ELSE
    R> <>
    ( ���� ���������� �� �������, ������� �����������, �� ���� ������ )
  THEN
;

: RESIZE-FILE ( ud fileid -- ior ) \ 94 FILE
\ ���������� ������ �����, ����������������� fileid, ������ ud.
\ ior - ������������ ����������� ��� ���������� �����-������.
\ ���� �������������� ���� ���������� ������, ��� �� ��������,
\ ����� �����, ����������� � ���������� ��������, ����� ����
\ �� ��������.
\ ����� ���������� �������� FILE-SIZE ���������� �������� ud
\ � FILE-POSITION ���������� �������������� ��������.
  -ROT 3 <( )) ftruncate64 ?ERR NIP
;

: WRITE-LINE ( c-addr u fileid -- ior ) \ 94 FILE
\ �������� u �������� �� c-addr � ����������� ��������� �� ���������� ������ 
\ ������ � ����, ���������������� fileid, ������� � ������� �������.
\ ior - ������������ ����������� ��� ���������� �����-������.
\ ����� ���������� �������� FILE-POSITION ���������� ���������
\ ������� � ����� �� ��������� ���������� � ���� ��������, �
\ FILE-SIZE ���������� �������� ������� ��� ������ ��������,
\ ������������� FILE-POSITION.
  DUP >R WRITE-FILE ?DUP IF RDROP EXIT THEN
  EOLN R> WRITE-FILE
;

: FLUSH-FILE ( fileid -- ior ) \ 94 FILE EXT
  1 <( )) fsync ?ERR NIP
;

USER-CREATE API-BUFFER
200 TC-USER-ALLOT

\ TRUE ���� ���������� ���� addr u
: FILE-EXIST ( addr u -- f )
  DROP >R (( _STAT_VER R> API-BUFFER )) __xstat 0=
;

\ TRUE ���� ���� addr u ���������� � �� �������� ���������
: FILE-EXISTS ( addr u -- f )
  FILE-EXIST 0 = IF FALSE EXIT THEN
  API-BUFFER STAT_ST_MODE + @ S_IFDIR AND 0 =
;

: FILE-SIZE ( fileid -- ud ior ) \ 94 FILE
\ ud - ������ � �������� �����, ���������������� fileid.
\ ior - ������������ ����������� ��� ���������� �����/������.
\ ��� �������� �� ������ �� ��������, ������������ FILE-POSITION.
\ ud �����������, ���� ior �� ����.
  >R (( _STAT_VER R> API-BUFFER )) __fxstat64
  -1 = IF 0. errno ELSE API-BUFFER STAT64_ST_SIZE + 2@ SWAP 0 THEN
;

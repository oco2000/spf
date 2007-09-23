\ $Id$
\ ������ �������� �� ��������

REQUIRE as-value ~ygrek/lib/list/ext.f
REQUIRE STR@ ~ac/lib/str5.f
REQUIRE LAMBDA{ ~pinka/lib/lambda.f
REQUIRE /TEST ~profit/lib/testing.f
REQUIRE axt=> ~profit/lib/bac4th-closures.f

\ ������� xt ��� ������� �������� ������
\ ���� xt ���������� 0 - ������� ��������� �� ������ (������ ���������� ����� ������� �������������)
\ ����� �������
\ ������������ �������������� ������
: filter-this ( xt node1 -- node2 )
  ( xt: node -- ? ) \ TRUE - remain, FALSE - free node
   lst(
    BEGIN
     DUP empty? 0=
    WHILE
     2>R
     2R@ SWAP EXECUTE IF R> DUP cdr >R add-node 2R> ELSE R> DUP cdr >R FREE-NODE 2R> THEN
    REPEAT
    2DROP
   )lst ;

\ ����� �� ������
\ � ������ ������ (xt ������ -1) ������������ node1 �� ������� ����� ��� ����������
\ ����� - ������ ������
\ xt: ( node -- ? ) \ TRUE - stop scan, FALSE - continue
: scan-list ( xt node -- node1 -1 | empty-list 0 )
   BEGIN
    DUP empty? 0=
   WHILE
    2>R
    2R@ SWAP EXECUTE IF R> RDROP TRUE EXIT THEN
    2R> cdr
   REPEAT
   NIP FALSE ;

\ ����� ������� ������ map � mapcar
WARNING @
WARNING 0!

: mapcar { xt node -- }
   BEGIN
    node empty? IF EXIT THEN
    node car xt EXECUTE
    node cdr -> node
   AGAIN ;

: map { xt node1 -- }
   BEGIN
    node1 empty? IF EXIT THEN
    node1 xt EXECUTE
    node1 cdr -> node1
   AGAIN ;

WARNING !

\ �������� � �������������� closure
\ ��� ���������� ��� ���� ��� axt=> �������� �� ������ ����� �� ���� �����
\ ���������� �������� node � bac4th-����� � ���������� ��������� �� ������ �������� �� �����
: list-remove-all ( val node -- node1 )
   SWAP S" car LITERAL <>" axt=> SWAP filter-this ;

\ �������������� ������ ������� ������ � ������� xt
\ xt: ( node-car -- val ) \ val ����� �������� � ������� �������������� ������� ������
: mapcar! ( xt node -- )
   SWAP S" >R R@ car [ COMPILE, ] R> setcar" axt=> SWAP map ;

( 
0 VALUE _list-map-xt
: mapcar!
   SWAP TO _list-map-xt
   LAMBDA{ >R R@ car _list-map-xt EXECUTE R> setcar } SWAP map ;
)

\ ������� �� ������ lst ��� ��������-���������
: list-remove-dublicates ( lst -- )
   BEGIN
    DUP empty? 0=
   WHILE
    DUP car OVER cdr list-remove-all cons
    cdr
   REPEAT DROP ;

: (list-iterate) { addr } addr @ DUP cdr addr ! ;
\ ������� xt ������� ��� ������ ������ ����� ��������� �� ����� ��������� ������� ������
\ xt: ( -- node1 )
: list-iterator ( list -- xt ) S" A_AHEAD [ HERE SWAP , ] A_THEN LITERAL (list-iterate)" axt ;

\ ������� ������ as-value ������ n �� ��������� �� ����� v1...vn
: nlist ( v1 ... vn n -- l ) () { l } 0 ?DO vnode l cons -> l LOOP l ;

\ bac4th-�������� �� ������
: list-> ( node --> node1 \ <-- ) \ clean-stack
   PRO
   BEGIN
    DUP empty? 0=
   WHILE
    DUP >R
    CONT
    R> cdr
   REPEAT DROP ;

\ bac4th-�������� �� ������
: list=> ( node --> node1 \ <-- )
   PRO
   BEGIN
    DUP empty? 0=
   WHILE
    DUP CONT cdr
   REPEAT DROP ;

\ �������� ������� node1 � ������ list ����� ������� ��������
\ ���� list ���� - ������ �� ������
\ list->...->nil
\ list->node1->...->nil
: insert-after ( node1 list -- )
   DUP empty? IF 2DROP EXIT THEN
   >R
   R@ cdr cons
   R> SWAP cons DROP ;

\ ��������� xt ��������������� � ����� �������� ���������
\ � ��������� ��������� � ������� ������
\ ��� ���� ���� ������ ������������� �� ���� �������
\ xt: ( node1-car node2-car )
: zipcar! ( xt node1 -- )
   { xt l }
   l cdr empty? IF EXIT THEN
   BEGIN
    l car l cdar xt EXECUTE l setcar
    l cddr empty? IF l cdr FREE-NODE l () LINK-NODE EXIT THEN
    l cdr -> l
   AGAIN ;

\ ��������� xt ��������������� � ������ ���� �������� ���������
\ xt: ( node1-car node2-car )
: zipcar ( xt node1 -- )
   { xt l | lcdr }
   BEGIN
    l cdr -> lcdr
    l car lcdr DUP empty? NOT
   WHILE
    car
    xt EXECUTE
    lcdr -> l
   REPEAT 2DROP ;

\ ��������� xt � "���������������" ����� ��������� ������� node1 node2
\ xt: ( node1i node2i -- )
: map2 { xt node1 node2 -- }
   BEGIN
    node1 empty? 0=
   WHILE
    node2 empty? 0=
   WHILE
    node1 node2 xt EXECUTE
    node1 cdr -> node1
    node2 cdr -> node2
   REPEAT
   THEN ;

\ �������� �� ��������� �� ��������
: equal? ( node1 node2 -- ? )
   BEGIN
    DUP empty? IF DROP empty? EXIT THEN
    OVER empty? IF 2DROP FALSE EXIT THEN
    OVER list-what OVER list-what <> IF 2DROP FALSE EXIT THEN
    DUP value? IF 2DUP car SWAP car <> IF 2DROP FALSE EXIT THEN THEN
    DUP str? IF 2DUP car STR@ ROT car STR@ COMPARE IF 2DROP FALSE EXIT THEN THEN
    DUP list? IF 2DUP car SWAP car RECURSE 0= IF 2DROP FALSE EXIT THEN THEN
    cdr SWAP cdr
   AGAIN TRUE ;

\ -----------------------------------------------------------------------

/TEST

REQUIRE TESTCASES ~ygrek/lib/testcase.f
\ REQUIRE write-list ~ygrek/lib/list/write.f

TESTCASES list-more

\
\ equal?

0 VALUE l1
0 VALUE l2

lst( 1 % 2 % " coo coo" %s lst( " so so" %s 200 % )lst %l 2000 % )lst TO l1
lst( 1 % 2 % " coo coo" %s lst( " so so" %s 200 % )lst %l 2000 % )lst TO l2

(( l1 l2 equal? -> TRUE ))
l1 FREE-LIST
l2 FREE-LIST

\
\ list-remove-all

lst( 1 % 2 % 4 % 2 % 3 % 4 % 6 % 6 % 2 % )lst TO l1
\ CR l write-list
2 l1 list-remove-all TO l1
lst( 1 % 4 % 3 % 4 % 6 % 6 % )lst TO l2
(( l1 l2 equal? -> TRUE ))
l2 FREE-LIST
\ CR l write-list
l1 list-remove-dublicates
lst( 1 % 4 % 3 % 6 % )lst TO l2
(( l1 l2 equal? -> TRUE ))
\ CR l write-list
l1 FREE-LIST
l2 FREE-LIST

%[ :NONAME 10 0 DO 2 % LOOP ; EXECUTE ]% TO l1
\ CR l write-list
l1 list-remove-dublicates
%[ 2 % ]% TO l2
\ CR l write-list
(( l1 l2 equal? -> TRUE ))
l1 FREE-LIST
l2 FREE-LIST

\
\ mapcar!

%[ 1 % 2 % 3 % ]% TO l1
:NONAME 2 + ; l1 mapcar!
%[ 3 % 4 % 5 % ]% TO l2
(( l1 l2 equal? -> TRUE ))
l1 FREE-LIST
l2 FREE-LIST

\
\ list-iter

%[ 1 % 2 % 3 % ]% TO l1
VECT z
l1 list-iterator TO z

(( z l1 equal? -> TRUE ))
(( z l1 cdr equal? -> TRUE ))
(( z length -> 1 ))
(( z empty? -> TRUE ))

(( 0 :NONAME l1 list-> car + ; EXECUTE -> 6 ))
l1 FREE-LIST
' z BEHAVIOR DESTROY-VC

\
\ zipcar!

%[ 1 % 2 % 3 % 4 % 5 % ]% TO l1
' + l1 zipcar!
%[ 3 % 5 % 7 % 9 % ]% TO l2
(( l1 l2 equal? -> TRUE ))
l1 FREE-LIST
l2 FREE-LIST

\
\ map2

1 1 1 1 1 1 DEPTH nlist TO l1
2 3 0 -2 3 4 DEPTH nlist TO l2
%[ :NONAME car SWAP car + % ; l1 l2 map2 ]% ( list )
l1 FREE-LIST
l2 FREE-LIST
( list ) TO l1
%[ 3 % 4 % 1 % -1 % 4 % 5 % ]% TO l2
(( l1 l2 equal? -> TRUE ))
l1 FREE-LIST
l2 FREE-LIST

\
\ concat-list

%[ 1 % 2 % 3 % 4 % ]%  %[ 5 % 6 % 7 % ]%  concat-list TO l1
%[ 1 % 2 % 3 % 4 % 5 % 6 % 7 % ]% TO l2
(( l1 l2 equal? -> TRUE ))
l1 FREE-LIST
l2 FREE-LIST

%[ 1 % 2 % 3 % 4 % ]% () concat-list TO l1
%[ 1 % 2 % 3 % 4 % ]% TO l2
(( l1 l2 equal? -> TRUE ))
l1 FREE-LIST
l2 FREE-LIST

() %[ 1 % 2 % 3 % 4 % ]% concat-list TO l1
%[ 1 % 2 % 3 % 4 % ]% TO l2
(( l1 l2 equal? -> TRUE ))
l1 FREE-LIST
l2 FREE-LIST

\
\ foldl
%[ 1 % 2 % 3 % 3 % 4 % 5 % ]% TO l1
%[ :NONAME + % ; l1 zipcar ]% TO l2
l1 FREE-LIST
%[ 3 % 5 % 6 % 7 % 9 % ]% TO l1
(( l1 l2 equal? -> TRUE ))
l1 FREE-LIST
l2 FREE-LIST

END-TESTCASES

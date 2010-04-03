\ ������ ��� ��������� ������������� ASN.1-��������.
\ X.690 Information technology - ASN.1 encoding rules:
\ Specification of Basic Encoding Rules (BER),
\ Canonical Encoding Rules (CER) and
\ Distinguished Encoding Rules (DER)

\ ��������� ����� ������� � ������ ������ ASN.1, ���.22
\ X.680 Information technology - Abstract Syntax
\ Notation One (ASN.1): Specification of basic
\ notation

\ ���������� OIDs: http://www.alvestrand.no/objectid/1.2.840.113549.1.9.1.html
\ http://www.oid-info.com/cgi-bin/display?tree=1.2.840.113549.1.1.4&see=all

REQUIRE >UTF8  ~ac/lib/lin/iconv/iconv.f 

\ basic ASN.1 types
1 CONSTANT ASN_BOOLEAN
2 CONSTANT ASN_INTEGER \ (ASN_UNIVERSAL | ASN_PRIMITIVE | 0x02)
3 CONSTANT ASN_BITS
4 CONSTANT ASN_OCTETSTRING
5 CONSTANT ASN_NULL
6 CONSTANT ASN_OBJECTIDENTIFIER

\ string types
0x0C CONSTANT ASN_UTF8_STRING
0x13 CONSTANT ASN_PRINTABLE_STRING
0x14 CONSTANT ASN_TELETEX_STRING \ openssl ���������� ��� utf8-������...
0x16 CONSTANT ASN_IA5_STRING     \ �������� email
0x17 CONSTANT ASN_UTCTime        \ �������� 100329134908Z
0x1E CONSTANT ASN_UNICODE_STRING \ BMPString


\ ������, �� ������� � ���� ����������� ������ enum
   7 CONSTANT ASN_OBJECTDESCRIPTOR
   8 CONSTANT ASN_EXTERNAL
   9 CONSTANT ASN_REAL
0x0A CONSTANT ASN_ENUM
0x0B CONSTANT ASN_EMBED
0x0D CONSTANT ASB_REL_OID
\ 0x0E, 0x0F reserved
\ 0x10 - ��. sequence

\ constructed types

\ fixme: ��������� ASN_* �������� ������������ � ~ac/lib/win/snmp/snmp.f,
\        �� �� �������� �� windows-, �� snmp- ������������, ������� ���� 
\        ��������� �� ����

0x00 CONSTANT ASN_UNIVERSAL
0x40 CONSTANT ASN_APPLICATION
0x80 CONSTANT ASN_CONTEXT
0xC0 CONSTANT ASN_PRIVATE

0x00 CONSTANT ASN_PRIMITIVE
0x20 CONSTANT ASN_CONSTRUCTOR

0x30 CONSTANT ASN_SEQUENCE \ (ASN_UNIVERSAL | ASN_CONSTRUCTOR | 0x10)
0x31 CONSTANT ASN_SET

\ #define SNMP_PDU_GET                (ASN_CONTEXT | ASN_CONSTRUCTOR | 0x0)
\ #define SNMP_PDU_GETNEXT            (ASN_CONTEXT | ASN_CONSTRUCTOR | 0x1)
\ #define SNMP_PDU_RESPONSE           (ASN_CONTEXT | ASN_CONSTRUCTOR | 0x2)
\ #define SNMP_PDU_SET                (ASN_CONTEXT | ASN_CONSTRUCTOR | 0x3)
\ #define SNMP_PDU_V1TRAP             (ASN_CONTEXT | ASN_CONSTRUCTOR | 0x4)
\ #define SNMP_PDU_GETBULK            (ASN_CONTEXT | ASN_CONSTRUCTOR | 0x5)
\ #define SNMP_PDU_INFORM             (ASN_CONTEXT | ASN_CONSTRUCTOR | 0x6)
\ #define SNMP_PDU_TRAP               (ASN_CONTEXT | ASN_CONSTRUCTOR | 0x7)

\ #define ASN_IPADDRESS               (ASN_APPLICATION | ASN_PRIMITIVE | 0x00)
\ #define ASN_COUNTER32               (ASN_APPLICATION | ASN_PRIMITIVE | 0x01)
\ #define ASN_GAUGE32                 (ASN_APPLICATION | ASN_PRIMITIVE | 0x02)
\ #define ASN_TIMETICKS               (ASN_APPLICATION | ASN_PRIMITIVE | 0x03)
\ #define ASN_OPAQUE                  (ASN_APPLICATION | ASN_PRIMITIVE | 0x04)
\ #define ASN_COUNTER64               (ASN_APPLICATION | ASN_PRIMITIVE | 0x06)
\ #define ASN_UINTEGER32              (ASN_APPLICATION | ASN_PRIMITIVE | 0x07)
\ #define ASN_RFC2578_UNSIGNED32      ASN_GAUGE32


: AsnStrDer> { a u \ u2 l z lz -- a2 u2 }
  a C@ 128 = IF a 1+ -1 EXIT THEN \ indefinite form - �� end-of-contents octets
  a C@ DUP 128 < IF a 1+ SWAP EXIT THEN
  \ � ��� 128 � ����� ������ � asn.1 ��������� 2 ��� ����� ������ �� �����
  \ 0x81 0x80 - ������������� ����� 128
  127 AND DUP -> u2 \ ����� �����
  0 ?DO
    a 1+ I + C@ l 8 LSHIFT + -> l
  LOOP
  a 1+ u2 + l
;
: AsnStr> { a u \ u2 l i -- a2 u2 }
\ ����������� ������ � asn1-��������� (a) � ����-������ a2 u2
\ ��. �� �� ������� asn_str> � ~ac/lib/lin/asn1/tasn1.f 
  a C@ 128 <> IF a u AsnStrDer> EXIT THEN
  a 1+ -> a u 1- -> u
  BEGIN
    a l + W@ 0= IF 
                  l 2+ -> l i 1- -> i
                  i 0 > 0= IF a l EXIT THEN
                THEN
    l 1+ -> l \ ������� ����
    a l + u l - AsnStrDer> DUP -1 =
    IF 2DROP l 1+ -> l i 1+ -> i
    ELSE
       DUP 0=
       IF 2DROP l 1- -> l
       ELSE + a - -> l THEN
    THEN
  AGAIN
;

USER uAsnLevel

: OID. ( a u -- )
  OVER C@ 40 /MOD 0 
  ." OID=" <# #S #> TYPE ." ." 0 <# #S #> TYPE ." ."
  1- 0 MAX SWAP 1+ SWAP
  BEGIN
    DUP 0 >
  WHILE
    OVER C@ DUP 128 <
    IF
      0 <# #S #> TYPE ." ."
      1- SWAP 1+ SWAP
    ELSE
      127 AND 7 LSHIFT >R
      BEGIN
        OVER 1+ C@ DUP 127 >
      WHILE
        127 AND R> + 7 LSHIFT >R
        1- SWAP 1+ SWAP
      REPEAT
      127 AND R> + 0 <# #S #> TYPE ." ."
      2- SWAP 2+ SWAP
    THEN
  REPEAT 2DROP
;

: AsnInt@ ( a u -- x ) \ ������������ �������������
  0 SWAP
  0 ?DO
    OVER I + C@ SWAP 8 LSHIFT +
  LOOP NIP
;
: INT. ( a u -- )
  AsnInt@ .
;
VECT vAsn1Parse

: BITS. ( a u -- )
  BASE @ >R 2 BASE ! INT. R> BASE !
EXIT \ ������� ������� ������ :)
  DUP 0= IF 2DROP EXIT THEN
  10 MIN DUMP
;
: OCT. ( a u -- )
\  BASE @ >R 2 BASE ! INT. R> BASE !
  DUP 0= IF 2DROP EXIT THEN
  OVER C@ ASN_SEQUENCE =
  IF ." [embed seq]" CR CR vAsn1Parse DROP
  ELSE OVER C@ ASN_IA5_STRING =
    IF ." [embed ia5]" CR CR vAsn1Parse DROP
    ELSE 30 MIN TYPE ( DUMP) THEN
  THEN
;
: ASN. { a u t -- }
  t 0x3F AND -> t
  t ASN_OBJECTIDENTIFIER = IF a u OID. EXIT THEN
  t ASN_INTEGER = IF a u INT. EXIT THEN
  t ASN_ENUM = IF a u INT. EXIT THEN
  t ASN_BITS = IF a u BITS. EXIT THEN
  t ASN_OCTETSTRING = IF a u OCT. EXIT THEN
  a u
  t ASN_TELETEX_STRING =
  IF UTF8> THEN TYPE
;

VARIABLE AsnDebug \ TRUE AsnDebug !

0
CELL -- asNextPart \ ����� ��������� ���� �� ������
CELL -- asTag
CELL -- asAddr     \ ���� �������
CELL -- asLen
CELL -- asPartAddr \ ��� ����� ���������
CELL -- asPartLen
CELL -- asLevel    \ ������� �����������
CELL -- asIndex    \ ����� �� ������
CELL -- asIsMultipart \ �������� �� ���������
CELL -- asParts    \ ������ ������ ��������� ���������
CELL -- asChilds#  \ �-�� ��������� ��������� (�� ����� ������)
CELL -- asPar      \ ������� �������
CELL -- asOID      \ ���������� ������������� OID ��� tag=ASN_OBJECTIDENTIFIER
CELL -- asName     \ ������������� ���, ������������ �� ���������� �������
                   \ �� ������ ������ �������� (������� ��������� MIME-������ � IMAP)
                   \ - ��� ������ �� ������ ���� "ASN.1.3.2"
CONSTANT /AsnPart


: Asn1ParseR { a u par prev \ a2 u2 t n as -- }

  uAsnLevel 1+!
  TRUE -> t
  BEGIN
    u 1 >
    t AND \ ��������� �� ������������� �������
  WHILE
    n 1+ -> n
    par asChilds# 1+!
    /AsnPart ALLOCATE THROW -> as
    prev IF
      as prev asNextPart ! \ ��������� � ������ �������, � �� � �������� ��������
    ELSE
      as par asParts !
    THEN
    par as asPar !
    uAsnLevel @ 1- as asLevel !
    a as asAddr !
    u as asLen !
    a C@ DUP -> t
      as asTag !
    n as asIndex !
    n par asName @ STR@ " {s}.{n}" as asName !
    AsnDebug @ IF uAsnLevel @ 1- 0 MAX 0 ?DO ."  |" LOOP THEN
    AsnDebug @ IF t ." 0x" HEX . DECIMAL THEN
    a 1+ u 1- AsnStr> -> u2 -> a2
    AsnDebug @ IF ." (" u2 . ." ) " THEN
    a2 as asPartAddr !
    u2 as asPartLen !
    t ASN_CONSTRUCTOR AND 
    IF AsnDebug @ IF CR THEN
       TRUE as asIsMultipart !
       a2 u2 as 0 RECURSE
    ELSE
       AsnDebug @ IF a2 u2 t ASN. CR THEN
    THEN
    a2 u2 + a u + OVER - -> u -> a
    as -> prev
  REPEAT
  uAsnLevel @ 1- uAsnLevel !
;
: Asn1Parse { a u \ as -- as }
  \ � "a u" �� ������ ����� ����� ���� ���������
  \ ���������, ������� ���� ������� ������������ �� ��������� asChilds#.
  \ ������������ ������ ������.
  \ ���� ��������� ������� ����� �������� �����������,
  \ ����� �������� ��� ����� asPar @.
  /AsnPart ALLOCATE THROW -> as
  uAsnLevel @ as asLevel !
  a as asAddr !
  u as asLen !
  a C@ as asTag !
  " ASN" as asName !

  a u as 0 Asn1ParseR
  as asParts @
;
' Asn1Parse TO vAsn1Parse

: Asn1Dump { as -- }
  as 0= IF EXIT THEN
  BEGIN
    as asLevel @ 0 ?DO ."  |" LOOP
    as asIndex @ . ." |"
    as asTag @ ." 0x" HEX . DECIMAL
    as asPartLen @ ." (" . as asName @ STR@ TYPE ." ) "
    as asIsMultipart @
    IF CR as asParts @ RECURSE
    ELSE
       as asPartAddr @ as asPartLen @ as asTag @ ASN. CR
    THEN
    as asNextPart @ DUP 0=
    SWAP -> as
  UNTIL
;
: Asn1GetPart { pna pnu as -- as2 }
  \ ����� ������� �� ASN.n.n-�����
  \ ���� ������ ���, ������������ 0
  as 0= IF 0 EXIT THEN
  BEGIN
    as asName @ STR@ pna pnu COMPARE 0=
    IF as EXIT THEN
    as asIsMultipart @
    IF pna pnu as asParts @ RECURSE
       ?DUP IF EXIT THEN
    THEN
    as asNextPart @ DUP 0=
    SWAP -> as
  UNTIL
  0
;
: Asn1GetPartContent { pna pnu as -- a u tag }
  pna pnu as Asn1GetPart ?DUP
  IF -> as
     as asPartAddr @
     as asPartLen @
     as asTag @
  ELSE S" " 0 THEN
;

\ fixme: �������� ����� �� OID
\. 11-07-2004 ࠧ��� ��ப � ࠧ��筮�� ���� ࠧ����⥫ﬨ
\ � ⮬ �᫥, ����� ࠧ����⥫� ������ �ᯮ�������

\ ����� �� ��ப� �᫮ � ��⭠����筮� ����
: HCHAR ( addr # -> CHAR ) 0 0 2SWAP >NUMBER IF THROW THEN 2DROP ;

\ ��࠭��� ᯨ᮪ ࠧ����⥫�� �� HERE ������ ������
: +delimiters ( addr --> # )
              BASE @ >R HEX
              >R
              BEGIN PeekChar 0x0A <> WHILE
                    NextWord DUP WHILE
                    HCHAR R@ + -1 SWAP C!
               REPEAT 2DROP
              THEN
              RDROP
              R> BASE !
              ;


\ ᮧ���� ᯨ᮪ ࠧ����⥫��
\ ࠧ����⥫� ������� � 16 ����, ����� ��室����� ⮫쪮 �� ����� ��ப�
: Delimiter: ( | xd xd xd EOL --> )
             CREATE HERE DUP 256 DUP ALLOT ERASE +delimiters
             ( --> addr )
             DOES> ;


: xWord ( delim --> ASC # )
        CharAddr >R
        BEGIN GetChar WHILE
              OVER + C@ 0= WHILE
              >IN 1+!
          REPEAT DUP
        THEN 2DROP
        R> CharAddr OVER -
        ;

\EOF

Delimiter: proba 3A 3B 5B 5D

: test  proba xWord  ." << "
        CR TYPE CR   ."  >>"
        ;
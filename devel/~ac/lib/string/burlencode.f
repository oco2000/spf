REQUIRE replace-str ~pinka/samples/2005/lib/replace-str.f 

: bUrlencode ( addr u -- addr2 u2 ) \ url-����������� base64-����� � url'��, 8bit ������� �� ����������
\ fixme: ��������������, ������� � ��������� ������� ��� ����� ������� � ����� ����������� :)
  " {s}" 
  DUP " %" " %25" replace-str-
  DUP " $" " %24" replace-str-
  DUP " &" " %26" replace-str-
  DUP " +" " %2B" replace-str-
  DUP " ," " %2C" replace-str-
  DUP " /" " %2F" replace-str-
  DUP " :" " %3A" replace-str-
  DUP " ;" " %3B" replace-str-
  DUP " =" " %3D" replace-str-
  DUP " ?" " %3F" replace-str-
  DUP " @" " %40" replace-str-
  DUP " #" " %23" replace-str-
  DUP " {''}" " %22" replace-str-
  DUP " <" " %3C" replace-str-
  DUP " >" " %3E" replace-str-
  STR@
;

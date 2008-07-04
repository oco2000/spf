REQUIRE CLSID,  ~ac/lib/win/com/com.f

     0 CONSTANT VT_EMPTY
     1 CONSTANT VT_NULL
     2 CONSTANT VT_I2
     3 CONSTANT VT_I4
     4 CONSTANT VT_R4
     5 CONSTANT VT_R8
     6 CONSTANT VT_CY
     7 CONSTANT VT_DATE
     8 CONSTANT VT_BSTR
     9 CONSTANT VT_DISPATCH
    10 CONSTANT VT_ERROR
    11 CONSTANT VT_BOOL
    12 CONSTANT VT_VARIANT
    13 CONSTANT VT_UNKNOWN
    14 CONSTANT VT_DECIMAL
    16 CONSTANT VT_I1
    17 CONSTANT VT_UI1
    18 CONSTANT VT_UI2
    19 CONSTANT VT_UI4
    20 CONSTANT VT_I8
    21 CONSTANT VT_UI8
    22 CONSTANT VT_INT
    23 CONSTANT VT_UINT
    24 CONSTANT VT_VOID
    25 CONSTANT VT_HRESULT
    26 CONSTANT VT_PTR
    27 CONSTANT VT_SAFEARRAY
    28 CONSTANT VT_CARRAY
    29 CONSTANT VT_USERDEFINED
    30 CONSTANT VT_LPSTR
    31 CONSTANT VT_LPWSTR
    36 CONSTANT VT_RECORD
    37 CONSTANT VT_INT_PTR
    38 CONSTANT VT_UINT_PTR
    64 CONSTANT VT_FILETIME
    65 CONSTANT VT_BLOB
    66 CONSTANT VT_STREAM
    67 CONSTANT VT_STORAGE
    68 CONSTANT VT_STREAMED_OBJECT
    69 CONSTANT VT_STORED_OBJECT
    70 CONSTANT VT_BLOB_OBJECT
    71 CONSTANT VT_CF
    72 CONSTANT VT_CLSID
    73 CONSTANT VT_VERSIONED_STREAM
 0xFFF CONSTANT VT_BSTR_BLOB
0x1000 CONSTANT VT_VECTOR
0x2000 CONSTANT VT_ARRAY
0x4000 CONSTANT VT_BYREF
0x8000 CONSTANT VT_RESERVED
0xFFFF CONSTANT VT_ILLEGAL
 0xFFF CONSTANT VT_ILLEGALMASKED
 0xFFF CONSTANT VT_TYPEMASK

: NVAR ( val type -- variant )
  16 ALLOCATE THROW >R
  R@ ! R@ 8 + !
  R>
;
: NSTR ( addr u -- variant )
  >BSTR VT_BSTR NVAR
;
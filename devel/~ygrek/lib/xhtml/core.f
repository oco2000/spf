\ $Id$
\
\ Some common XHTML words

REQUIRE xmltag ~ygrek/lib/xmltag.f
REQUIRE AsQWord ~pinka/spf/quoted-word.f
REQUIRE XMLSAFE ~ygrek/lib/xmlsafe.f
REQUIRE S$ ~pinka/samples/2005/lib/s-dollar.f

MODULE: XHTML

\ shortcuts
: << POSTPONE START{ ; IMMEDIATE
: >> POSTPONE }EMERGE ; IMMEDIATE

: :span ( `class -- ) PRO %[ `class $$ ]% `span atag CONT ;
: span: ( "class" -- ) PARSE-NAME PRO :span CONT ;
: hrule `hr /tag ;

: th ( a u -- ) `th tag XMLSAFE::TYPE ;
: tr ( <--> ) PRO `tr tag CONT ;
: td PRO `td tag CONT ;

: :div ( `class -- ) PRO %[ `class $$ ]% `div atag CONT ;

: link-tag ( `url --> \ <-- ) PRO %[ `href $$ ]% `a atag CONT ;
: link-s ( strurl --> \ <-- ) PRO DUP STR@ link-tag STRFREE CONT ;
: link-text ( `text `url -- ) link-tag XMLSAFE::TYPE ;

: li `li PRO tag CONT ;
: ul `ul PRO tag CONT ;
: mdash ."  &mdash; " ;

: xml-declaration-enc ( a u -- ) S$ |<?xml version="1.0" encoding="| TYPE TYPE S$ |"?>| TYPE CR ;
: xml-declaration ( -- ) `utf-8 xml-declaration-enc ;

: doctype-strict ( -- )
  S$ |<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">| TYPE CR ;

: xhtml ( <--> )
  PRO
  %[ `http://www.w3.org/1999/xhtml `xmlns $$ ( `en `xml:lang $$ `en `lang $$ ) ]% atag: html 
  CONT ;
  
: meta ( `value `name -- ) %[ `name $$ `content $$ ]% /atag: meta ;
: http-equiv ( `value `name -- ) %[ `http-equiv $$ `content $$ ]% /atag: meta ;

: link-stylesheet ( `href -- ) %[ `href $$ `stylesheet `rel $$ `text/css `type $$ ]% /atag: link ;

;MODULE


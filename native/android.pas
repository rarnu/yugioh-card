unit android;

{$ifdef fpc}
 {$mode delphi}
{$endif}

interface

const
  libname = 'log';

  ANDROID_LOG_UNKNOWN = 0;
  ANDROID_LOG_DEFAULT = 1;
  ANDROID_LOG_VERBOSE = 2;
  ANDROID_LOG_DEBUG = 3;
  ANDROID_LOG_INFO = 4;
  ANDROID_LOG_WARN = 5;
  ANDROID_LOG_ERROR = 6;
  ANDROID_LOG_FATAL = 7;
  ANDROID_LOG_SILENT = 8;

type
  android_LogPriority = integer;

{$IFDEF ANDROID}
function __android_log_write(prio: longint; tag, Text: PChar): longint; cdecl; external libname Name '__android_log_write';
function LOGI(prio: longint; tag, Text: PChar): longint; cdecl; varargs; external libname Name '__android_log_print';
function __system_property_get(Name: PChar; Value: PChar): integer; cdecl; external 'c';
{$ENDIF}

procedure LOGE(Text: string);

implementation

procedure LOGE(Text: string);
begin
  {$IFDEF ANDROID}
  __android_log_write(ANDROID_LOG_ERROR, 'VAPI', PChar(Text));
  {$ELSE}
  WriteLn(Text);
  {$ENDIF}
end;

end.

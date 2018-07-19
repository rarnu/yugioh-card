unit nativeapi;

{$mode objfpc}{$H+}

interface

uses
  dynlibs, Classes, SysUtils;

type
  TAPIParse = function (ahtml: PChar; atype: Integer): PChar; cdecl;

var
  parse: TAPIParse = nil;

implementation

var
  hLib: TLibHandle = 0;

procedure load();
const
  LIBNAME = {$IFDEF WINDOWS}'yugiohapi.dll'{$ELSE}{$IFDEF DARWIN}'libyugiohapi.dylib'{$ELSE}'libyugiohapi.so'{$ENDIF}{$ENDIF};
var
  libPath: string;
begin
  libPath:= ExtractFilePath(ParamStr(0)) + LIBNAME;
  if (FileExists(libPath)) then begin
    hLib:= LoadLibrary(libPath);
    parse:= TAPIParse(GetProcAddress(hLib, 'parse'));
  end;
end;

procedure release();
begin
  if (hLib > 0) then begin
    FreeLibrary(hLib);
  end;
end;

initialization
  load();

finalization
  release();

end.


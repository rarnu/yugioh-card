unit apiYugioh;

{$mode objfpc}{$H+}

interface 

uses
  Classes, SysUtils, dynlibs;

type

  { TYGOAPI }

  TYGOAPI = class
  public
    class function cardSearch(
      aname: string;
      ajapname: string;
      aenname: string;
      arace: string;
      aelement: string;
      aatk: string;
      adef: string;
      alevel: string;
      apendulum: string;
      alink: string;
      alinkarrow: string;
      acardtype: string;
      acardtype2: string;
      aeffect: string;
      apage: Integer): string;
    class function cardDetail(acardid: string): string;
    class function cardAdjust(acardid: string): string;
    class function cardWiki(acardid: string): string;
    class function cardLimit(): string;
    class function cardPackageList(): string;
    class function cardPackageDetail(apackageid: string): string;
  end;

implementation

type
  TAPICardSearch = function (
    aname: PChar;
    ajapname: PChar;
    aenname: PChar;
    arace: PChar;
    aelement: PChar;
    aatk: PChar;
    adef: PChar;
    alevel: PChar;
    apendulum: PChar;
    alink: PChar;
    alinkarrow: PChar;
    acardtype: PChar;
    acardtype2: PChar;
    aeffect: PChar;
    apage: Integer): PChar; cdecl;

  TAPICardDetail = function (acardid: PChar): PChar; cdecl;
  TAPICardAdjust = function (acardid: PChar): PChar; cdecl;
  TAPICardWiki = function (acardid: PChar): PChar; cdecl;
  TAPICardLimit = function (): PChar; cdecl;
  TAPICardPackageList = function (): PChar; cdecl;
  TAPICardPackageDetail = function (apackageid: PChar): PChar; cdecl;

var
  hLib: TLibHandle = 0;
  varCardSearch: TAPICardSearch;
  varCardDetail: TAPICardDetail;
  varCardAdjust: TAPICardAdjust;
  varCardWiki: TAPICardWiki;
  varCardLimit: TAPICardLimit;
  varCardPackageList: TAPICardPackageList;
  varCardPackageDetail: TAPICardPackageDetail;

procedure load();
const
  LIBNAME = {$IFDEF WINDOWS}'yugiohapi.dll'{$ELSE}{$IFDEF DARWIN}'libyugiohapi.dylib'{$ELSE}'libyugiohapi.so'{$ENDIF}{$ENDIF};
var
  libPath: string;
begin
  libPath := ExtractFilePath(ParamStr(0)) + LIBNAME;
  if (FileExists(libPath)) then begin
    hLib := LoadLibrary(libPath);
    varCardSearch := TAPICardSearch(GetProcAddress(hLib, 'cardSearch'));
    varCardDetail:= TAPICardDetail(GetProcAddress(hLib, 'cardDetail'));
    varCardAdjust:= TAPICardAdjust(GetProcAddress(hLib, 'cardAdjust'));
    varCardWiki:= TAPICardWiki(GetProcAddress(hLib, 'cardWiki'));
    varCardLimit:= TAPICardLimit(GetProcAddress(hLib, 'cardLimit'));
    varCardPackageList:= TAPICardPackageList(GetProcAddress(hLib, 'cardPackageList'));
    varCardPackageDetail:= TAPICardPackageDetail(GetProcAddress(hLib, 'cardPackageDetail'));
  end;
end;

procedure release();
begin
  if (hLib > 0) then begin
    FreeLibrary(hLib);
  end;
end;

{ TYGOAPI }

class function TYGOAPI.cardSearch(aname: string; ajapname: string;
  aenname: string; arace: string; aelement: string; aatk: string; adef: string;
  alevel: string; apendulum: string; alink: string; alinkarrow: string;
  acardtype: string; acardtype2: string; aeffect: string; apage: Integer
  ): string;
begin
  Exit(string(varCardSearch(
    PChar(aname),
    PChar(ajapname),
    PChar(aenname),
    PChar(arace),
    PChar(aelement),
    PChar(aatk),
    PChar(adef),
    PChar(alevel),
    PChar(apendulum),
    PChar(alink),
    PChar(alinkarrow),
    PChar(acardtype),
    PChar(acardtype2),
    PChar(aeffect),
    apage
  )));
end;

class function TYGOAPI.cardDetail(acardid: string): string;
begin
  Exit(string(varCardDetail(PChar(acardid))));
end;

class function TYGOAPI.cardAdjust(acardid: string): string;
begin
  Exit(string(varCardAdjust(PChar(acardid))));
end;

class function TYGOAPI.cardWiki(acardid: string): string;
begin
  Exit(string(varCardWiki(PChar(acardid))));
end;

class function TYGOAPI.cardLimit(): string;
begin
  Exit(string(varCardLimit()));
end;

class function TYGOAPI.cardPackageList(): string;
begin
  Exit(string(varCardPackageList()));
end;

class function TYGOAPI.cardPackageDetail(apackageid: string): string;
begin
  Exit(string(varCardPackageDetail(PChar(apackageid))));
end;

initialization
  load();

finalization
  release();

end.

unit ygodata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, jsonscanner, fgl, nativeapi, ygorequest;

type
  TPackageInfo = class
  public
    season: string;
    url: string;
    Name: string;
    abbr: string;
  end;

  TLimitInfo = class
  public
    limit: integer;
    color: string;
    hashid: string;
    Name: string;
  end;

  TCardPackInfo = class
  public
    url: string;
    Name: string;
    date: string;
    abbr: string;
    rare: string;
  end;

  TCardPackInfoList = specialize TFPGList<TCardPackInfo>;

  { TCardDetail }

  TCardDetail = class
  public
    Name: string;
    japname: string;
    enname: string;
    cardtype: string;
    password: string;
    limit: string;
    belongs: string;
    rare: string;
    pack: string;
    effect: string;
    race: string;
    element: string;
    level: string;
    atk: string;
    def: string;
    link: string;
    packs: TCardPackInfoList;
    adjust: string;
    wiki: string;
    constructor Create;
    destructor Destroy; override;
  end;

  TCardInfo = class
  public
    cardid: integer;
    hashid: string;
    Name: string;
    japname: string;
    enname: string;
    cardtype: string;
  end;

  TCardInfoList = specialize TFPGList<TCardInfo>;


  { TSearchResult }

  TSearchResult = class
  public
    Data: TCardInfoList;
    page: integer;
    pageCount: integer;
    constructor Create;
    destructor Destroy; override;
  end;

  THotCard = class
  public
    hashid: string;
    name: string;
  end;

  THotPack = class
  public
    packid: string;
    name: string;
  end;

  THotCardList = specialize TFPGList<THotCard>;
  THotPackList = specialize TFPGList<THotPack>;

  { THotest }

  THotest = class
  public
    search: TStringList;
    card: THotCardList;
    pack: THotPackList;
    constructor Create;
    destructor Destroy; override;
  end;

  { TYGOData }

  TLimitList = specialize TFPGList<TLimitInfo>;
  TPackageList = specialize TFPGList<TPackageInfo>;

  TYGOData = class
  private
    class function parseSearchResult(jsonString: string): TSearchResult;
  public
    class function searchCommon(akey: string; apage: integer): TSearchResult;
    class function searchComplex(aname: string; ajapname: string; aenname: string; arace: string; aelement: string;
      aatk: string; adef: string; alevel: string; apendulum: string; alink: string; alinkarrow: string; acardtype: string;
      acardtype2: string; aeffect: string; apage: integer): TSearchResult;
    class function cardDetail(hashid: string): TCardDetail;
    class function limit(): TLimitList;
    class function packageList(): TPackageList;
    class function packageDetail(aurl: string): TSearchResult;
    class function hostest(): THotest;
  end;


implementation

{ THotest }

constructor THotest.Create;
begin
  search := TStringList.Create;
  card := THotCardList.Create;
  pack := THotPackList.Create;
end;

destructor THotest.Destroy;
var
  i: Integer;
begin
  search.Free;
  for i := card.Count - 1 downto 0 do card[i].Free;
  card.Free;
  for i := pack.Count - 1 downto 0 do pack[i].Free;
  pack.Free;
  inherited Destroy;
end;

{ TYGOData }

class function TYGOData.parseSearchResult(jsonString: string): TSearchResult;
var
  parser: TJSONParser;
  json: TJSONObject;
  jarr: TJSONArray;
  jobj: TJSONObject;
  i: integer;
  info: TCardInfo;
begin
  parser := TJSONParser.Create(jsonString, []);
  json := TJSONObject(parser.Parse);
  Result := TSearchResult.Create;
  if (json.Integers['result'] = 0) then
  begin
    Result.page := json.Integers['page'];
    Result.pageCount := json.Integers['pagecount'];
    jarr := json.Arrays['data'];
    for i := 0 to jarr.Count - 1 do
    begin
      jobj := jarr.Objects[i];
      info := TCardInfo.Create;
      info.cardid := jobj.Integers['id'];
      info.hashid := jobj.Strings['hashid'];
      info.Name := jobj.Strings['name'];
      info.japname := jobj.Strings['japname'];
      info.enname := jobj.Strings['enname'];
      info.cardtype := jobj.Strings['cardtype'];
      Result.Data.Add(info);
    end;
  end;
  json.Free;
  parser.Free;
end;

class function TYGOData.searchCommon(akey: string; apage: integer): TSearchResult;
var
  Data: string;
  parsed: string;
begin
  Data := TYGORequest.search(akey, apage);
  parsed := string(parse(PChar(Data), 0));
  Exit(parseSearchResult(parsed));
end;

class function TYGOData.searchComplex(aname: string; ajapname: string; aenname: string; arace: string; aelement: string;
  aatk: string; adef: string; alevel: string; apendulum: string; alink: string; alinkarrow: string; acardtype: string;
  acardtype2: string; aeffect: string; apage: integer): TSearchResult;
var
  key: string = '';
begin
  if (aname <> '') then
    key += Format(' +(name:%s)', [aname]);
  if (ajapname <> '') then
    key += Format(' +(japName:%s)', [ajapname]);
  if (aenname <> '') then
    key += Format(' +(enName:%s)', [aenname]);
  if (arace <> '') then
    key += Format(' +(race:%s)', [arace]);
  if (aelement <> '') then
    key += Format(' +(element:%s)', [aelement]);
  if (aatk <> '') then
    key += Format(' +(atk:%s)', [aatk]);
  if (adef <> '') then
    key += Format(' +(def:%s)', [adef]);
  if (alevel <> '') then
    key += Format(' +(level:%s)', [alevel]);
  if (apendulum <> '') then
    key += Format(' +(pendulumL:%s)', [apendulum]);
  if (alink <> '') then
    key += Format(' +(link:%s)', [alink]);
  if (alinkarrow <> '') then
    key += Format(' +(linkArrow:%s)', [alinkarrow]);
  if (acardtype <> '') then
    key += Format(' +(cardType:%s)', [acardtype]);
  if (acardtype2 <> '') then
    key += Format(' +(cardType:%s)', [acardtype2]);
  if (aeffect <> '') then
    key += Format(' +(effect:%s)', [aeffect]);
  Exit(searchCommon(key, apage));
end;

class function TYGOData.cardDetail(hashid: string): TCardDetail;
var
  ahtml: string;
  parsed: string;
  adjust: string;
  wikiHtml: string;
  wiki: string;
  json: TJSONObject;
  jarr: TJSONArray;
  i: integer;
  parser: TJSONParser;
  obj: TJSONObject;
  pkinfo: TJSONObject;
  info: TCardPackInfo;
begin
  ahtml := TYGORequest.cardDetail(hashid);
  parsed := string(parse(PChar(ahtml), 1));
  adjust := string(parse(PChar(ahtml), 2));
  wikiHtml := TYGORequest.cardWiki(hashid);
  wiki := string(parse(PChar(wikiHtml), 3));

  parser := TJSONParser.Create(parsed, []);
  json := TJSONObject(parser.Parse);
  Result := TCardDetail.Create;
  if (json.Integers['result'] = 0) then
  begin
    obj := json.Objects['data'];
    Result.Name := obj.Strings['name'];
    Result.japname := obj.Strings['japname'];
    Result.enname := obj.Strings['enname'];
    Result.cardtype := obj.Strings['cardtype'];
    Result.password := obj.Strings['password'];
    Result.limit := obj.Strings['limit'];
    Result.belongs := obj.Strings['belongs'];
    Result.rare := obj.Strings['rare'];
    Result.pack := obj.Strings['pack'];
    Result.effect := obj.Strings['effect'];
    Result.race := obj.Strings['race'];
    Result.element := obj.Strings['element'];
    Result.level := obj.Strings['level'];
    Result.atk := obj.Strings['atk'];
    Result.def := obj.Strings['def'];
    Result.link := obj.Strings['link'];
    jarr := obj.Arrays['packs'];
    for i := 0 to jarr.Count -1  do begin
      pkinfo := jarr.Objects[i];
      info := TCardPackInfo.Create;
      info.url := pkinfo.Strings['url'];
      info.name := pkinfo.Strings['name'];
      info.date := pkinfo.Strings['date'];
      info.abbr := pkinfo.Strings['abbr'];
      info.rare := pkinfo.Strings['rare'];
      Result.packs.Add(info);
    end;
    Result.adjust:= adjust;
    Result.wiki:= wiki;
  end;
  json.Free;
  parser.Free;
end;

class function TYGOData.limit(): TLimitList;
var
  ahtml: string;
  parsed: string;
  json: TJSONObject;
  parser: TJSONParser;
  jarr: TJSONArray;
  i: Integer;
  obj: TJSONObject;
  info: TLimitInfo;
begin
  ahtml:= TYGORequest.limit();
  parsed:= string(parse(PChar(ahtml), 4));
  Result := TLimitList.Create;
  parser:= TJSONParser.Create(parsed, []);
  json := TJSONObject(parser.Parse);
  if (json.Integers['result'] = 0) then begin
    jarr := json.Arrays['data'];
    for i := 0 to jarr.Count - 1 do begin
      obj := jarr.Objects[i];
      info := TLimitInfo.Create;
      info.limit := obj.Integers['limit'];
      info.color := obj.Strings['color'];
      info.hashid := obj.Strings['hashid'];
      info.name := obj.Strings['name'];
      Result.Add(info);
    end;
  end;
  json.Free;
  parser.Free;
end;

class function TYGOData.packageList(): TPackageList;
var
  ahtml: string;
  parsed: string;
  json: TJSONObject;
  parser: TJSONParser;
  obj: TJSONObject;
  jarr: TJSONArray;
  i: Integer;
  info: TPackageInfo;
begin
  ahtml:= TYGORequest.packageList();
  parsed := string(parse(PChar(ahtml), 5));
  Result := TPackageList.Create;
  parser := TJSONParser.Create(parsed, []);
  json := TJSONObject(parser.Parse);
  if (json.Integers['result'] = 0) then begin
    jarr := json.Arrays['data'];
    for i := 0 to jarr.Count - 1 do begin
      obj := jarr.Objects[i];
      info := TPackageInfo.Create;
      info.season := obj.Strings['season'];
      info.url := obj.Strings['url'];
      info.name := obj.Strings['name'];
      info.abbr := obj.Strings['abbr'];
      Result.Add(info);
    end;
  end;
  json.Free;
  parser.Free;
end;

class function TYGOData.packageDetail(aurl: string): TSearchResult;
var
  ahtml: string;
  parsed: string;
begin
  ahtml := TYGORequest.packageDetail(aurl);
  parsed:= String(parse(PChar(ahtml), 0));
  Exit(parseSearchResult(parsed));
end;

class function TYGOData.hostest(): THotest;
var
  ahtml: string;
  parsed: string;
  json: TJSONObject;
  parser: TJSONParser;
  jarr: TJSONArray;
  obj: TJSONObject;
  i: Integer;
  infoCard: THotCard;
  infoPack: THotPack;
begin
  ahtml:= TYGORequest.hotest();
  parsed:= string(parse(PChar(ahtml), 6));
  parser := TJSONParser.Create(parsed, []);
  json := TJSONObject(parser.Parse);
  Result := THotest.Create;
  if (json.Integers['result'] = 0) then begin
    jarr := json.Arrays['search'];
    for i:= 0 to jarr.Count - 1 do begin
      Result.search.Add(jarr.Strings[i]);
    end;
    jarr := json.Arrays['card'];
    for i:= 0 to jarr.Count - 1 do begin
      obj := jarr.Objects[i];
      infoCard := THotCard.Create;
      infoCard.hashid:= obj.Strings['hashid'];
      infoCard.name:= obj.Strings['name'];
      Result.card.Add(infoCard);
    end;
    jarr := json.Arrays['pack'];
    for i := 0 to jarr.Count -1 do begin
      obj := jarr.Objects[i];
      infoPack := THotPack.Create;
      infoPack.packid:= obj.Strings['packid'];
      infoPack.name:= obj.Strings['name'];
      Result.pack.Add(infoPack);
    end;
  end;
  json.Free;
  parser.Free;
end;

{ TSearchResult }

constructor TSearchResult.Create;
begin
  Data := TCardInfoList.Create;
end;

destructor TSearchResult.Destroy;
var
  i: integer;
begin
  for i := Data.Count - 1 downto 0 do
    Data[i].Free;
  Data.Free;
  inherited Destroy;
end;

{ TCardDetail }

constructor TCardDetail.Create;
begin
  packs := TCardPackInfoList.Create;
end;

destructor TCardDetail.Destroy;
var
  i: integer;
begin
  for i := packs.Count - 1 downto 0 do
    packs[i].Free;
  packs.Free;
  inherited Destroy;
end;

end.

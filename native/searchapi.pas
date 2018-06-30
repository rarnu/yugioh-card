unit searchapi;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, jsonparser, fpjson, jsonscanner, android;

type

  { TSearchCard }

  TSearchCard = class
  public
    // key: keyword
    class function commonSearch(akey: string; apage: Integer): string;

    // name: card name
    // japname: japanese name
    // enname: english name
    // race: monster race/tribe
    // element: monster attribute
    // atk: monster atk, can be ranged
    // def: monster def, can be ranged
    // level: monster star/rank
    // pendulum: monster pendulum scale
    // link: monster link count, can be ranged
    // linkarrow: monster link arrows
    // cardtype: card type
    // cardtype2: card sub-type
    // effect: card effect
    // page: search page
    class function search(aname: string; ajapname: string; aenname: string; arace: string; aelement: string; aatk: string; adef: string; alevel: string; apendulum: string; alink: string; alinkarrow: string; acardtype: string; acardtype2: string; aeffect: string; apage: Integer): string;

    class function limit(): string;

    class function packageList(): string;

    // package: package code
    class function packageDetail(apackage: string): string;

    // cardid: card hash id
    class function cardDetail(acardid: string): string;

    // cardid: card hash id
    class function cardAdjust(acardid: string): string;

    // cardid: card hash id
    class function cardWiki(acardid: string): string;
  end;

implementation

uses
  htmlparser;

const
  BASE_URL = 'https://www.ourocg.cn';


{ TSearchCard }

class function TSearchCard.commonSearch(akey: string; apage: Integer): string;
var
  jsonstr: string = '';
  httpstr: string;
  u: string;
begin
  with TFPHTTPClient.Create(nil) do begin
    try
      u := BASE_URL + '/search/' + akey + '/' + apage.ToString();
      httpstr:= Get(u);
      LOGE('CALL6666');
      jsonstr := THtmlParser.getStoredJson(Get(u));
      LOGE('CALL77777');
    except
      on E: Exception do begin
        LOGE('Error: ' + E.Message);
      end;
    end;
    Free;
  end;
  LOGE('CALL88888');
  LOGE(jsonstr);
  Exit(TSearchResult.parseSearchResult(jsonstr));
end;

class function TSearchCard.search(aname: string; ajapname: string;
  aenname: string; arace: string; aelement: string; aatk: string; adef: string;
  alevel: string; apendulum: string; alink: string; alinkarrow: string;
  acardtype: string; acardtype2: string; aeffect: string; apage: Integer
  ): string;
var
  condition: string = '';
  jsonstr: string = '';
begin
  // build search condition
  if (aname <> '') then condition += Format(' +(name:%s)', [aname]);
  if (ajapname <> '') then condition += Format(' +(japName:%s)', [ajapname]);
  if (aenname <> '') then condition += Format(' +(enName:%s)', [aenname]);
  if (arace <> '') then condition += Format(' +(race:%s)', [arace]);
  if (aelement <> '') then condition += Format(' +(element:%s)', [aelement]);
  if (aatk <> '') then condition += Format(' +(atk:%s)', [aatk]);
  if (adef <> '') then condition += Format(' +(def:%s)', [adef]);
  if (alevel <> '') then condition += Format(' +(level:%s)', [alevel]);
  if (apendulum <> '') then condition += Format(' +(pendulumL:%s)', [apendulum]);
  if (alink <> '') then condition += Format(' +(link:%s)', [alink]);
  if (alinkarrow <> '') then condition += Format(' +(linkArrow:%s)', [alinkarrow]);
  if (acardtype <> '') then condition += Format(' +(cardType:%s)', [acardtype]);
  if (acardtype2 <> '') then condition += Format(' +(cardType:%s)', [acardtype2]);
  if (aeffect <> '') then condition += Format(' +(effect:%s)', [aeffect]);

  with TFPHTTPClient.Create(nil) do begin
    try
      jsonstr:= THtmlParser.getStoredJson(Get(BASE_URL + '/search/' + condition + '/' + apage.ToString));
    except
    end;
    Free;
  end;
  Exit(TSearchResult.parseSearchResult(jsonstr));
end;

class function TSearchCard.limit(): string;
var
  jsonstr: string = '';
begin
  with TFPHTTPClient.Create(nil) do begin
    try
      jsonstr:= THtmlParser.getLimitList(Get(BASE_URL + '/Limit-Latest'));
    except
    end;
    Free;
  end;
  Exit(jsonstr);
end;

class function TSearchCard.packageList(): string;
var
  jsonstr: string = '';
begin
  with TFPHTTPClient.Create(nil) do begin
    try
      jsonstr:= THtmlParser.getPackageList(Get(BASE_URL + '/package'));
    except
    end;
    Free;
  end;
  Exit(jsonstr);
end;

class function TSearchCard.packageDetail(apackage: string): string;
var
  jsonstr: string = '';
begin
  with TFPHTTPClient.Create(nil) do begin
    try
      jsonstr:= THtmlParser.getStoredJson(Get(BASE_URL + apackage));
    except
    end;
    Free;
  end;
  Exit(TSearchResult.parseSearchResult(jsonstr));
end;

class function TSearchCard.cardDetail(acardid: string): string;
var
  jsonstr: string;
begin
  with TFPHTTPClient.Create(nil) do begin
    try
      jsonstr:= THtmlParser.getArticle(Get(BASE_URL + '/card/' + acardid));
    except
    end;
    Free;
  end;
  Exit(jsonstr);
end;

class function TSearchCard.cardAdjust(acardid: string): string;
var
  jsonstr: string;
begin
  with TFPHTTPClient.Create(nil) do begin
    try
      jsonstr:= THtmlParser.getAdjust(Get(BASE_URL + '/card/' + acardid));
    except
    end;
    Free;
  end;
  Exit(jsonstr);
end;

class function TSearchCard.cardWiki(acardid: string): string;
var
  jsonstr: string;
begin
  with TFPHTTPClient.Create(nil) do begin
    try
      jsonstr:= THtmlParser.getWiki(Get(BASE_URL + '/card/' + acardid + '/wiki'));
    except
    end;
    Free;
  end;
  Exit(jsonstr);
end;

end.


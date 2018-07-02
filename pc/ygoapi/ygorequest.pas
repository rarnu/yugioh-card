unit ygorequest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient;

type

  { TYGORequest }

  TYGORequest = class
  private
    class function request(aurl: string): string;
  public
    class function search(akey: string; apage: Integer): string;
    class function cardDetail(ahashid: string): string;
    class function cardWiki(ahashid: string): string;
    class function limit(): string;
    class function packageList(): string;
    class function packageDetail(aurl: string): string;
    class function hotest(): string;
  end;

implementation

const
  BASE_URL = 'https://www.ourocg.cn';

{ TYGORequest }

class function TYGORequest.request(aurl: string): string;
var
  ret: string = '';
begin
  with TFPHTTPClient.Create(nil) do begin
    try
      ret := Get(aurl);
    except
    end;
    Free;
  end;
  Exit(ret);
end;

class function TYGORequest.search(akey: string; apage: Integer): string;
var
  urlstr: string;
begin
  urlstr:= BASE_URL + Format('/search/%s/%d', [akey, apage]);
  Exit(request(urlstr));
end;

class function TYGORequest.cardDetail(ahashid: string): string;
var
  urlstr: string;
begin
  urlstr:= BASE_URL + Format('/card/%s', [ahashid]);
  Exit(request(urlstr));
end;

class function TYGORequest.cardWiki(ahashid: string): string;
var
  urlstr: string;
begin
  urlstr := BASE_URL + Format('/card/%s/wiki', [ahashid]);
  Exit(request(urlstr));
end;

class function TYGORequest.limit(): string;
var
  urlstr: string;
begin
  urlstr:= BASE_URL + '/Limit-Latest';
  Exit(request(urlstr));
end;

class function TYGORequest.packageList(): string;
var
  urlstr: string;
begin
  urlstr:= BASE_URL + '/package';
  Exit(request(urlstr));
end;

class function TYGORequest.packageDetail(aurl: string): string;
var
  urlstr: string;
begin
  urlstr:= BASE_URL + aurl;
  Exit(request(urlstr));
end;

class function TYGORequest.hotest(): string;
begin
  Exit(request(BASE_URL));
end;

end.


unit updater;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, jsonparser, fpjson, jsonscanner, LCLIntf;

const
  VERSIONCODE = 2;
  UPDATE_URL = 'https://github.com/rarnu/yugioh-card/raw/master/update/update.json';

type

  { TUpdater }

  TUpdater = class(TThread)
  private
    FJsonStr: string;
    procedure onThreadTerminated(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create();
    class procedure checkUpdate();
  end;

implementation

uses
  dlgConfirm;

{ TUpdater }

procedure TUpdater.onThreadTerminated(Sender: TObject);
var
  parser: TJSONParser;
  json: TJSONObject;
  jobj: TJSONObject;
begin
  try
    parser := TJSONParser.Create(FJsonStr, [joUTF8]);
    json := TJSONObject(parser.Parse);
    jobj := json.Objects[{$IFDEF WINDOWS}'windows'{$ELSE}{$IFDEF DARWIN}'macosx'{$ELSE}'linux'{$ENDIF}{$ENDIF}];
    if (jobj.Integers['code'] > VERSIONCODE) then begin
      showUpdate(jobj.Strings['url']);
    end;
    json.Free;
    parser.Free;
  except
  end;
end;

procedure TUpdater.Execute;
begin
  with TFPHTTPClient.Create(nil) do begin
    try
      AllowRedirect:= True;
      FJsonStr:= Get(UPDATE_URL);
    except
      on e: Exception do begin
        WriteLn(e.Message);
      end;
    end;
    Free;
  end;
end;

constructor TUpdater.Create();
begin
  inherited Create(True);
  FreeOnTerminate:= True;
  OnTerminate:=@onThreadTerminated;
end;

class procedure TUpdater.checkUpdate();
begin
  with TUpdater.Create() do Start;
end;

end.


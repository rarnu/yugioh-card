unit threads;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ygodata, orca_scene2d, FileUtil, fphttpclient;

type

  TSearchCallback = procedure (Sender: TObject; AData: TSearchResult) of object;

  { TSearchCommonThread }

  TSearchCommonThread = class(TThread)
  private
    FCallback: TSearchCallback;
    FKey: string;
    FPage: Integer;
    FResult: TSearchResult;
    procedure onThreadTerminated(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create(akey: string; apage: Integer; acallback: TSearchCallback);
    class procedure threadSearchCommon(akey: string; apage: Integer; acallback: TSearchCallback);
  end;

  { TDownloadImageThread }

  TDownloadImageThread = class(TThread)
  private
    FImgContainer: TD2Image;
    FCardId: Integer;
    FImgPath: string;
    procedure onThreadTerminated(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create(acardid: Integer; acontainer: TD2Image);
  end;

  TCardDetailCallback = procedure(Sender: TObject; ACard: TCardDetail) of object;

  { TCardDetailThread }

  TCardDetailThread = class(TThread)
  private
    FHashId: string;
    FCardDetail: TCardDetail;
    FCallback: TCardDetailCallback;
    procedure onThreadTerminated(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create(AHashId: string; ACallback: TCardDetailCallback);
    class procedure threadCardDetail(AHashId: string; ACallback: TCardDetailCallback);
  end;

implementation

{ TCardDetailThread }

procedure TCardDetailThread.onThreadTerminated(Sender: TObject);
begin
  if (Assigned(FCallback)) then begin
    FCallback(Self, FCardDetail);
  end;
end;

procedure TCardDetailThread.Execute;
begin
  FCardDetail := TYGOData.cardDetail(FHashId);
end;

constructor TCardDetailThread.Create(AHashId: string;
  ACallback: TCardDetailCallback);
begin
  inherited Create(True);
  FHashId:= AHashId;
  FCallback:= ACallback;
  FreeOnTerminate:= True;
  OnTerminate:=@onThreadTerminated;
end;

class procedure TCardDetailThread.threadCardDetail(AHashId: string;
  ACallback: TCardDetailCallback);
begin
  with TCardDetailThread.Create(AHashId, ACallback) do Start;
end;

{ TDownloadImageThread }

procedure TDownloadImageThread.onThreadTerminated(Sender: TObject);
begin
  // show image
  if (FileExists(FImgPath)) then begin
    FImgContainer.WrapMode:= TD2ImageWrap.d2ImageFit;
    FImgContainer.Bitmap.LoadFromFile(FImgPath);
  end;
end;

procedure TDownloadImageThread.Execute;
const
  IMG_URL = 'http://ocg.resource.m2v.cn/%s.jpg';
begin
  // download image if not exists
  FImgPath:= ExtractFilePath(ParamStr(0)) + 'CardImage';
  if (not DirectoryExists(FImgPath)) then begin
    ForceDirectories(FImgPath);
  end;
  FImgPath += DirectorySeparator + FCardId.ToString;
  if (not FileExists(FImgPath)) then begin
    with TFPHTTPClient.Create(nil) do begin
      try
        Get(Format(IMG_URL, [FCardId.ToString]), FImgPath);
      except
        on E: Exception do begin
          WriteLn(E.Message);
          DeleteFile(FImgPath);
        end;

      end;
      Free;
    end;
  end;
end;

constructor TDownloadImageThread.Create(acardid: Integer; acontainer: TD2Image);
begin
  inherited Create(False);
  FCardId:= acardid;
  FImgContainer := acontainer;
  FreeOnTerminate:= True;
  OnTerminate:=@onThreadTerminated;
end;

{ TSearchCommonThread }

procedure TSearchCommonThread.onThreadTerminated(Sender: TObject);
begin
  if (Assigned(FCallback)) then begin
    FCallback(Self, FResult);
  end;
end;

procedure TSearchCommonThread.Execute;
begin
  FResult := TYGOData.searchCommon(FKey, FPage);
end;

constructor TSearchCommonThread.Create(akey: string; apage: Integer;
  acallback: TSearchCallback);
begin
  inherited Create(True);
  FKey:= akey;
  FPage:= apage;
  FCallback:= acallback;
  FreeOnTerminate:= True;
  OnTerminate:=@onThreadTerminated;
end;

class procedure TSearchCommonThread.threadSearchCommon(akey: string;
  apage: Integer; acallback: TSearchCallback);
begin
  with TSearchCommonThread.Create(akey, apage, acallback) do Start;
end;

end.


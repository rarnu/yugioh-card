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

  TLimitCallback = procedure (Sender: TObject; ALimit: TLimitList) of object;

  { TLimitThread }

  TLimitThread = class(TThread)
  private
    FCallback: TLimitCallback;
    FList: TLimitList;
    procedure onThreadTerminated(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create(ACallback: TLimitCallback);
    class procedure threadLimit(ACallback: TLimitCallback);
  end;

  TPackCallback = procedure (Sender: TObject; APack: TPackageList) of object;

  { TPackThread }

  TPackThread = class(TThread)
  private
    FCallback: TPackCallback;
    FList: TPackageList;
    procedure onThreadTerminated(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create(ACallback: TPackCallback);
    class procedure threadPack(ACallback: TPackCallback);
  end;

  { TPackDetailThread }

  TPackDetailThread = class(TThread)
  private
    FUrl: string;
    FCallback: TSearchCallback;
    FList: TSearchResult;
    procedure onThreadTerminated(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create(AUrl: string; ACallback: TSearchCallback);
    class procedure threadPackDetail(AUrl: string; ACallback: TSearchCallback);
  end;


  THotestCallback = procedure(Sender: TObject; AData: THotest) of object;

  { THotestThread }

  THotestThread = class(TThread)
  private
    FHotest: THotest;
    FCallback: THotestCallback;
    procedure onThreadTerminated(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create(ACallback: THotestCallback);
    class procedure threadHotest(ACallback: THotestCallback);
  end;

implementation

{ THotestThread }

procedure THotestThread.onThreadTerminated(Sender: TObject);
begin
  if Assigned(FCallback) then begin
    FCallback(Self, FHotest);
  end;
end;

procedure THotestThread.Execute;
begin
  FHotest := TYGOData.hostest();
end;

constructor THotestThread.Create(ACallback: THotestCallback);
begin
  inherited Create(True);
  FCallback:= ACallback;
  FreeOnTerminate:= True;
  OnTerminate:=@onThreadTerminated;
end;

class procedure THotestThread.threadHotest(ACallback: THotestCallback);
begin
  with THotestThread.Create(ACallback) do Start;
end;

{ TPackDetailThread }

procedure TPackDetailThread.onThreadTerminated(Sender: TObject);
begin
  if Assigned(FCallback) then begin
    FCallback(Self, FList);
  end;
end;

procedure TPackDetailThread.Execute;
begin
  FList := TYGOData.packageDetail(FUrl);
end;

constructor TPackDetailThread.Create(AUrl: string; ACallback: TSearchCallback);
begin
  inherited Create(True);
  FUrl:= AUrl;
  FCallback:= ACallback;
  FreeOnTerminate:= True;
  OnTerminate:=@onThreadTerminated;
end;

class procedure TPackDetailThread.threadPackDetail(AUrl: string;
  ACallback: TSearchCallback);
begin
  with TPackDetailThread.Create(AUrl, ACallback) do Start;
end;

{ TPackThread }

procedure TPackThread.onThreadTerminated(Sender: TObject);
begin
  if Assigned(FCallback) then begin
    FCallback(Self, FList);
  end;
end;

procedure TPackThread.Execute;
begin
  FList := TYGOData.packageList();
end;

constructor TPackThread.Create(ACallback: TPackCallback);
begin
  inherited Create(True);
  FCallback:= ACallback;
  FreeOnTerminate:= True;
  OnTerminate:=@onThreadTerminated;
end;

class procedure TPackThread.threadPack(ACallback: TPackCallback);
begin
  with TPackThread.Create(ACallback) do Start;
end;

{ TLimitThread }

procedure TLimitThread.onThreadTerminated(Sender: TObject);
begin
  if (Assigned(FCallback)) then begin
    FCallback(Self, FList);
  end;
end;

procedure TLimitThread.Execute;
begin
  FList := TYGOData.limit();
end;

constructor TLimitThread.Create(ACallback: TLimitCallback);
begin
  inherited Create(True);
  FCallback:= ACallback;
  FreeOnTerminate:= True;
  OnTerminate:=@onThreadTerminated;
end;

class procedure TLimitThread.threadLimit(ACallback: TLimitCallback);
begin
  with TLimitThread.Create(ACallback) do Start;
end;

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
  IMG_URL = 'http://ocg.resource.m2v.cn/%d.jpg';
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
        Get(Format(IMG_URL, [FCardId]), FImgPath);
      except
        on E: Exception do begin
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


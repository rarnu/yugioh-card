unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmBase, orca_scene2d, ygodata;

type

  { TFormMain }

  TFormMain = class(TFormBase)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLayTop: TD2Layout;
    FEdtSearch: TD2HudTextBox;
    FBtnSearch: TD2HudCornerButton;
    FBtnAdvSearch: TD2HudCornerButton;

    FLayCenter: TD2Layout;
    FLayCards: TD2Layout;
    FLayRight: TD2Layout;
    FLvCard: TD2HudListBox;
    FLayPage: TD2Layout;
    FBtnFirst: TD2HudButton;
    FBtnPrior: TD2HudButton;
    FBtnNext: TD2HudButton;
    FBtnLast: TD2HudButton;
    FTVPage: TD2Text;

    FLayLimitPack: TD2Layout;
    FBtnHotest: TD2HudCornerButton;
    FBtnLimit: TD2HudCornerButton;
    FBtnPack: TD2HudCornerButton;
    FBtnRefreshHotest: TD2HudButton;
    FBtnRefreshLimit: TD2HudButton;
    FBtnRefreshPack: TD2HudButton;

    FlayLimit: TD2Layout;
    FLayPack: TD2Layout;
    FLayHotest: TD2Layout;

    FLvLimit: TD2HudListBox;
    FLvSeason: TD2HudListBox;
    FLvPack: TD2HudListBox;

    // data
    FCurrentPage: Integer;
    FPageCount: Integer;
    FKey: string;

    FSeasonList: TStringList;
    FPackList: TPackageList;
    FOriginPackList: TPackageList;

    procedure loadSeason();
    procedure loadPack();

    procedure onBtnAdvSearchClicked(Sender: TObject);
    procedure onBtnFirstClicked(Sender: TObject);
    procedure onBtnHotestClicked(Sender: TObject);
    procedure onBtnLastClicked(Sender: TObject);
    procedure onBtnLimitClicked(Sender: TObject);
    procedure onBtnNextClicked(Sender: TObject);
    procedure onBtnPackClicked(Sender: TObject);
    procedure onBtnPriorClicked(Sender: TObject);
    procedure onBtnRefreshHotestClicked(Sender: TObject);
    procedure onBtnRefreshLimitClicked(Sender: TObject);
    procedure onBtnRefreshPackClicked(Sender: TObject);
    procedure onBtnSearchClicked(Sender: TObject);
    procedure onHotestCallback(Sender: TObject; AData: THotest);
    procedure onLimitCallback(Sender: TObject; ALimit: TLimitList);
    procedure onLvCardClicked(Sender: TObject);
    procedure onLvLimitClicked(Sender: TObject);
    procedure onLvPackClicked(Sender: TObject);
    procedure onLvSeasonClicked(Sender: TObject);
    procedure onPackCallback(Sender: TObject; APack: TPackageList);
    procedure onPackDetailCallback(Sender: TObject; AData: TSearchResult);
    procedure onSearchCallback(Sender: TObject; AData: TSearchResult);
  public

  end;

var
  FormMain: TFormMain;

implementation

uses
  toaster, threads, cardlistitem, frmCardDetail, frmSearch;

{$R *.frm}

{ TFormMain }

procedure TFormMain.FormCreate(Sender: TObject);
begin
  inherited;

  Window.Text:= 'YuGiOh Card';
  // data
  FCurrentPage := 1;
  FPageCount:= 1;
  FKey:= '';

  FSeasonList:= TStringList.Create;
  FPackList:= TPackageList.Create;
  FOriginPackList := TPackageList.Create;

    // ui
  Width:= 800;
  Height:= 600;

  FLayTop := TD2Layout.Create(Root);
  FLayTop.Align:= vaTop;
  FLayTop.Height:= 40;
  FLayTop.Padding.Top:= 8;
  FLayTop.Padding.Left:= 8;
  FLayTop.Padding.Right:= 8;
  Root.AddObject(FLayTop);

  FBtnAdvSearch := TD2HudCornerButton.Create(FLayTop);
  FBtnAdvSearch.Align:= vaMostRight;
  FBtnAdvSearch.Width:= 80;
  FBtnAdvSearch.Corners:= [d2CornerTopRight, d2CornerBottomRight];
  FBtnAdvSearch.Text:= '高级搜索';
  FLayTop.AddObject(FBtnAdvSearch);

  FBtnSearch := TD2HudCornerButton.Create(FLayTop);
  FBtnSearch.Align:= vaRight;
  FBtnSearch.Width:= 60;
  FBtnSearch.Corners:= [d2CornerTopLeft, d2CornerBottomLeft];
  FBtnSearch.Padding.Left:= 8;
  FBtnSearch.Text:= '搜索';
  FLayTop.AddObject(FBtnSearch);

  FEdtSearch := TD2HudTextBox.Create(FLayTop);
  FEdtSearch.Align:= vaClient;
  FLayTop.AddObject(FEdtSearch);

  FLayCenter := TD2Layout.Create(Root);
  FLayCenter.Align:= vaClient;
  FLayCenter.Padding.Top:= 8;
  FLayCenter.Padding.Left:= 8;
  FLayCenter.Padding.Right:= 8;
  FLayCenter.Padding.Bottom:= 8;
  Root.AddObject(FLayCenter);

  FLayRight := TD2Layout.Create(FLayCenter);
  FLayRight.Align:= vaRight;
  FLayRight.Width:= Width * 0.4;
  FLayCenter.AddObject(FLayRight);

  FLayCards := TD2Layout.Create(FLayCenter);
  FLayCards.Align:= vaClient;
  FLayCards.Padding.Right:= 8;
  FLayCenter.AddObject(FLayCards);

  FLvCard := TD2HudListBox.Create(FLayCards);
  FLvCard.Align:= vaClient;
  FLvCard.UseSmallScrollBars:= True;
  FLayCards.AddObject(FLvCard);

  FLayPage:= TD2Layout.Create(FLayCards);
  FLayPage.Align:= vaBottom;
  FLayPage.Height:= 40;
  FLayPage.Padding.Top:= 8;
  FLayCards.AddObject(FLayPage);

  FBtnFirst := TD2HudButton.Create(FLayPage);
  FBtnFirst.Align:= vaMostLeft;
  FBtnFirst.Text:= '<<';
  FBtnFirst.Width:= 60;
  FLayPage.AddObject(FBtnFirst);

  FBtnPrior := TD2HudButton.Create(FLayPage);
  FBtnPrior.Align:= vaLeft;
  FBtnPrior.Text:= '<';
  FBtnPrior.Width:= 60;
  FBtnPrior.Padding.Left:= 8;
  FLayPage.AddObject(FBtnPrior);

  FBtnNext := TD2HudButton.Create(FLayPage);
  FBtnNext.Align:= vaRight;
  FBtnNext.Text:= '>';
  FBtnNext.Width:= 60;
  FBtnNext.Padding.Right:= 8;
  FLayPage.AddObject(FBtnNext);

  FBtnLast := TD2HudButton.Create(FLayPage);
  FBtnLast.Align:= vaMostRight;
  FBtnLast.Text:= '>>';
  FBtnLast.Width:= 60;
  FLayPage.AddObject(FBtnLast);

  FTVPage := TD2Text.Create(FLayPage);
  FTVPage.Align:= vaClient;
  FTVPage.Fill.Color:= vcWhite;
  FTVPage.HorzTextAlign:= TD2TextAlign.d2TextAlignCenter;
  FTVPage.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  FTVPage.Padding.Left:= 8;
  FTVPage.Padding.Right:= 8;
  FLayPage.AddObject(FTVPage);

  FLayLimitPack:= TD2Layout.Create(FLayRight);
  FLayLimitPack.Align:= vaMostTop;
  FLayLimitPack.Height:= 120;
  FLayRight.AddObject(FLayLimitPack);

  FBtnHotest := TD2HudCornerButton.Create(FLayLimitPack);
  FBtnHotest.Align:= vaTop;
  FBtnHotest.Height:=40;
  FBtnHotest.Text:= '最新最热';
  FBtnHotest.Corners:= [d2CornerTopLeft, d2CornerTopRight];
  FLayLimitPack.AddObject(FBtnHotest);

  FBtnLimit := TD2HudCornerButton.Create(FLayLimitPack);
  FBtnLimit.Align:= vaClient;
  FBtnLimit.Height:= 40;
  FBtnLimit.Text:= '禁止限制卡表';
  FBtnLimit.Corners:= [];
  FLayLimitPack.AddObject(FBtnLimit);

  FBtnPack := TD2HudCornerButton.Create(FLayLimitPack);
  FBtnPack.Align:= vaBottom;
  FBtnPack.Height:= 40;
  FBtnPack.Text:= '卡包列表';
  FBtnPack.Corners:= [d2CornerBottomLeft, d2CornerBottomRight];
  FLayLimitPack.AddObject(FBtnPack);

  FBtnRefreshHotest:= TD2HudButton.Create(FBtnHotest);
  FBtnRefreshHotest.Align:= vaRight;
  FBtnRefreshHotest.Padding.Right:= 4;
  FBtnRefreshHotest.Padding.Top:= 4;
  FBtnRefreshHotest.Padding.Bottom:= 4;
  FBtnRefreshHotest.Width:= 40;
  FBtnRefreshHotest.Text:= '刷新';
  FBtnHotest.AddObject(FBtnRefreshHotest);

  FBtnRefreshLimit:= TD2HudButton.Create(FBtnLimit);
  FBtnRefreshLimit.Align:= vaRight;
  FBtnRefreshLimit.Padding.Right:= 4;
  FBtnRefreshLimit.Padding.Top:= 4;
  FBtnRefreshLimit.Padding.Bottom:= 4;
  FBtnRefreshLimit.Width:= 40;
  FBtnRefreshLimit.Text:= '刷新';
  FBtnLimit.AddObject(FBtnRefreshLimit);

  FBtnRefreshPack:= TD2HudButton.Create(FBtnPack);
  FBtnRefreshPack.Align:= vaRight;
  FBtnRefreshPack.Padding.Right:= 4;
  FBtnRefreshPack.Padding.Top:= 4;
  FBtnRefreshPack.Padding.Bottom:= 4;
  FBtnRefreshPack.Width:= 40;
  FBtnRefreshPack.Text:= '刷新';
  FBtnPack.AddObject(FBtnRefreshPack);

  FlayLimit:= TD2Layout.Create(FLayRight);
  FlayLimit.Align:= vaClient;
  FlayLimit.Visible:= False;
  FLayRight.AddObject(FlayLimit);
  FLayPack:= TD2Layout.Create(FLayRight);
  FLayPack.Align:= vaClient;
  FLayPack.Visible:= False;
  FLayRight.AddObject(FLayPack);
  FLayHotest:= TD2Layout.Create(FLayRight);
  FLayHotest.Align:= vaClient;
  FLayHotest.Visible:= True;
  FLayRight.AddObject(FLayHotest);

  FLvLimit:= TD2HudListBox.Create(FlayLimit);
  FLvLimit.Align:= vaClient;
  FLvLimit.UseSmallScrollBars:= True;
  FlayLimit.AddObject(FLvLimit);

  FLvSeason:= TD2HudListBox.Create(FLayPack);
  FLvSeason.Align:= vaLeft;
  FLvSeason.Width:= 80;
  FLvSeason.UseSmallScrollBars:= True;
  FLayPack.AddObject(FLvSeason);

  FLvPack:= TD2HudListBox.Create(FLayPack);
  FLvPack.Align:= vaClient;
  FLvPack.UseSmallScrollBars:= True;
  FLayPack.AddObject(FLvPack);

  // events
  FBtnSearch.OnClick:=@onBtnSearchClicked;
  FBtnAdvSearch.OnClick:=@onBtnAdvSearchClicked;
  FBtnFirst.OnClick:=@onBtnFirstClicked;
  FBtnPrior.OnClick:=@onBtnPriorClicked;
  FBtnNext.OnClick:=@onBtnNextClicked;
  FBtnLast.OnClick:=@onBtnLastClicked;
  FLvCard.OnClick:=@onLvCardClicked;
  FBtnHotest.OnClick:=@onBtnHotestClicked;
  FBtnLimit.OnClick:=@onBtnLimitClicked;
  FBtnPack.OnClick:=@onBtnPackClicked;
  FLvLimit.OnClick:=@onLvLimitClicked;
  FLvSeason.OnClick:=@onLvSeasonClicked;
  FLvPack.OnClick:=@onLvPackClicked;
  FBtnRefreshPack.OnClick:=@onBtnRefreshPackClicked;
  FBtnRefreshLimit.OnClick:=@onBtnRefreshLimitClicked;
  FBtnRefreshHotest.OnClick:=@onBtnRefreshHotestClicked;

  // data
  TLimitThread.threadLimit(@onLimitCallback);
  TPackThread.threadPack(@onPackCallback);
  THotestThread.threadHotest(@onHotestCallback);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FSeasonList.Free;
  FPackList.Free;
  FOriginPackList.Free;
end;

procedure TFormMain.loadSeason();
var
  i: Integer;
  item: TSeasonListItem;
begin
  FLvSeason.Clear;
  for i := 0 to FSeasonList.Count - 1 do begin
    item := TSeasonListItem.Create(FLvSeason);
    item.SeasonName:= FSeasonList[i];
    FLvSeason.AddObject(item);
  end;
end;

procedure TFormMain.loadPack();
var
  i: Integer;
  item: TPackListItem;
begin
  // load pack
  FLvPack.Clear;
  for i := 0 to FPackList.Count - 1 do begin
    item := TPackListItem.Create(FLvPack);
    item.PackName:= FPackList[i].name;
    item.Url:= FPackList[i].url;
    FLvPack.AddObject(item);
  end;
end;

procedure TFormMain.onBtnSearchClicked(Sender: TObject);
var
  key: string;
begin
  key := FEdtSearch.Text.Trim;
  if (key = '') then begin
    TToast.show(FLayCenter, '不能搜索空关键字');
    Exit;
  end;
  FKey:= key;
  TSearchCommonThread.threadSearchCommon(FKey, 1, @onSearchCallback);

end;

procedure TFormMain.onHotestCallback(Sender: TObject; AData: THotest);
begin
  // TODO: hotest callback
end;

procedure TFormMain.onLimitCallback(Sender: TObject; ALimit: TLimitList);
var
  item: TLimitListItem;
  i: Integer;
begin
  FLvLimit.Clear;
  if (ALimit = nil) then Exit;
  for i := 0 to ALimit.Count - 1 do begin
    item := TLimitListItem.Create(FLvLimit);
    item.Color:= ALimit[i].color;
    item.LimitName:= ALimit[i].name;
    item.Limit:= ALimit[i].limit;
    item.HashId:= ALimit[i].hashid;
    FLvLimit.AddObject(item);
  end;
  ALimit.Free;
end;

procedure TFormMain.onLvCardClicked(Sender: TObject);
var
  item: TCardListItem;
begin
  item := TCardListItem(FLvCard.Selected);
  if (item = nil) then Exit;
  with TFormCardDetail.Create(nil) do begin
    CardName:= item.CardName;
    HashId:= item.HashId;
    ShowModal;
    Free;
  end;
end;

procedure TFormMain.onLvLimitClicked(Sender: TObject);
var
  item: TLimitListItem;
begin
  item := TLimitListItem(FLvLimit.Selected);
  if (item = nil) then Exit;
  with TFormCardDetail.Create(nil) do begin
    CardName:= item.LimitName;
    HashId:= item.HashId;
    ShowModal;
    Free;
  end;
end;

procedure TFormMain.onLvPackClicked(Sender: TObject);
var
  item: TPackListItem;
begin
  item := TPackListItem(FLvPack.Selected);
  if (item = nil) then Exit;
  TPackDetailThread.threadPackDetail(item.Url, @onPackDetailCallback);
end;

procedure TFormMain.onLvSeasonClicked(Sender: TObject);
var
  season: string;
  item: TSeasonListItem;
  p: TPackageInfo;
  i: Integer;
begin
  item := TSeasonListItem(FLvSeason.Selected);
  if (item = nil) then Exit;
  for i:= 0 to FLvSeason.Count -1 do begin
    TSeasonListItem(FLvSeason.Items[i]).IsSelected:= FLvSeason.Items[i] = item
  end;
  season:= item.SeasonName;
  FPackList.Clear;
  for p in FOriginPackList do begin
    if (p.season = season) then FPackList.Add(p);
  end;
  loadPack();
end;

procedure TFormMain.onPackCallback(Sender: TObject; APack: TPackageList);
var
  lastSeason: string  = '';
  p: TPackageInfo;
begin
  // packs
  FOriginPackList.Clear;
  FSeasonList.Clear;
  FPackList.Clear;
  if (APack = nil) then Exit;

  FOriginPackList.AddList(APack);
  for p in FOriginPackList do begin
    if (lastSeason = '') then lastSeason:= p.season;
    if (FSeasonList.IndexOf(p.season) = -1) then FSeasonList.Add(p.season);
    if (p.season = lastSeason) then FPackList.Add(p);
  end;
  loadSeason();
  loadPack();
  if (FLvSeason.Count > 0) then begin
    TSeasonListItem(FLvSeason.Items[0]).IsSelected:= True;
  end;
  APack.Free;
end;

procedure TFormMain.onPackDetailCallback(Sender: TObject; AData: TSearchResult);
begin
  onSearchCallback(Sender, AData)
end;

procedure TFormMain.onBtnFirstClicked(Sender: TObject);
begin
  if (FCurrentPage <> 1) then begin
    FCurrentPage:= 1;
    TSearchCommonThread.threadSearchCommon(FKey, FCurrentPage, @onSearchCallback);
  end;
end;

procedure TFormMain.onBtnHotestClicked(Sender: TObject);
begin
  // hotest
  FLayHotest.Visible:= True;
  FlayLimit.Visible:= False;
  FLayPack.Visible:= False;
end;

procedure TFormMain.onBtnAdvSearchClicked(Sender: TObject);
begin
  // adv search
  with TFormSearch.Create(nil) do begin
    if (ShowModal = mrOK) then begin
      FKey:= Key;
      TSearchCommonThread.threadSearchCommon(FKey, 1, @onSearchCallback);
    end;
    Free;
  end;
end;

procedure TFormMain.onBtnLastClicked(Sender: TObject);
begin
  if (FCurrentPage <> FPageCount) then begin
    FCurrentPage:= FPageCount;
    TSearchCommonThread.threadSearchCommon(FKey, FCurrentPage, @onSearchCallback);
  end;
end;

procedure TFormMain.onBtnLimitClicked(Sender: TObject);
begin
  // limit
  FlayLimit.Visible:= True;
  FLayHotest.Visible:= False;
  FLayPack.Visible:= False;
end;

procedure TFormMain.onBtnNextClicked(Sender: TObject);
begin
  if (FCurrentPage < FPageCount) then begin
    FCurrentPage += 1;
    TSearchCommonThread.threadSearchCommon(FKey, FCurrentPage, @onSearchCallback);
  end;
end;

procedure TFormMain.onBtnPackClicked(Sender: TObject);
begin
  // pack
  FLayPack.Visible:= True;
  FlayLimit.Visible:= False;
  FLayHotest.Visible:= False;
end;

procedure TFormMain.onBtnPriorClicked(Sender: TObject);
begin
  if (FCurrentPage > 1) then begin
    FCurrentPage -= 1;
    TSearchCommonThread.threadSearchCommon(FKey, FCurrentPage, @onSearchCallback);
  end;
end;

procedure TFormMain.onBtnRefreshHotestClicked(Sender: TObject);
begin
  THotestThread.threadHotest(@onHotestCallback);
end;

procedure TFormMain.onBtnRefreshLimitClicked(Sender: TObject);
begin
  TLimitThread.threadLimit(@onLimitCallback);
end;

procedure TFormMain.onBtnRefreshPackClicked(Sender: TObject);
begin
  TPackThread.threadPack(@onPackCallback);
end;

procedure TFormMain.onSearchCallback(Sender: TObject; AData: TSearchResult);
var
  i: Integer;
  item: TCardListItem;
begin
  FCurrentPage:= AData.page;
  FPageCount:= AData.pageCount;
  FTVPage.Text:= Format('%d / %d', [FCurrentPage, FPageCount]);
  FLvCard.Clear;
  for i := 0 to AData.Data.Count - 1 do begin
    item := TCardListItem.Create(FLvCard);
    item.CardName:= AData.Data[i].name;
    item.CardJapName:= AData.Data[i].japname;
    item.CardEnName:= AData.Data[i].enname;
    item.CardType:= AData.Data[i].cardtype;
    item.CardId:= AData.Data[i].cardid;
    item.HashId:= AData.Data[i].hashid;
    FLvCard.AddObject(item);
  end;
  AData.Free;
end;

end.


unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmBase, orca_scene2d, ygodata;

type

  { TFormMain }

  TFormMain = class(TFormBase)
    procedure FormCreate(Sender: TObject);
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
    FBtnLimit: TD2HudCornerButton;
    FBtnPack: TD2HudCornerButton;

    // data
    FCurrentPage: Integer;
    FPageCount: Integer;
    FType: Integer;
    FKey: string;

    procedure onBtnAdvSearchClicked(Sender: TObject);
    procedure onBtnFirstClicked(Sender: TObject);
    procedure onBtnLastClicked(Sender: TObject);
    procedure onBtnLimitClicked(Sender: TObject);
    procedure onBtnNextClicked(Sender: TObject);
    procedure onBtnPackClicked(Sender: TObject);
    procedure onBtnPriorClicked(Sender: TObject);
    procedure onBtnSearchClicked(Sender: TObject);
    procedure onLvCardClicked(Sender: TObject);
    procedure onSearchCallback(Sender: TObject; AData: TSearchResult);
  public

  end;

var
  FormMain: TFormMain;

implementation

uses
  toaster, threads, cardlistitem, frmCardDetail;

{$R *.frm}

{ TFormMain }

procedure TFormMain.FormCreate(Sender: TObject);
begin
  inherited;

  Window.Text:= 'YuGiOh Card';
  // data
  FCurrentPage := 1;
  FPageCount:= 1;
  FType:= 0;
  FKey:= '';

    // ui
  Width:= Trunc(Screen.Width * 0.7);
  Height:= TRunc(Screen.Height * 0.7);

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
  FLayRight.Width:= Width * 0.2;
  FLayCenter.AddObject(FLayRight);

  FLayCards := TD2Layout.Create(FLayCenter);
  FLayCards.Align:= vaClient;
  FLayCards.Padding.Right:= 8;
  FLayCenter.AddObject(FLayCards);

  FLvCard := TD2HudListBox.Create(FLayCards);
  FLvCard.Align:= vaClient;
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
  FLayLimitPack.Height:= 80;
  FLayRight.AddObject(FLayLimitPack);

  FBtnLimit := TD2HudCornerButton.Create(FLayLimitPack);
  FBtnLimit.Align:= vaMostTop;
  FBtnLimit.Height:= 40;
  FBtnLimit.Text:= '禁止限制卡表';
  FBtnLimit.Corners:= [d2CornerTopLeft, d2CornerTopRight];
  FLayLimitPack.AddObject(FBtnLimit);

  FBtnPack := TD2HudCornerButton.Create(FLayLimitPack);
  FBtnPack.Align:= vaTop;
  FBtnPack.Height:= 40;
  FBtnPack.Text:= '卡包列表';
  FBtnPack.Corners:= [d2CornerBottomLeft, d2CornerBottomRight];
  FLayLimitPack.AddObject(FBtnPack);

  // events
  FBtnSearch.OnClick:=@onBtnSearchClicked;
  FBtnAdvSearch.OnClick:=@onBtnAdvSearchClicked;
  FBtnFirst.OnClick:=@onBtnFirstClicked;
  FBtnPrior.OnClick:=@onBtnPriorClicked;
  FBtnNext.OnClick:=@onBtnNextClicked;
  FBtnLast.OnClick:=@onBtnLastClicked;
  FLvCard.OnClick:=@onLvCardClicked;
  FBtnLimit.OnClick:=@onBtnLimitClicked;
  FBtnPack.OnClick:=@onBtnPackClicked;

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

  FType:= 0;
  FKey:= key;

  TSearchCommonThread.threadSearchCommon(FKey, 1, @onSearchCallback);

end;

procedure TFormMain.onLvCardClicked(Sender: TObject);
var
  item: TCardListItem;
begin
  item := TCardListItem(FLvCard.Selected);
  if (item = nil) then Exit;
  with TFormCardDetail.Create(nil) do begin
    CardName:= item.CardName;
    CardId:= item.CardId;
    HashId:= item.HashId;
    ShowModal;
    Free;
  end;
end;

procedure TFormMain.onBtnFirstClicked(Sender: TObject);
begin
  if (FCurrentPage <> 1) then begin
    FCurrentPage:= 1;
    TSearchCommonThread.threadSearchCommon(FKey, FCurrentPage, @onSearchCallback);
  end;
end;

procedure TFormMain.onBtnAdvSearchClicked(Sender: TObject);
begin
  // TODO: adv search
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
  // TODO: limit
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
  // TODO: pack
end;

procedure TFormMain.onBtnPriorClicked(Sender: TObject);
begin
  if (FCurrentPage > 1) then begin
    FCurrentPage -= 1;
    TSearchCommonThread.threadSearchCommon(FKey, FCurrentPage, @onSearchCallback);
  end;
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


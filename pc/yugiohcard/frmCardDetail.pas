unit frmCardDetail;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmBase, orca_scene2d, ygodata;

type

  { TFormCardDetail }

  TFormCardDetail = class(TFormBase)
    procedure FormCreate(Sender: TObject);
  private
    // UI
    FTabInfo: TD2HudCornerButton;
    FTabPubPack: TD2HudCornerButton;
    FTabAdjust: TD2HudCornerButton;
    FTabWiki: TD2HudCornerButton;

    FLayInfo: TD2Layout;
    FLayAddition: TD2Layout;
    FLayWiki: TD2Layout;

    // info
    FlblCardNameValue: TD2Text;
    FlblCardJapNameValue: TD2Text;
    FlblCardEnNameValue: TD2Text;
    FlblCardTypeValue: TD2Text;
    FlblPasswordValue: TD2Text;
    FlblLimitValue: TD2Text;
    FlblRareValue: TD2Text;
    FlblPackValue: TD2Text;
    FlblEffectValue: TD2Text;

    // pubpack

    // adjust

    // wiki

    // Data
    FCardId: Integer;
    FCardName: string;
    FHashId: string;
    procedure onCardDetailCallback(Sender: TObject; ACard: TCardDetail);
    procedure SetCardName(AValue: string);
    procedure SetHashId(AValue: string);
    function makeText(x, y, w, h: Integer; txt: String; container: TD2VisualObject): TD2Text;
  public

  published
    property CardName: string read FCardName write SetCardName;
    property HashId: string read FHashId write SetHashId;
    property CardId: Integer read FCardId write FCardId;
  end;

var
  FormCardDetail: TFormCardDetail;

implementation

uses
  threads;

{$R *.frm}

{ TFormCardDetail }

procedure TFormCardDetail.FormCreate(Sender: TObject);
var
  FLayTab: TD2Layout;
  valueWidth: Integer =  260;
begin
  inherited;

  Width:= 400;
  Height:= 500;

  FLayTab := TD2Layout.Create(Root);
  FLayTab.Align:= vaTop;
  FLayTab.Height:= 40;
  FLayTab.Padding.Top:= 8;
  FLayTab.Padding.Left:= 8;
  FLayTab.Padding.Right:= 8;
  FLayTab.Padding.Bottom:= 8;
  Root.AddObject(FLayTab);

  FTabInfo:= TD2HudCornerButton.Create(FLayTab);
  FTabInfo.Text:= '卡片信息';
  FTabInfo.Align:= vaLeft;
  FTabInfo.Width:= 75;
  FTabInfo.Position.X:= 0;
  FTabInfo.Corners:= [d2CornerTopLeft, d2CornerBottomLeft];
  FLayTab.AddObject(FTabInfo);

  FTabPubPack := TD2HudCornerButton.Create(FLayTab);
  FTabPubPack.Text:= '发布卡包';
  FTabPubPack.Align:= vaLeft;
  FTabPubPack.Width:= 75;
  FTabPubPack.Position.X:= 76;
  FTabPubPack.Corners:= [];
  FLayTab.AddObject(FTabPubPack);

  FTabAdjust:= TD2HudCornerButton.Create(FLayTab);
  FTabAdjust.Text:= '事务局调整';
  FTabAdjust.Align:= vaLeft;
  FTabAdjust.Width:= 75;
  FTabAdjust.Position.X:= 151;
  FTabAdjust.Corners:= [];
  FLayTab.AddObject(FTabAdjust);

  FTabWiki:= TD2HudCornerButton.Create(FLayTab);
  FTabWiki.Text:= 'Wiki';
  FTabWiki.Align:= vaLeft;
  FTabWiki.Width:= 75;
  FTabWiki.Position.X:= 226;
  FTabWiki.Corners:= [d2CornerTopRight, d2CornerBottomRight];
  FLayTab.AddObject(FTabWiki);

  FLayInfo:= TD2Layout.Create(Root);
  FLayInfo.Align:= vaClient;
  FLayInfo.Visible:= True;
  FLayInfo.Padding.Left:= 8;
  FLayInfo.Padding.Right:= 8;
  FLayInfo.Padding.Bottom:= 8;
  Root.AddObject(FLayInfo);

  FLayPubPack := TD2Layout.Create(Root);
  FLayPubPack.Align:= vaClient;
  FLayPubPack.Visible:= False;
  FLayPubPack.Padding.Left:= 8;
  FLayPubPack.Padding.Right:= 8;
  FLayPubPack.Padding.Bottom:= 8;
  Root.AddObject(FLayPubPack);

  FLayAdjust:= TD2Layout.Create(Root);
  FLayAdjust.Align:= vaClient;
  FLayAdjust.Visible:= False;
  FLayAdjust.Padding.Left:= 8;
  FLayAdjust.Padding.Right:= 8;
  FLayAdjust.Padding.Bottom:= 8;
  Root.AddObject(FLayAdjust);

  FLayWiki:= TD2Layout.Create(Root);
  FLayWiki.Align:= vaClient;
  FLayWiki.Visible:= False;
  FLayWiki.Padding.Left:= 8;
  FLayWiki.Padding.Right:= 8;
  FLayWiki.Padding.Bottom:= 8;
  Root.AddObject(FLayWiki);

  // info
  makeText(0, 0, 80, 32, '中文名称:', FLayInfo);
  FlblCardNameValue:= makeText(88, 0, valueWidth, 32, '', FLayInfo);
  makeText(0, 32, 80, 32, '日文名称:', FLayInfo);
  FlblCardJapNameValue := makeText(88,32, valueWidth, 32, '', FLayInfo);
  makeText(0, 64, 80, 32, '英文名称:', FLayInfo);
  FlblCardEnNameValue := makeText(88, 64, valueWidth, 32, '', FLayInfo);
  makeText(0, 96, 80, 32, '卡片种类:', FLayInfo);
  FlblCardTypeValue:= makeText(88, 96, valueWidth, 32, '', FLayInfo);
  makeText(0, 128, 80,32, '卡片密码:', FLayInfo);
  FlblPasswordValue:= makeText(88, 128, valueWidth, 32, '', FLayInfo);
  makeText(0, 160, 80,32, '使用限制:', FLayInfo);
  FlblLimitValue:= makeText(88, 160, valueWidth, 32, '', FLayInfo);
  makeText(0, 192, 80, 32, '罕贵度:', FLayInfo);
  FlblRareValue:= makeText(88, 192, valueWidth, 32, '', FLayInfo);
  makeText(0, 224, 80, 32, '所在卡包:', FLayInfo);
  FlblPackValue:= makeText(88, 224, valueWidth, 32, '', FLayInfo);
  makeText(0, 256, 80, 32, '效果:', FLayInfo);
  FlblEffectValue:= makeText(88, 262, valueWidth, 160, '', FLayInfo);
  FlblEffectValue.VertTextAlign:= TD2TextAlign.d2TextAlignNear;
  FlblEffectValue.WordWrap:= True;

  // pubpack

  // adjust

  // wiki

end;

procedure TFormCardDetail.SetCardName(AValue: string);
begin
  FCardName:=AValue;
  Window.Text:= FCardName;
end;

procedure TFormCardDetail.onCardDetailCallback(Sender: TObject;
  ACard: TCardDetail);
begin
  FlblCardNameValue.Text:= ACard.name;
  FlblCardJapNameValue.Text:= ACard.japname;
  FlblCardEnNameValue.Text:= ACard.enname;
  FlblCardTypeValue.Text:= ACard.cardtype;
  FlblPasswordValue.Text:= ACard.password;
  FlblLimitValue.Text:= ACard.limit;
  FlblRareValue.Text:= ACard.rare;
  FlblPackValue.Text:= ACard.pack;
  FlblEffectValue.Text:= ACard.effect;
  ACard.Free;
end;

procedure TFormCardDetail.SetHashId(AValue: string);
begin
  FHashId:=AValue;
  // TODO: load card data
  TCardDetailThread.threadCardDetail(FHashId, @onCardDetailCallback);
end;

function TFormCardDetail.makeText(x, y, w, h: Integer; txt: String;
  container: TD2VisualObject): TD2Text;
begin
  Result := TD2Text.Create(container);
  Result.Position.X:= x;
  Result.Position.Y:= y;
  Result.Width:= w;
  Result.Height:= h;
  Result.Text:= txt;
  Result.Fill.Color:= vcWhite;
  Result.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  Result.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  container.AddObject(Result);
end;

end.


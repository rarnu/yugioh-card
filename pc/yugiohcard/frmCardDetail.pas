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
    FSvInfo: TD2ScrollBox;
    FLayWiki: TD2Layout;
    FSvWiki: TD2ScrollBox;

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
    FlblMonRace: TD2Text;
    FlblMonElement: TD2Text;
    FlblMonLevel: TD2Text;
    FlblMonAtk: TD2Text;
    FlblMonDef: TD2Text;
    FlblMonLink: TD2Text;
    FlblMonLinkArrow: TD2Text;
    FlblAdjust: TD2Text;
    FivCardImg: TD2Image;

    // wiki

    // Data
    FCardId: Integer;
    FCardName: string;
    FHashId: string;
    procedure onCardDetailCallback(Sender: TObject; ACard: TCardDetail);
    procedure SetCardName(AValue: string);
    procedure SetHashId(AValue: string);
    function getTextHeight(txt: string): Single;
    function makeText(txt: String; idx: Integer; multiline: Boolean = False; content: string = ''): TD2Text;
    procedure makeLine(idx: Integer);
    function makeImage(idx: Integer): TD2Image;
    function makeAdjust(idx: Integer; content: string): TD2Text;
    procedure loadImage();
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

  FSvInfo := TD2ScrollBox.Create(FLayInfo);
  FSvInfo.Align:= vaClient;
  FSvInfo.UseSmallScrollBars:= True;
  FLayInfo.AddObject(FSvInfo);

  FLayWiki:= TD2Layout.Create(Root);
  FLayWiki.Align:= vaClient;
  FLayWiki.Visible:= False;
  FLayWiki.Padding.Left:= 8;
  FLayWiki.Padding.Right:= 8;
  FLayWiki.Padding.Bottom:= 8;
  Root.AddObject(FLayWiki);

  FSvWiki := TD2ScrollBox.Create(FLayWiki);
  FSvWiki.Align := vaClient;
  FLayWiki.AddObject(FSvWiki);

  // info
  FlblCardNameValue:= makeText('中文名称:', 0);
  FlblCardJapNameValue := makeText('日文名称:', 1);
  FlblCardEnNameValue := makeText('英文名称:', 2);
  FlblCardTypeValue:= makeText('卡片种类:', 3);
  FlblPasswordValue:= makeText('卡片密码:', 4);
  FlblLimitValue:= makeText('使用限制:', 5);
  FlblRareValue:= makeText('罕贵度:', 6);
  FlblPackValue:= makeText('所在卡包:', 7);

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

  if (ACard.cardtype.Contains('怪兽')) then begin
    FlblMonRace := makeText('怪兽种族:', 8);
    FlblMonRace.Text:= ACard.race;
    FlblMonElement:= makeText('怪兽属性:', 9);
    FlblMonElement.Text:= ACard.element;
    if (ACard.cardtype.Contains('连接')) then begin
      FlblMonAtk := makeText('攻击力:', 10);
      FlblMonAtk.Text:= ACard.atk;
      FlblMonLink := makeText('连接数:', 11);
      FlblMonLink.Text:= ACard.link;
      FlblMonLinkArrow := makeText('连接方向:', 12);
      FlblMonLinkArrow.Text:= ACard.linkArrow;
    end else begin
        if (ACard.cardtype.Contains('XYZ')) then begin
          FlblMonLevel := makeText('怪兽阶级:', 10);
        end else begin
          FlblMonLevel := makeText('怪兽星级:', 10);
        end;
        FlblMonLevel.Text:= ACard.level;
        FlblMonAtk := makeText('攻击力:', 11);
        FlblMonAtk.Text:= ACard.atk;
        FlblMonDef := makeText('守备力:', 12);
        FlblMonDef.Text:= ACard.def;
    end;
  end;
  FlblEffectValue := makeText('效果:', 13, True, ACard.effect);
  makeLine(14);
  FivCardImg := makeImage(15);
  loadImage();
  makeLine(16);
  FlblAdjust := makeAdjust(17, ACard.adjust);

  if (FSvInfo.HScrollBar <> nil) then begin
    FSvInfo.HScrollBar.Visible:= False;
  end;
  ACard.Free;
end;

procedure TFormCardDetail.SetHashId(AValue: string);
begin
  FHashId:=AValue;
  // load card data
  TCardDetailThread.threadCardDetail(FHashId, @onCardDetailCallback);
end;

function TFormCardDetail.getTextHeight(txt: string): Single;
var
  t: TD2Text;
  r: TD2Rect;
  c: TD2Canvas;
begin
  t := TD2Text.Create(Root);
  c := D2Canvas;
  c.Font.Assign(t.Font);
  r:= d2Rect(0,0,200,1000);
  c.MeasureText(r, r, WideString(txt), True, d2TextAlignNear, d2TextAlignNear);
  t.Free;
  Result := r.Bottom;
end;

function TFormCardDetail.makeText(txt: String; idx: Integer;
  multiline: Boolean; content: string): TD2Text;
var
  lay: TD2Layout;
  lbl: TD2Text;
begin
  lay := TD2Layout.Create(FSvInfo);
  lay.Align:= vaTop;
  lay.Padding.Right:= 20;
  lay.Position.Y:= idx * 200;
  lay.Height:= 24;
  lbl := TD2Text.Create(lay);
  lbl.Align:= vaLeft;
  lbl.Width:= 80;
  lbl.Fill.Color:= vcWhite;
  lbl.Text:= txt;
  lbl.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  lbl.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  lay.AddObject(lbl);
  Result := TD2Text.Create(lay);
  Result.Align:= vaClient;
  if (multiline) then begin
    lay.Padding.Top:= 8;
    lbl.VertTextAlign:= TD2TextAlign.d2TextAlignNear;
    Result.VertTextAlign:= TD2TextAlign.d2TextAlignNear;
    Result.WordWrap:= True;
    Result.AutoSize:= True;
    lay.Height:= getTextHeight(content) + 8;
    Result.Text:= content;
  end else begin
    Result.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  end;
  Result.Fill.Color:= vcWhite;
  Result.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  lay.AddObject(Result);
  FSvInfo.AddObject(lay);
end;

procedure TFormCardDetail.makeLine(idx: Integer);
var
  line: TD2Line;
begin
  line := TD2Line.Create(FSvInfo);
  line.Stroke.Color:= vcDarkgray;
  line.LineType:= TD2LineType.d2LineHorizontal;
  line.Align:= vaTop;
  line.Height:= 1;
  line.Padding.Top:= 8;
  line.Padding.Bottom:= 8;
  line.Position.Y:= idx * 200;
  FSvInfo.AddObject(line);
end;

function TFormCardDetail.makeImage(idx: Integer): TD2Image;
var
  lay: TD2Layout;
begin
  lay := TD2Layout.Create(FSvInfo);
  lay.Align:= vaTop;
  lay.Padding.Right:= 20;
  lay.Position.Y:= idx * 200;
  lay.Height:= 230;
  Result := TD2Image.Create(lay);
  Result.Width:= 160;
  Result.Height:= 230;
  Result.Align:= vaCenter;
  Result.WrapMode:= TD2ImageWrap.d2ImageFit;
  lay.AddObject(Result);
  FSvInfo.AddObject(lay);
end;

function TFormCardDetail.makeAdjust(idx: Integer; content: string): TD2Text;
begin
  Result := TD2Text.Create(FSvInfo);
  Result.Align:= vaTop;
  Result.Padding.Right:= 20;
  Result.Position.Y:= idx * 200;
  Result.VertTextAlign:= TD2TextAlign.d2TextAlignNear;
  Result.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  Result.WordWrap:= True;
  Result.AutoSize:= True;
  Result.Fill.Color:= vcWhite;
  Result.Text:= content;
  FSvInfo.AddObject(Result);
end;

procedure TFormCardDetail.loadImage();
begin
  TDownloadImageThread.Create(FCardId, FivCardImg);
end;

end.


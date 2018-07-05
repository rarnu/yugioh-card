unit cardlistitem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, orca_scene2d;

type

  { TCardListItem }

  TCardListItem = class(TD2ListBoxItem)
  private
    FCardEnName: string;
    FCardId: Integer;
    FCardJapName: string;
    FCardName: string;
    FCardType: string;
    FHashId: string;

    FlblName: TD2Text;
    FlblJapName: TD2Text;
    FlblEnName: TD2Text;
    FlblType: TD2Text;
    FimgCardImg: TD2Image;
    procedure SetCardEnName(AValue: string);
    procedure SetCardId(AValue: Integer);
    procedure SetCardJapName(AValue: string);
    procedure SetCardName(AValue: string);
    procedure SetCardType(AValue: string);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property CardName: string read FCardName write SetCardName;
    property CardJapName: string read FCardJapName write SetCardJapName;
    property CardEnName: string read FCardEnName write SetCardEnName;
    property CardId: Integer read FCardId write SetCardId;
    property HashId: string read FHashId write FHashId;
    property CardType: string read FCardType write SetCardType;
  end;

implementation

uses
  threads;

{ TCardListItem }

procedure TCardListItem.SetCardEnName(AValue: string);
begin
  FCardEnName:=AValue;
  FlblEnName.Text:= Format('英文名称: %s', [FCardEnName]);
end;

procedure TCardListItem.SetCardId(AValue: Integer);
begin
  FCardId:=AValue;
  TDownloadImageThread.Create(FCardId, FimgCardImg);
end;

procedure TCardListItem.SetCardJapName(AValue: string);
begin
  FCardJapName:=AValue;
  FlblJapName.Text:= Format('日文名称: %s', [FCardJapName]);
end;

procedure TCardListItem.SetCardName(AValue: string);
begin
  FCardName:=AValue;
  FlblName.Text:= Format('中文名称: %s', [FCardName]);
end;

procedure TCardListItem.SetCardType(AValue: string);
begin
  FCardType:=AValue;
  FlblType.Text:= FCardType;
end;

constructor TCardListItem.Create(AOwner: TComponent);
var
  FLayLeft: TD2Layout;
  FLine: TD2Line;
begin
  inherited Create(AOwner);
  Height:= 100;

  FimgCardImg := TD2Image.Create(Self);
  FimgCardImg.HitTest:= False;
  FimgCardImg.Align:= vaRight;
  FimgCardImg.Padding.Right:= 8;
  FimgCardImg.Padding.Top:= 4;
  FimgCardImg.Padding.Bottom:= 4;
  self.AddObject(FimgCardImg);

  FLayLeft := TD2Layout.Create(Self);
  FLayLeft.HitTest:= False;
  FLayLeft.Align:= vaClient;
  FLayLeft.Padding.Left:= 8;
  FLayLeft.Padding.Right:= 8;
  FLayLeft.Padding.Bottom:= 1;
  self.AddObject(FLayLeft);

  FlblName:= TD2Text.Create(FLayLeft);
  FlblName.HitTest:= False;
  FlblName.Align:= vaMostTop;
  FlblName.Height:= 25;
  FlblName.Fill.Color:= vcWhite;
  FlblName.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  FlblName.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FLayLeft.AddObject(FlblName);

  FlblJapName:= TD2Text.Create(FLayLeft);
  FlblJapName.HitTest:= False;
  FlblJapName.Align:= vaTop;
  FlblJapName.Height:= 25;
  FlblJapName.Fill.Color:= vcWhite;
  FlblJapName.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  FlblJapName.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FLayLeft.AddObject(FlblJapName);

  FlblEnName:= TD2Text.Create(FLayLeft);
  FlblEnName.HitTest:= False;
  FlblEnName.Align:= vaBottom;
  FlblEnName.Height:= 25;
  FlblEnName.Fill.Color:= vcWhite;
  FlblEnName.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  FlblEnName.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FLayLeft.AddObject(FlblEnName);

  FlblType:= TD2Text.Create(FLayLeft);
  FlblType.HitTest:= False;
  FlblType.Align:= vaMostBottom;
  FlblType.Height:= 25;
  FlblType.Fill.Color:= vcWhite;
  FlblType.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  FlblType.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FLayLeft.AddObject(FlblType);

  FLine := TD2Line.Create(Self);
  FLine.Align:= vaMostBottom;
  FLine.Height:= 1;
  FLine.LineType:= d2LineHorizontal;
  FLine.Stroke.Color:= vcDarkgray;
  self.AddObject(FLine);

end;

end.


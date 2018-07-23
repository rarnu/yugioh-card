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
    FCardId: integer;
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
    procedure SetCardId(AValue: integer);
    procedure SetCardJapName(AValue: string);
    procedure SetCardName(AValue: string);
    procedure SetCardType(AValue: string);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property CardName: string read FCardName write SetCardName;
    property CardJapName: string read FCardJapName write SetCardJapName;
    property CardEnName: string read FCardEnName write SetCardEnName;
    property CardId: integer read FCardId write SetCardId;
    property HashId: string read FHashId write FHashId;
    property CardType: string read FCardType write SetCardType;
  end;

  { TLimitListItem }

  TLimitListItem = class(TD2ListBoxItem)
  private
    FColor: string;
    FHashId: string;
    FImgColor: TD2Rectangle;
    FlblName: TD2Text;
    FlblLimit: TD2Text;
    FLimit: integer;
    FLimitName: string;
    procedure SetColor(AValue: string);
    procedure SetLimit(AValue: integer);
    procedure SetLimitName(AValue: string);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property HashId: string read FHashId write FHashId;
    property Color: string read FColor write SetColor;
    property LimitName: string read FLimitName write SetLimitName;
    property Limit: integer read FLimit write SetLimit;
  end;

  { TSeasonListItem }

  TSeasonListItem = class(TD2ListBoxItem)
  private
    FIsSelected: Boolean;
    FlblName: TD2Text;
    FSeasonName: string;
    procedure SetIsSelected(AValue: Boolean);
    procedure SetSeasonName(AValue: string);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property SeasonName: string read FSeasonName write SetSeasonName;
    property IsSelected: Boolean read FIsSelected write SetIsSelected;
  end;

  { TPackListItem }

  TPackListItem = class(TD2ListBoxItem)
  private
    FlblName: TD2Text;
    FPackName: string;
    FUrl: string;
    procedure SetPackName(AValue: string);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property PackName: string read FPackName write SetPackName;
    property Url: string read FUrl write FUrl;
  end;

implementation

uses
  threads;

{ TPackListItem }

procedure TPackListItem.SetPackName(AValue: string);
begin
  FPackName:=AValue;
  FlblName.Text:= FPackName;
end;

constructor TPackListItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height:= 40;
  FlblName := TD2Text.Create(Self);
  FlblName.HitTest:= False;
  FlblName.Align:= vaClient;
  FlblName.Padding.Left:= 8;
  FlblName.Padding.Right:= 8;
  FlblName.Fill.Color:= vcWhite;
  FlblName.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  FlblName.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  self.AddObject(FlblName);
end;

{ TSeasonListItem }

procedure TSeasonListItem.SetSeasonName(AValue: string);
begin
  FSeasonName:=AValue;
  FlblName.Text:= FSeasonName;
end;

procedure TSeasonListItem.SetIsSelected(AValue: Boolean);
begin
  FIsSelected:=AValue;
  if (FIsSelected) then FlblName.Fill.Color:= vcLightblue else FlblName.Fill.Color:= vcWhite;
end;

constructor TSeasonListItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height:= 40;
  FlblName := TD2Text.Create(Self);
  FlblName.HitTest:= False;
  FlblName.Align:= vaClient;
  FlblName.Padding.Left:= 8;
  FlblName.Padding.Right:= 8;
  FlblName.Fill.Color:= vcWhite;
  FlblName.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  FlblName.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  self.AddObject(FlblName);
end;

{ TLimitListItem }

procedure TLimitListItem.SetColor(AValue: string);
begin
  FColor := AValue.Replace('#', '#FF');
  FImgColor.Fill.Color := FColor;
end;

procedure TLimitListItem.SetLimit(AValue: integer);
begin
  FLimit := AValue;
  case FLimit of
    0:
    begin
      FlblLimit.Text := '禁止';
      FlblLimit.Fill.Color:= vcRed;
    end;
    1:
    begin
      FlblLimit.Text := '限制';
      FlblLimit.Fill.Color:= vcOrange;
    end;
    2:
    begin
      FlblLimit.Text := '准限制';
      FlblLimit.Fill.Color:= vcGreen;
    end;
  end;
end;

procedure TLimitListItem.SetLimitName(AValue: string);
begin
  FLimitName := AValue;
  FlblName.Text := FLimitName;
end;

constructor TLimitListItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 40;

  FImgColor := TD2Rectangle.Create(Self);
  FImgColor.Align := vaMostLeft;
  FImgColor.Padding.Left := 8;
  FImgColor.Padding.Top := 4;
  FImgColor.Padding.Bottom := 4;
  FImgColor.Width := 22;
  FImgColor.HitTest:= False;
  self.AddObject(FImgColor);

  FlblName := TD2Text.Create(Self);
  FlblName.Align := vaClient;
  FlblName.Padding.Left := 8;
  FlblName.Padding.Right := 8;
  FlblName.VertTextAlign := TD2TextAlign.d2TextAlignCenter;
  FlblName.HorzTextAlign := TD2TextAlign.d2TextAlignNear;
  FlblName.Fill.Color:= vcWhite;
  FlblName.HitTest:= False;
  self.AddObject(FlblName);

  FlblLimit := TD2Text.Create(Self);
  FlblLimit.Align := vaMostRight;
  FlblLimit.Padding.Right := 8;
  FlblLimit.Width := 72;
  FlblLimit.VertTextAlign := TD2TextAlign.d2TextAlignCenter;
  FlblLimit.HorzTextAlign := TD2TextAlign.d2TextAlignFar;
  FlblLimit.HitTest:= False;
  self.AddObject(FlblLimit);

end;

{ TCardListItem }

procedure TCardListItem.SetCardEnName(AValue: string);
begin
  FCardEnName := AValue;
  FlblEnName.Text := Format('英文名称: %s', [FCardEnName]);
end;

procedure TCardListItem.SetCardId(AValue: integer);
begin
  FCardId := AValue;
  TDownloadImageThread.download(FCardId, FimgCardImg);
end;

procedure TCardListItem.SetCardJapName(AValue: string);
begin
  FCardJapName := AValue;
  FlblJapName.Text := Format('日文名称: %s', [FCardJapName]);
end;

procedure TCardListItem.SetCardName(AValue: string);
begin
  FCardName := AValue;
  FlblName.Text := Format('中文名称: %s', [FCardName]);
end;

procedure TCardListItem.SetCardType(AValue: string);
begin
  FCardType := AValue;
  FlblType.Text := FCardType;
end;

constructor TCardListItem.Create(AOwner: TComponent);
var
  FLayLeft: TD2Layout;
  FLine: TD2Line;
begin
  inherited Create(AOwner);
  Height := 100;

  FimgCardImg := TD2Image.Create(Self);
  FimgCardImg.HitTest := False;
  FimgCardImg.Align := vaRight;
  FimgCardImg.Padding.Right := 8;
  FimgCardImg.Padding.Top := 4;
  FimgCardImg.Padding.Bottom := 4;
  self.AddObject(FimgCardImg);

  FLayLeft := TD2Layout.Create(Self);
  FLayLeft.HitTest := False;
  FLayLeft.Align := vaClient;
  FLayLeft.Padding.Left := 8;
  FLayLeft.Padding.Right := 8;
  FLayLeft.Padding.Bottom := 1;
  self.AddObject(FLayLeft);

  FlblName := TD2Text.Create(FLayLeft);
  FlblName.HitTest := False;
  FlblName.Align := vaMostTop;
  FlblName.Height := 25;
  FlblName.Fill.Color := vcWhite;
  FlblName.VertTextAlign := TD2TextAlign.d2TextAlignCenter;
  FlblName.HorzTextAlign := TD2TextAlign.d2TextAlignNear;
  FLayLeft.AddObject(FlblName);

  FlblJapName := TD2Text.Create(FLayLeft);
  FlblJapName.HitTest := False;
  FlblJapName.Align := vaTop;
  FlblJapName.Height := 25;
  FlblJapName.Fill.Color := vcWhite;
  FlblJapName.VertTextAlign := TD2TextAlign.d2TextAlignCenter;
  FlblJapName.HorzTextAlign := TD2TextAlign.d2TextAlignNear;
  FLayLeft.AddObject(FlblJapName);

  FlblEnName := TD2Text.Create(FLayLeft);
  FlblEnName.HitTest := False;
  FlblEnName.Align := vaBottom;
  FlblEnName.Height := 25;
  FlblEnName.Fill.Color := vcWhite;
  FlblEnName.VertTextAlign := TD2TextAlign.d2TextAlignCenter;
  FlblEnName.HorzTextAlign := TD2TextAlign.d2TextAlignNear;
  FLayLeft.AddObject(FlblEnName);

  FlblType := TD2Text.Create(FLayLeft);
  FlblType.HitTest := False;
  FlblType.Align := vaMostBottom;
  FlblType.Height := 25;
  FlblType.Fill.Color := vcWhite;
  FlblType.VertTextAlign := TD2TextAlign.d2TextAlignCenter;
  FlblType.HorzTextAlign := TD2TextAlign.d2TextAlignNear;
  FLayLeft.AddObject(FlblType);

  FLine := TD2Line.Create(Self);
  FLine.Align := vaMostBottom;
  FLine.Height := 1;
  FLine.LineType := d2LineHorizontal;
  FLine.Stroke.Color := vcDarkgray;
  self.AddObject(FLine);

end;

end.

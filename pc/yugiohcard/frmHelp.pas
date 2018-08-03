unit frmHelp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmBase, orca_scene2d, LCLIntf;

type

  { TFormHelp }

  TFormHelp = class(TFormBase)
    procedure FormCreate(Sender: TObject);
  private
    FBtnUpdate: TD2HudCornerButton;
    FIcon: TD2Image;
    FTitle: TD2Text;
    FVersion: TD2Text;
    FLine: TD2Line;
    FlblAuthor: TD2Text;
    FlblOurocg: TD2Text;
    FlblRarnu: TD2Text;
    FLine2: TD2Line;
    procedure onBtnAuthorClicked(Sender: TObject);
    procedure onBtnOurocgClicked(Sender: TObject);
    procedure onBtnRarnuClicked(Sender: TObject);
    procedure onBtnUpdateClicked(Sender: TObject);

    procedure openUrl(aurl: string);
  public

  end;

var
  FormHelp: TFormHelp;

implementation

uses
  updater, dlgConfirm;

{$R *.frm}

{ TFormHelp }

procedure TFormHelp.FormCreate(Sender: TObject);
begin
  inherited;
  Window.Text:= '帮助';
  Width:= 330;
  Height:= 230;

  FBtnUpdate := TD2HudCornerButton.Create(Window);
  FBtnUpdate.Width:= 50;
  FBtnUpdate.Height:= 20;
  FBtnUpdate.Position.X:= 260;
  FBtnUpdate.Position.Y:= 6;
  FBtnUpdate.Text:= '升级';
  Window.AddObject(FBtnUpdate);

  // help
  FIcon:= TD2Image.Create(Root);
  FIcon.Position.X:= 8;
  FIcon.Position.Y:= 8;
  FIcon.Width:= 48;
  FIcon.Height:= 48;
  FIcon.WrapMode:= TD2ImageWrap.d2ImageFit;
  Root.AddObject(FIcon);

  FTitle:= TD2Text.Create(Root);
  FTitle.Position.X:= 64;
  FTitle.Position.Y:= 8;
  FTitle.Width:= 200;
  FTitle.Height:= 24;
  FTitle.Fill.Color:= vcWhite;
  FTitle.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FTitle.Text:= 'YuGiOh Card';
  Root.AddObject(FTitle);

  FVersion:= TD2Text.Create(Root);
  FVersion.Position.X:= 64;
  FVersion.Position.Y:= 32;
  FVersion.Width:= 200;
  FVersion.Height:= 24;
  FVersion.Fill.Color:= vcWhite;
  FVersion.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FVersion.Text:= '5.0.0';
  Root.AddObject(FVersion);

  FLine:= TD2Line.Create(Root);
  FLine.LineType:= TD2LineType.d2LineHorizontal;
  FLine.Position.X:= 8;
  FLine.Position.Y:= 64;
  FLine.Width:= 280;
  FLine.Height:= 1;
  FLine.Stroke.Color:= vcLightgray;
  Root.AddObject(FLine);

  FlblAuthor := TD2Text.Create(Root);
  FlblAuthor.Position.X:= 8;
  FlblAuthor.Position.Y:= 72;
  FlblAuthor.Width:= 280;
  FlblAuthor.Height:= 32;
  FlblAuthor.Fill.Color:= vcSkyblue;
  FlblAuthor.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FlblAuthor.Text:= '软件作者: rarnu';
  Root.AddObject(FlblAuthor);

  FlblOurocg:= TD2Text.Create(Root);
  FlblOurocg.Position.X:= 8;
  FlblOurocg.Position.Y:= 104;
  FlblOurocg.Width:= 280;
  FlblOurocg.Height:= 32;
  FlblOurocg.Fill.Color:= vcSkyblue;
  FlblOurocg.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FlblOurocg.Text:= '数据来源: 中国OCG工作室';
  Root.AddObject(FlblOurocg);

  FlblRarnu:= TD2Text.Create(Root);
  FlblRarnu.Position.X:= 8;
  FlblRarnu.Position.Y:= 136;
  FlblRarnu.Width:= 280;
  FlblRarnu.Height:= 32;
  FlblRarnu.Fill.Color:= vcSkyblue;
  FlblRarnu.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FlblRarnu.Text:= '卡查开源: github.com/rarnu/yugioh-card';
  Root.AddObject(FlblRarnu);

  FLine2:= TD2Line.Create(Root);
  FLine2.Position.X:= 8;
  FLine2.Position.Y:= 168;
  FLine2.Width:= 280;
  FLine2.Height:= 1;
  FLine2.Stroke.Color:= vcLightgray;
  Root.AddObject(FLine2);

  // events
  FBtnUpdate.OnClick:=@onBtnUpdateClicked;
  FlblAuthor.OnClick:=@onBtnAuthorClicked;
  FlblOurocg.OnClick:=@onBtnOurocgClicked;
  FlblRarnu.OnClick:=@onBtnRarnuClicked;
end;

procedure TFormHelp.onBtnOurocgClicked(Sender: TObject);
begin
  openUrl('https://www.ourocg.cn');
end;

procedure TFormHelp.onBtnAuthorClicked(Sender: TObject);
begin
  openUrl('http://scarlett.vip/yugioh');
end;

procedure TFormHelp.onBtnRarnuClicked(Sender: TObject);
begin
  openUrl('https://github.com/rarnu/yugioh-card');
end;

procedure TFormHelp.onBtnUpdateClicked(Sender: TObject);
begin
  TUpdater.checkUpdate();
end;

procedure TFormHelp.openUrl(aurl: string);
begin
  LCLIntf.OpenURL(aurl);
end;

end.


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
    FlblOurocg: TD2Text;
    FlblRarnu: TD2Text;
    FlblThanks: TD2Text;
    procedure onBtnOurocgClicked(Sender: TObject);
    procedure onBtnRarnuClicked(Sender: TObject);
    procedure onBtnThanksClicked(Sender: TObject);
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

  FlblOurocg:= TD2Text.Create(Root);
  FlblOurocg.Position.X:= 8;
  FlblOurocg.Position.Y:= 72;
  FlblOurocg.Width:= 280;
  FlblOurocg.Height:= 32;
  FlblOurocg.Fill.Color:= vcSkyblue;
  FlblOurocg.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FlblOurocg.Text:= '数据来源: 中国OCG工作室';
  Root.AddObject(FlblOurocg);

  FlblRarnu:= TD2Text.Create(Root);
  FlblRarnu.Position.X:= 8;
  FlblRarnu.Position.Y:= 104;
  FlblRarnu.Width:= 280;
  FlblRarnu.Height:= 32;
  FlblRarnu.Fill.Color:= vcSkyblue;
  FlblRarnu.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FlblRarnu.Text:= '卡查开源: github.com/rarnu/yugioh-card';
  Root.AddObject(FlblRarnu);

  FlblThanks:= TD2Text.Create(Root);
  FlblThanks.Position.X:= 8;
  FlblThanks.Position.Y:= 136;
  FlblThanks.Width:= 280;
  FlblThanks.Height:= 32;
  FlblThanks.Fill.Color:= vcSkyblue;
  FlblThanks.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FlblThanks.Text:= '特别感谢: ';
  Root.AddObject(FlblThanks);


  // events
  FBtnUpdate.OnClick:=@onBtnUpdateClicked;
  FlblOurocg.OnClick:=@onBtnOurocgClicked;
  FlblRarnu.OnClick:=@onBtnRarnuClicked;
  FlblThanks.OnClick:=@onBtnThanksClicked;

end;

procedure TFormHelp.onBtnOurocgClicked(Sender: TObject);
begin
  openUrl('https://www.ourocg.cn');
end;

procedure TFormHelp.onBtnRarnuClicked(Sender: TObject);
begin
  openUrl('https://github.com/rarnu/yugioh-card');
end;

procedure TFormHelp.onBtnThanksClicked(Sender: TObject);
begin
  // TODO: thanks url
  openUrl('');
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


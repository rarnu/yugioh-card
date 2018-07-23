unit dlgConfirm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmBase, orca_scene2d, LCLIntf;

type

  { TDialogConfirm }

  TDialogConfirm = class(TFormBase)
    procedure FormCreate(Sender: TObject);
  private
    FlblMessage: TD2Text;
    FBtnCancel: TD2HudCornerButton;
    FBtnOk: TD2HudCornerButton;
    FURL: string;
    procedure onBtnCancelClicked(Sender: TObject);
    procedure onBtnOkClicked(Sender: TObject);
  public
    property URL: string read FURL write FURL;
  end;

var
  DialogConfirm: TDialogConfirm;

procedure showUpdate(aurl: string);

implementation

procedure showUpdate(aurl: string);
begin
  with TDialogConfirm.Create(nil) do begin
    URL:= aurl;
    ShowModal;
    Free;
  end;
end;

{$R *.frm}

{ TDialogConfirm }

procedure TDialogConfirm.FormCreate(Sender: TObject);
begin
  inherited;
  Window.Text:= '升级';
  Width:= 300;
  Height:= 150;

  FlblMessage:= TD2Text.Create(Root);
  FlblMessage.AutoSize:= True;
  FlblMessage.Align:= vaTop;
  FlblMessage.Height:= 32;
  FlblMessage.Padding.Top:= 8;
  FlblMessage.Padding.Left:= 8;
  FlblMessage.Padding.Right:= 8;
  FlblMessage.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FlblMessage.Text:= '发现新版本，点击<确定>按钮升级';
  FlblMessage.Fill.Color:= vcWhite;
  Root.AddObject(FlblMessage);

  FBtnCancel:= TD2HudCornerButton.Create(Root);
  FBtnCancel.Position.X:= 140;
  FBtnCancel.Position.Y:= 56;
  FBtnCancel.Width:= 60;
  FBtnCancel.Height:= 32;
  FBtnCancel.Text:= '取消';
  FBtnCancel.Corners:= [d2CornerTopLeft, d2CornerBottomLeft];
  Root.AddObject(FBtnCancel);

  FBtnOk:= TD2HudCornerButton.Create(Root);
  FBtnOk.Position.X:= 200;
  FBtnOk.Position.Y:= 56;
  FBtnOk.Width:= 60;
  FBtnOk.Height:= 32;
  FBtnOk.Text:= '确定';
  FBtnOk.Corners:= [d2CornerTopRight, d2CornerBottomRight];
  Root.AddObject(FBtnOk);

  FBtnOk.OnClick:=@onBtnOkClicked;
  FBtnCancel.OnClick:=@onBtnCancelClicked;
end;

procedure TDialogConfirm.onBtnOkClicked(Sender: TObject);
begin
  LCLIntf.OpenURL(Format('https://raw.githubusercontent.com/rarnu/yugioh-card/master/update/%s', [FURL]));
  Close;
end;

procedure TDialogConfirm.onBtnCancelClicked(Sender: TObject);
begin
  Close;
end;

end.


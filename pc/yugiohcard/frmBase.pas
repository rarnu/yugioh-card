unit frmBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, orca_scene2d;

type

  { TFormBase }

  TFormBase = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FScene: TD2Scene;
    FBackground: TD2Background;
    FWindow: TD2HudWindow;
    FRoot: TD2Layout;
    function GetD2Canvas: TD2Canvas;
  public

  published
    property Window: TD2HudWindow read FWindow;
    property Root: TD2Layout read FRoot;
    property D2Canvas: TD2Canvas read GetD2Canvas;
  end;

var
  FormBase: TFormBase;

implementation

{$R *.frm}

{ TFormBase }

procedure TFormBase.FormCreate(Sender: TObject);
begin
  //
  FScene := TD2Scene.Create(Self);
  FScene.Parent := Self;
  FScene.Align:= alClient;
  FScene.Transparency:= True;
  FBackground := TD2Background.Create(FScene);
  FBackground.Align:= vaClient;
  FBackground.HitTest:= False;
  FScene.AddObject(FBackground);
  FWindow := TD2HudWindow.Create(FBackground);
  FWindow.Align:= vaClient;
  FWindow.ShowSizeGrip:= False;
  FBackground.AddObject(FWindow);
  FRoot := TD2Layout.Create(FWindow);
  FRoot.Align:= vaClient;
  FRoot.Padding.Top:= 38;
  FRoot.Padding.Bottom:= 16;
  FRoot.Padding.Left:= 16;
  FRoot.Padding.Right:= 16;
  FWindow.AddObject(FRoot);

end;

function TFormBase.GetD2Canvas: TD2Canvas;
begin
  Result := FScene.Canvas;
end;

end.


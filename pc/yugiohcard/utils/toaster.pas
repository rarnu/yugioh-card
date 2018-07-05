unit toaster;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, orca_scene2d, ExtCtrls;

type

  { TToast }

  TToast = class
  private
    FTint: TD2RoundRect;
    FTimer: TTimer;
    procedure onTimerFired(Sender: TObject);
  public
    class procedure show(parent: TD2VisualObject; msg: string);
    constructor Create(p: TD2VisualObject; msg: string);
  end;

implementation

{ TToast }

procedure TToast.onTimerFired(Sender: TObject);
begin
  FTimer.Free;
  FTint.Free;
  Free;
end;

class procedure TToast.show(parent: TD2VisualObject; msg: string);
begin
  TToast.Create(parent, msg);
end;

constructor TToast.Create(p: TD2VisualObject; msg: string);
var
  FText: TD2Text;
begin
  FTint:= TD2RoundRect.Create(p);
  FTint.Width:= p.Width * 0.3;
  FTint.Height:= 40;
  FTint.Position.Y:= p.Height - 60;
  FTint.Position.X:= (p.Width - FTint.Width) / 2;
  FTint.Fill.Color:= '#CCFFFF00';
  p.AddObject(FTint);
  FText := TD2Text.Create(FTint);
  FText.Align:= vaClient;
  FText.HorzTextAlign:= TD2TextAlign.d2TextAlignCenter;
  FText.VertTextAlign:= TD2TextAlign.d2TextAlignCenter;
  FText.Fill.Color:= vcBlack;
  FText.Text:= msg;
  FTint.AddObject(FText);
  FTimer := TTimer.Create(nil);
  FTimer.Enabled:= False;
  FTimer.Interval:= 2000;
  FTimer.OnTimer:=@onTimerFired;
  FTimer.Enabled:= True;
end;

end.


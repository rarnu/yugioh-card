unit frmWiki;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmBase, orca_scene2d;

type

  { TFormWiki }

  TFormWiki = class(TFormBase)
    procedure FormCreate(Sender: TObject);
  private
    FWiki: string;

    Fsv: TD2ScrollBox;
    FtvWiki: TD2Text;

    procedure SetWiki(AValue: string);
    function getTextHeight(txt: string): Single;
  public
    property Wiki: string read FWiki write SetWiki;
  end;

var
  FormWiki: TFormWiki;

implementation

{$R *.frm}

{ TFormWiki }

procedure TFormWiki.FormCreate(Sender: TObject);
begin
  inherited;
  Window.Text:= 'Wiki';
  Width:= 400;
  Height:= 500;

  Fsv:= TD2ScrollBox.Create(Root);
  Fsv.Align:= vaClient;
  Fsv.UseSmallScrollBars:= True;
  Root.AddObject(Fsv);
  FtvWiki:= TD2Text.Create(Fsv);
  FtvWiki.Align:= vaTop;
  FtvWiki.WordWrap:= True;
  FtvWiki.Padding.Top:= 8;
  FtvWiki.Padding.Bottom:= 8;
  FtvWiki.Padding.Left:= 8;
  FtvWiki.Padding.Right:= 20;
  FtvWiki.Fill.Color:= vcWhite;
  FtvWiki.HorzTextAlign:= TD2TextAlign.d2TextAlignNear;
  FtvWiki.VertTextAlign:= TD2TextAlign.d2TextAlignNear;
  Fsv.AddObject(FtvWiki);
end;

procedure TFormWiki.SetWiki(AValue: string);
var
  h: Single;
  function stripHTML(S: string): string;
  var
    TagBegin, TagEnd, TagLength: integer;
  begin
    TagBegin := Pos( '<', S);

    while (TagBegin > 0) do begin
      TagEnd := Pos('>', S);
      TagLength := TagEnd - TagBegin + 1;
      Delete(S, TagBegin, TagLength);
      TagBegin:= Pos( '<', S);
    end;
    Exit(S);
  end;
begin
  FWiki:=AValue;
  // show wiki with html format
  FWiki:= FWiki.Replace('<p>', '');
  FWiki:= FWiki.Replace('<br />', #13#10);
  FWiki:= FWiki.Replace('</p>', #13#10);
  FWiki:= FWiki.Replace('<li>', '  * ');
  FWiki := stripHTML(FWiki);
  h := getTextHeight(FWiki);
  FtvWiki.Text:= FWiki;
  FtvWiki.Height:= h;
end;

function TFormWiki.getTextHeight(txt: string): Single;
var
  t: TD2Text;
  r: TD2Rect;
  c: TD2Canvas;
begin
  if (txt = '') then Exit(0);
  t := TD2Text.Create(Root);
  c := D2Canvas;
  c.Font.Assign(t.Font);
  r:= d2Rect(0,0,320,5000);
  c.MeasureText(r, r, WideString(txt), True, d2TextAlignNear, d2TextAlignNear);
  t.Free;
  Result := r.Bottom;
end;

end.


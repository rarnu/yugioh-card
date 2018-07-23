unit frmSearch;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmBase, orca_scene2d;

type

  { TFormSearch }

  TFormSearch = class(TFormBase)
    procedure FormCreate(Sender: TObject);
  private
    // data
    FCardType: string;

    // ui
    FBtnSearch: TD2HudCornerButton;
    FKey: string;

    FLayCardType: TD2Layout;
    FlblCardType: TD2Text;
    FbtnCtMonster: TD2HudCornerButton;
    FbtnCtMagic: TD2HudCornerButton;
    FbtnCtTrap: TD2HudCornerButton;
    FbtnTxtMonster: TD2Text;
    FbtnTxtMagic: TD2Text;
    FbtnTxtTrap: TD2Text;
    FLayEffect: TD2Layout;
    FlblEffect: TD2Text;
    FedtEffect: TD2HudTextBox;
    FLayMonster: TD2Layout;
    FLayMagic: TD2Layout;
    FLayTrap: TD2Layout;

    // monster
    FbtnMonEleLight: TD2HudCornerButton;
    FbtnMonEleDark: TD2HudCornerButton;
    FbtnMonEleFire: TD2HudCornerButton;
    FbtnMonEleWater: TD2HudCornerButton;
    FbtnMonEleEarth: TD2HudCornerButton;
    FbtnMonEleWind: TD2HudCornerButton;
    FbtnMonEleGod: TD2HudCornerButton;

    FbtnMonCtNormal: TD2HudCornerButton;
    FbtnMonCtEffect: TD2HudCornerButton;
    FbtnMonCtRitual: TD2HudCornerButton;
    FbtnMonCtFusion: TD2HudCornerButton;
    FbtnMonCtSync: TD2HudCornerButton;
    FbtnMonCtXyz: TD2HudCornerButton;
    FbtnMonCttoon: TD2HudCornerButton;
    FbtnMonCtUnion: TD2HudCornerButton;
    FbtnMonCtSpirit: TD2HudCornerButton;
    FbtnMonCtTuner: TD2HudCornerButton;
    FbtnMonCtDouble: TD2HudCornerButton;
    FbtnMonCtPendulum: TD2HudCornerButton;
    FbtnMonCtReverse: TD2HudCornerButton;
    FbtnMonCtSS: TD2HudCornerButton;
    FbtnMonCtLink: TD2HudCornerButton;

    FbtnMonRcWater: TD2HudCornerButton;
    FbtnMonRcBeast: TD2HudCornerButton;
    FbtnMonRcBW: TD2HudCornerButton;
    FbtnMonRcCreation: TD2HudCornerButton;
    FbtnMonRcDino: TD2HudCornerButton;
    FbtnMonRcGod: TD2HudCornerButton;
    FbtnMonRcDragon: TD2HudCornerButton;
    FbtnMonRcAngel: TD2HudCornerButton;
    FbtnMonRcDemon: TD2HudCornerButton;
    FbtnMonRcFish: TD2HudCornerButton;
    FbtnMonRcInsect: TD2HudCornerButton;
    FbtnMonRcMachine: TD2HudCornerButton;
    FbtnMonRcPlant: TD2HudCornerButton;
    FbtnMonRcCy: TD2HudCornerButton;
    FbtnMonRcFire: TD2HudCornerButton;
    FbtnMonRcClaim: TD2HudCornerButton;
    FbtnMonRcRock: TD2HudCornerButton;
    FbtnMonRcSD: TD2HudCornerButton;
    FbtnMonRcMagician: TD2HudCornerButton;
    FbtnMonRcThunder: TD2HudCornerButton;
    FbtnMonRcWarrior: TD2HudCornerButton;
    FbtnMonRcWB: TD2HudCornerButton;
    FbtnMonRcUndead: TD2HudCornerButton;
    FbtnMonRcDD: TD2HudCornerButton;
    FbtnMonRcCyber: TD2HudCornerButton;

    FedtLevel: TD2HudTextBox;
    FedtScale: TD2HudTextBox;
    FedtAtk: TD2HudTextBox;
    FedtDef: TD2HudTextBox;
    FedtLink: TD2HudTextBox;

    FBtnLink7: TD2HudCornerButton;
    FBtnLink8: TD2HudCornerButton;
    FBtnLink9: TD2HudCornerButton;
    FBtnLink4: TD2HudCornerButton;
    FBtnLink5: TD2HudCornerButton;
    FBtnLink6: TD2HudCornerButton;
    FBtnLink1: TD2HudCornerButton;
    FBtnLink2: TD2HudCornerButton;
    FBtnLink3: TD2HudCornerButton;


    // magic
    FbtnMtNormal: TD2HudCornerButton;
    FbtnMtEquip: TD2HudCornerButton;
    FbtnMtQuick: TD2HudCornerButton;
    FbtnMtCont: TD2HudCornerButton;
    FbtnMtField: TD2HudCornerButton;
    FbtnMtRitual: TD2HudCornerButton;

    // trap
    FbtnTtNormal: TD2HudCornerButton;
    FbtnTtCont: TD2HudCornerButton;
    FbtnTtCounter: TD2HudCornerButton;

    procedure onBtnCardypeClicked(Sender: TObject);
    procedure onBtnSearchClicked(Sender: TObject);
    procedure onBtnSelectorClicked(Sender: TObject);
  public
  published
    property Key: string read FKey;
  end;

var
  FormSearch: TFormSearch;

implementation

{$R *.frm}

{ TFormSearch }

procedure TFormSearch.FormCreate(Sender: TObject);
var
  FTmp: TD2Layout;
  FMTmp: TD2Layout;
  FTTmp: TD2Layout;

  function makeButton(txt: string; cont: TD2VisualObject; idx: integer; onClick: TNotifyEvent = nil; w: integer = 50;
    corner: TD2Corners = []): TD2HudCornerButton;
  var
    btn: TD2HudCornerButton;
  begin
    btn := TD2HudCornerButton.Create(cont);
    btn.Align := vaLeft;
    btn.Position.X := idx * 100;
    btn.Width := w;
    btn.Text := txt;
    btn.Corners := corner;
    btn.OnClick := onClick;
    cont.AddObject(btn);
    Exit(btn);
  end;

  function makeTextBox(placeholder: string; cont: TD2VisualObject): TD2HudTextBox;
  var
    edt: TD2HudTextBox;
  begin
    edt := TD2HudTextBox.Create(cont);
    edt.Align := vaClient;
    edt.Hint := placeholder;
    edt.ShowHint := True;
    cont.AddObject(edt);
    Exit(edt);
  end;

  function makeTmpLayout(txt: string; cont: TD2VisualObject; idx: integer; paddingTop: integer = 4; paddingBottom: integer = 4): TD2Layout;
  var
    tmp: TD2Layout;
    t: TD2Text;
  begin
    tmp := TD2Layout.Create(cont);
    tmp.Align := vaTop;
    tmp.Height := 32;
    tmp.Padding.Top := paddingTop;
    tmp.Padding.Bottom := paddingBottom;
    tmp.Position.Y := idx * 40;
    cont.AddObject(tmp);
    t := TD2Text.Create(tmp);
    t.Align := vaMostLeft;
    t.Width := 70;
    t.HorzTextAlign := TD2TextAlign.d2TextAlignNear;
    t.Fill.Color := vcWhite;
    t.Text := txt;
    tmp.AddObject(t);
    Exit(tmp);
  end;

begin
  inherited;
  FKey := '';
  FCardType := '';
  Width := 470;
  Height := 730;
  Window.Text := '高级搜索';

  FBtnSearch := TD2HudCornerButton.Create(Window);
  FBtnSearch.Width := 50;
  FBtnSearch.Height := 20;
  FBtnSearch.Position.X := 400;
  FBtnSearch.Position.Y := 6;
  FBtnSearch.Text := '搜索';
  Window.AddObject(FBtnSearch);

  FLayCardType := TD2Layout.Create(Root);
  FLayCardType.Align := vaTop;
  FLayCardType.Height := 32;
  FLayCardType.Padding.Left := 8;
  FLayCardType.Padding.Right := 8;
  FLayCardType.Padding.Top := 4;
  FLayCardType.Padding.Bottom := 4;
  Root.AddObject(FLayCardType);

  FlblCardType := TD2Text.Create(FLayCardType);
  FlblCardType.Fill.Color := vcWhite;
  FlblCardType.Text := '卡片种类';
  FlblCardType.Align := vaLeft;
  FlblCardType.Width := 70;
  FlblCardType.HorzTextAlign := TD2TextAlign.d2TextAlignNear;
  FLayCardType.AddObject(FlblCardType);

  FbtnCtMonster := makeButton('', FLayCardType, 0, nil, 60, [d2CornerTopLeft, d2CornerBottomLeft]);
  FbtnCtMagic := makeButton('', FLayCardType, 1, nil, 60);
  FbtnCtTrap := makeButton('', FLayCardType, 2, nil, 60, [d2CornerTopRight, d2CornerBottomRight]);

  FbtnTxtMonster := TD2Text.Create(FbtnCtMonster);
  FbtnTxtMonster.Fill.Color := vcSkyblue;
  FbtnTxtMonster.Align := vaClient;
  FbtnTxtMonster.HitTest := False;
  FbtnTxtMonster.Text := '怪兽';
  FbtnCtMonster.AddObject(FbtnTxtMonster);

  FbtnTxtMagic := TD2Text.Create(FbtnCtMagic);
  FbtnTxtMagic.Fill.Color := vcWhite;
  FbtnTxtMagic.Align := vaClient;
  FbtnTxtMagic.HitTest := False;
  FbtnTxtMagic.Text := '魔法';
  FbtnCtMagic.AddObject(FbtnTxtMagic);

  FbtnTxtTrap := TD2Text.Create(FbtnCtTrap);
  FbtnTxtTrap.Fill.Color := vcWhite;
  FbtnTxtTrap.Align := vaClient;
  FbtnTxtTrap.HitTest := False;
  FbtnTxtTrap.Text := '陷阱';
  FbtnCtTrap.AddObject(FbtnTxtTrap);

  FLayEffect := TD2Layout.Create(Root);
  FLayEffect.Align := vaTop;
  FLayEffect.Position.Y := 41;
  FLayEffect.Height := 40;
  FLayEffect.Padding.Left := 8;
  FLayEffect.Padding.Right := 8;
  Root.AddObject(FLayEffect);
  FlblEffect := TD2Text.Create(FLayEffect);
  FlblEffect.Fill.Color := vcWhite;
  FlblEffect.Text := '卡片效果';
  FlblEffect.Align := vaLeft;
  FlblEffect.Width := 70;
  FlblEffect.HorzTextAlign := TD2TextAlign.d2TextAlignNear;
  FLayEffect.AddObject(FlblEffect);
  FedtEffect := TD2HudTextBox.Create(FLayEffect);
  FedtEffect.Padding.Top := 4;
  FedtEffect.Padding.Bottom := 4;
  FedtEffect.Align := vaClient;
  FLayEffect.AddObject(FedtEffect);

  FLayMonster := TD2Layout.Create(Root);
  FLayMonster.Align := vaClient;
  FLayMonster.Padding.Top := 4;
  FLayMonster.Padding.Bottom := 8;
  FLayMonster.Padding.Left := 8;
  FLayMonster.Padding.Right := 8;
  FLayMonster.Visible := True;
  Root.AddObject(FLayMonster);

  FLayMagic := TD2Layout.Create(Root);
  FLayMagic.Align := vaClient;
  FLayMagic.Padding.Top := 4;
  FLayMagic.Padding.Bottom := 8;
  FLayMagic.Padding.Left := 8;
  FLayMagic.Padding.Right := 8;
  FLayMagic.Visible := False;
  Root.AddObject(FLayMagic);

  FLayTrap := TD2Layout.Create(Root);
  FLayTrap.Align := vaClient;
  FLayTrap.Padding.Top := 4;
  FLayTrap.Padding.Bottom := 8;
  FLayTrap.Padding.Left := 8;
  FLayTrap.Padding.Right := 8;
  FLayTrap.Visible := False;
  Root.AddObject(FLayTrap);

  // monster
  FTmp := makeTmpLayout('怪兽属性', FLayMonster, 0);
  FbtnMonEleLight := makeButton('光', FTmp, 1, @onBtnSelectorClicked, 50, [d2CornerTopLeft, d2CornerBottomLeft]);
  FbtnMonEleDark := makeButton('暗', FTmp, 2, @onBtnSelectorClicked);
  FbtnMonEleFire := makeButton('炎', FTmp, 3, @onBtnSelectorClicked);
  FbtnMonEleWater := makeButton('水', FTmp, 4, @onBtnSelectorClicked);
  FbtnMonEleEarth := makeButton('地', FTmp, 5, @onBtnSelectorClicked);
  FbtnMonEleWind := makeButton('风', FTmp, 6, @onBtnSelectorClicked);
  FbtnMonEleGod := makeButton('神', FTmp, 7, @onBtnSelectorClicked, 50, [d2CornerTopRight, d2CornerBottomRight]);
  FTmp := makeTmpLayout('怪兽种类', FLayMonster, 1, 4, 0);
  FbtnMonCtNormal := makeButton('通常', FTmp, 1, @onBtnSelectorClicked, 50, [d2CornerTopLeft]);
  FbtnMonCtEffect := makeButton('效果', FTmp, 2, @onBtnSelectorClicked);
  FbtnMonCtRitual := makeButton('仪式', FTmp, 3, @onBtnSelectorClicked);
  FbtnMonCtFusion := makeButton('融合', FTmp, 4, @onBtnSelectorClicked);
  FbtnMonCtSync := makeButton('同调', FTmp, 5, @onBtnSelectorClicked);
  FbtnMonCtXyz := makeButton('XYZ', FTmp, 6, @onBtnSelectorClicked);
  FbtnMonCttoon := makeButton('卡通', FTmp, 7, @onBtnSelectorClicked, 50, [d2CornerTopRight]);
  FTmp := makeTmpLayout('', FLayMonster, 2, 0, 0);
  FbtnMonCtUnion := makeButton('同盟', FTmp, 1, @onBtnSelectorClicked);
  FbtnMonCtSpirit := makeButton('灵魂', FTmp, 2, @onBtnSelectorClicked);
  FbtnMonCtTuner := makeButton('调整', FTmp, 3, @onBtnSelectorClicked);
  FbtnMonCtDouble := makeButton('二重', FTmp, 4, @onBtnSelectorClicked);
  FbtnMonCtPendulum := makeButton('灵摆', FTmp, 5, @onBtnSelectorClicked);
  FbtnMonCtReverse := makeButton('反转', FTmp, 6, @onBtnSelectorClicked);
  FbtnMonCtSS := makeButton('特殊召唤', FTmp, 7, @onBtnSelectorClicked, 50, [d2CornerBottomRight]);
  FbtnMonCtSS.Font.Size := 9;
  FTmp := makeTmpLayout('', FLayMonster, 3, 0, 4);
  FbtnMonCtLink := makeButton('连接', FTmp, 1, @onBtnSelectorClicked, 50, [d2CornerBottomLeft, d2CornerBottomRight]);
  FTmp := makeTmpLayout('怪兽种族', FLayMonster, 4, 4, 0);
  FbtnMonRcWater := makeButton('水', FTmp, 1, @onBtnSelectorClicked, 50, [d2CornerTopLeft]);
  FbtnMonRcBeast := makeButton('兽', FTmp, 2, @onBtnSelectorClicked);
  FbtnMonRcBW := makeButton('兽战士', FTmp, 3, @onBtnSelectorClicked);
  FbtnMonRcCreation := makeButton('创造神', FTmp, 4, @onBtnSelectorClicked);
  FbtnMonRcDino := makeButton('恐龙', FTmp, 5, @onBtnSelectorClicked);
  FbtnMonRcGod := makeButton('幻神兽', FTmp, 6, @onBtnSelectorClicked);
  FbtnMonRcDragon := makeButton('龙', FTmp, 7, @onBtnSelectorClicked, 50, [d2CornerTopRight]);
  FTmp := makeTmpLayout('', FLayMonster, 5, 0, 0);
  FbtnMonRcAngel := makeButton('天使', FTmp, 1, @onBtnSelectorClicked);
  FbtnMonRcDemon := makeButton('恶魔', FTmp, 2, @onBtnSelectorClicked);
  FbtnMonRcFish := makeButton('鱼', FTmp, 3, @onBtnSelectorClicked);
  FbtnMonRcInsect := makeButton('昆虫', FTmp, 4, @onBtnSelectorClicked);
  FbtnMonRcMachine := makeButton('机械', FTmp, 5, @onBtnSelectorClicked);
  FbtnMonRcPlant := makeButton('植物', FTmp, 6, @onBtnSelectorClicked);
  FbtnMonRcCy := makeButton('念动力', FTmp, 7, @onBtnSelectorClicked);
  FTmp := makeTmpLayout('', FLayMonster, 6, 0, 0);
  FbtnMonRcFire := makeButton('炎', FTmp, 1, @onBtnSelectorClicked);
  FbtnMonRcClaim := makeButton('爬虫类', FTmp, 2, @onBtnSelectorClicked);
  FbtnMonRcRock := makeButton('岩石', FTmp, 3, @onBtnSelectorClicked);
  FbtnMonRcSD := makeButton('海龙', FTmp, 4, @onBtnSelectorClicked);
  FbtnMonRcMagician := makeButton('魔法师', FTmp, 5, @onBtnSelectorClicked);
  FbtnMonRcThunder := makeButton('雷', FTmp, 6, @onBtnSelectorClicked);
  FbtnMonRcWarrior := makeButton('战士', FTmp, 7, @onBtnSelectorClicked, 50, [d2CornerBottomRight]);
  FTmp := makeTmpLayout('', FLayMonster, 7, 0, 4);
  FbtnMonRcWB := makeButton('鸟兽', FTmp, 1, @onBtnSelectorClicked);
  FbtnMonRcUndead := makeButton('不死', FTmp, 2, @onBtnSelectorClicked);
  FbtnMonRcDD := makeButton('幻龙', FTmp, 3, @onBtnSelectorClicked);
  FbtnMonRcCyber := makeButton('电子界', FTmp, 4, @onBtnSelectorClicked, 50, [d2CornerBottomRight]);

  FTmp := makeTmpLayout('星数阶级', FLayMonster, 8);
  FedtLevel := makeTextBox('可以是范围，如 1-4', FTmp);
  FTmp := makeTmpLayout('灵摆刻度', FLayMonster, 9);
  FedtScale := makeTextBox('可以是范围，如 1-4', FTmp);
  FTmp := makeTmpLayout('攻击力', FLayMonster, 10);
  FedtAtk := makeTextBox('可以是范围，如 1500-2000', FTmp);
  FTmp := makeTmpLayout('守备力', FLayMonster, 11);
  FedtDef := makeTextBox('可以是范围，如 1500-2000', FTmp);
  FTmp := makeTmpLayout('连接值', FLayMonster, 11);
  FedtLink := makeTextBox('可以是范围，如 1-3', FTmp);
  FTmp := makeTmpLayout('连接方向', FLayMonster, 12, 4, 0);
  FBtnLink7 := makeButton('↖', FTmp, 1, @onBtnSelectorClicked, 50, [d2CornerTopLeft]);
  FBtnLink8 := makeButton('↑', FTmp, 2, @onBtnSelectorClicked);
  FBtnLink9 := makeButton('↗', FTmp, 3, @onBtnSelectorClicked, 50, [d2CornerTopRight]);
  FTmp := makeTmpLayout('', FLayMonster, 13, 0, 0);
  FBtnLink4 := makeButton('←', FTmp, 1, @onBtnSelectorClicked);
  FBtnLink5 := makeButton('', FTmp, 2);
  FBtnLink5.Enabled := False;
  FBtnLink6 := makeButton('→', FTmp, 3, @onBtnSelectorClicked);
  FTmp := makeTmpLayout('', FLayMonster, 14, 0, 4);
  FBtnLink1 := makeButton('↙', FTmp, 1, @onBtnSelectorClicked, 50, [d2CornerBottomLeft]);
  FBtnLink2 := makeButton('↓', FTmp, 2, @onBtnSelectorClicked);
  FBtnLink3 := makeButton('↘', FTmp, 3, @onBtnSelectorClicked, 50, [d2CornerBottomRight]);

  // magic
  FMTmp := makeTmpLayout('魔法种类', FLayMagic, 0);
  FbtnMtNormal := makeButton('通常', FMTmp, 1, @onBtnSelectorClicked, 50, [d2CornerTopLeft, d2CornerBottomLeft]);
  FbtnMtEquip := makeButton('装备', FMTmp, 2, @onBtnSelectorClicked);
  FbtnMtQuick := makeButton('速攻', FMTmp, 3, @onBtnSelectorClicked);
  FbtnMtCont := makeButton('永续', FMTmp, 4, @onBtnSelectorClicked);
  FbtnMtField := makeButton('场地', FMTmp, 5, @onBtnSelectorClicked);
  FbtnMtRitual := makeButton('仪式', FMTmp, 6, @onBtnSelectorClicked, 50, [d2CornerTopRight, d2CornerBottomRight]);

  // trap
  FTTmp := makeTmpLayout('陷阱种类', FLayTrap, 0);
  FbtnTtNormal := makeButton('通常', FTTmp, 1, @onBtnSelectorClicked, 50, [d2CornerTopLeft, d2CornerBottomLeft]);
  FbtnTtCont := makeButton('永续', FTTmp, 2, @onBtnSelectorClicked);
  FbtnTtCounter := makeButton('反击', FTTmp, 3, @onBtnSelectorClicked, 50, [d2CornerTopRight, d2CornerBottomRight]);

  // events
  FBtnSearch.OnClick := @onBtnSearchClicked;
  FbtnCtMonster.OnClick := @onBtnCardypeClicked;
  FbtnCtMagic.OnClick := @onBtnCardypeClicked;
  FbtnCtTrap.OnClick := @onBtnCardypeClicked;

  onBtnCardypeClicked(FbtnCtMonster);

end;

procedure TFormSearch.onBtnCardypeClicked(Sender: TObject);
begin
  if (Sender = FbtnCtMonster) then
  begin
    FCardType := '怪兽';
    FbtnTxtMonster.Fill.Color := vcSkyblue;
    FbtnTxtMagic.Fill.Color := vcWhite;
    FbtnTxtTrap.Fill.Color := vcWhite;
    FLayMonster.Visible := True;
    FLayMagic.Visible := False;
    FLayTrap.Visible := False;
  end
  else if (Sender = FbtnCtMagic) then
  begin
    FCardType := '魔法';
    FbtnTxtMagic.Fill.Color := vcSkyblue;
    FbtnTxtMonster.Fill.Color := vcWhite;
    FbtnTxtTrap.Fill.Color := vcWhite;
    FLayMagic.Visible := True;
    FLayMonster.Visible := False;
    FLayTrap.Visible := False;
  end
  else if (Sender = FbtnCtTrap) then
  begin
    FCardType := '陷阱';
    FbtnTxtTrap.Fill.Color := vcSkyblue;
    FbtnTxtMonster.Fill.Color := vcWhite;
    FbtnTxtMagic.Fill.Color := vcWhite;
    FLayTrap.Visible := True;
    FLayMonster.Visible := False;
    FLayMagic.Visible := False;
  end;
end;

procedure TFormSearch.onBtnSearchClicked(Sender: TObject);
var
  eff: string;
  ct2: string;
  atk: string;
  def: string;
  scale: string;
  level: string;
  link: string;
  race: string;
  ele: string;
  la: string;

  function isButtonSelected(btn: TD2HudCornerButton): boolean;
  var
    c: string;
  begin
    c := btn.FontFill.Color;
    Exit(c = vcSkyblue);
  end;

  function buildMonsterCardType(): string;
  var
    tmp: string = '';
  begin
    if (isButtonSelected(FbtnMonCtNormal)) then
      tmp += '通常,';
    if (isButtonSelected(FbtnMonCtEffect)) then
      tmp += '效果,';
    if (isButtonSelected(FbtnMonCtRitual)) then
      tmp += '仪式,';
    if (isButtonSelected(FbtnMonCtFusion)) then
      tmp += '融合,';
    if (isButtonSelected(FbtnMonCtSync)) then
      tmp += '同调,';
    if (isButtonSelected(FbtnMonCtXyz)) then
      tmp += 'XYZ,';
    if (isButtonSelected(FbtnMonCttoon)) then
      tmp += '卡通,';
    if (isButtonSelected(FbtnMonCtUnion)) then
      tmp += '同盟,';
    if (isButtonSelected(FbtnMonCtSpirit)) then
      tmp += '灵魂,';
    if (isButtonSelected(FbtnMonCtTuner)) then
      tmp += '调整,';
    if (isButtonSelected(FbtnMonCtDouble)) then
      tmp += '二重,';
    if (isButtonSelected(FbtnMonCtPendulum)) then
      tmp += '灵摆,';
    if (isButtonSelected(FbtnMonCtReverse)) then
      tmp += '反转,';
    if (isButtonSelected(FbtnMonCtSS)) then
      tmp += '特殊召唤,';
    if (isButtonSelected(FbtnMonCtLink)) then
      tmp += '连接,';
    tmp := tmp.TrimRight([',']);
    Exit(tmp);
  end;

  function buildMonsterRace(): string;
  var
    tmp: string = '';
  begin
    if (isButtonSelected(FbtnMonRcWater)) then
      tmp += '水,';
    if (isButtonSelected(FbtnMonRcBeast)) then
      tmp += '兽,';
    if (isButtonSelected(FbtnMonRcBW)) then
      tmp += '兽战士,';
    if (isButtonSelected(FbtnMonRcCreation)) then
      tmp += '创造神,';
    if (isButtonSelected(FbtnMonRcDino)) then
      tmp += '恐龙,';
    if (isButtonSelected(FbtnMonRcGod)) then
      tmp += '幻神兽,';
    if (isButtonSelected(FbtnMonRcDragon)) then
      tmp += '龙,';

    if (isButtonSelected(FbtnMonRcAngel)) then
      tmp += '天使,';
    if (isButtonSelected(FbtnMonRcDemon)) then
      tmp += '恶魔,';
    if (isButtonSelected(FbtnMonRcFish)) then
      tmp += '鱼,';
    if (isButtonSelected(FbtnMonRcInsect)) then
      tmp += '昆虫,';
    if (isButtonSelected(FbtnMonRcMachine)) then
      tmp += '机械,';
    if (isButtonSelected(FbtnMonRcPlant)) then
      tmp += '植物,';
    if (isButtonSelected(FbtnMonRcCy)) then
      tmp += '念动力,';

    if (isButtonSelected(FbtnMonRcFire)) then
      tmp += '炎,';
    if (isButtonSelected(FbtnMonRcClaim)) then
      tmp += '爬虫类,';
    if (isButtonSelected(FbtnMonRcRock)) then
      tmp += '岩石,';
    if (isButtonSelected(FbtnMonRcSD)) then
      tmp += '海龙,';
    if (isButtonSelected(FbtnMonRcMagician)) then
      tmp += '魔法师,';
    if (isButtonSelected(FbtnMonRcThunder)) then
      tmp += '雷,';
    if (isButtonSelected(FbtnMonRcWarrior)) then
      tmp += '战士,';

    if (isButtonSelected(FbtnMonRcWB)) then
      tmp += '鸟兽,';
    if (isButtonSelected(FbtnMonRcUndead)) then
      tmp += '不死,';
    if (isButtonSelected(FbtnMonRcDD)) then
      tmp += '幻龙,';
    if (isButtonSelected(FbtnMonRcCyber)) then
      tmp += '电子界,';

    tmp := tmp.TrimRight([',']);
    Exit(tmp);
  end;

  function buildMonsterElement(): string;
  var
    tmp: string = '';
  begin
    if (isButtonSelected(FbtnMonEleLight)) then
      tmp += '光,';
    if (isButtonSelected(FbtnMonEleDark)) then
      tmp += '暗,';
    if (isButtonSelected(FbtnMonEleFire)) then
      tmp += '炎,';
    if (isButtonSelected(FbtnMonEleWater)) then
      tmp += '水,';
    if (isButtonSelected(FbtnMonEleEarth)) then
      tmp += '地,';
    if (isButtonSelected(FbtnMonEleWind)) then
      tmp += '风,';
    if (isButtonSelected(FbtnMonEleGod)) then
      tmp += '神,';
    tmp := tmp.TrimRight([',']);
    Exit(tmp);
  end;

  function buildMonsterLinkArrow(): string;
  var
    tmp: string = '';
  begin
    if (isButtonSelected(FBtnLink1)) then
      tmp += '1,';
    if (isButtonSelected(FBtnLink2)) then
      tmp += '2,';
    if (isButtonSelected(FBtnLink3)) then
      tmp += '3,';
    if (isButtonSelected(FBtnLink4)) then
      tmp += '4,';
    if (isButtonSelected(FBtnLink6)) then
      tmp += '6,';
    if (isButtonSelected(FBtnLink7)) then
      tmp += '7,';
    if (isButtonSelected(FBtnLink8)) then
      tmp += '8,';
    if (isButtonSelected(FBtnLink9)) then
      tmp += '9,';
    tmp := tmp.TrimRight([',']);
    Exit(tmp);
  end;

  function buildMagicCardType(): string;
  var
    tmp: string = '';
  begin
    if (isButtonSelected(FbtnMtNormal)) then
      tmp += '通常,';
    if (isButtonSelected(FbtnMtEquip)) then
      tmp += '装备,';
    if (isButtonSelected(FbtnMtQuick)) then
      tmp += '速攻,';
    if (isButtonSelected(FbtnMtCont)) then
      tmp += '永续,';
    if (isButtonSelected(FbtnMtField)) then
      tmp += '场地,';
    if (isButtonSelected(FbtnMtRitual)) then
      tmp += '仪式,';
    tmp := tmp.TrimRight([',']);
    Exit(tmp);
  end;

  function buildTrapCardType(): string;
  var
    tmp: string = '';
  begin
    if (isButtonSelected(fbtnTtNormal)) then
      tmp += '通常,';
    if (isButtonSelected(fbtnTtCont)) then
      tmp += '永续,';
    if (isButtonSelected(fbtnTtCounter)) then
      tmp += '反击,';
    tmp := tmp.TrimRight([',']);
    Exit(tmp);
  end;

begin
  // do search
  FKey := Format(' +(类:%s)', [FCardType]);
  eff := FedtEffect.Text.Trim;
  if (eff <> '') then
    FKey += Format(' +(效果:%s)', [eff]);
  if (FCardType = '怪兽') then
  begin
    atk := FedtAtk.Text.Trim;
    if (atk <> '') then
      FKey += Format(' +(atk:%s)', [atk]);
    def := FedtDef.Text.Trim;
    if (def <> '') then
      FKey += Format(' +(def:%s)', [def]);
    level := FedtLevel.Text.Trim;
    if (level <> '') then
      FKey += Format(' +(level:%s)', [level]);
    scale := FedtScale.Text.Trim;
    if (scale <> '') then
      FKey += Format(' +(刻度:%s)', [scale]);
    link := FedtLink.Text.Trim;
    if (link <> '') then
      FKey += Format(' +(link:%s)', [link]);
    ct2 := buildMonsterCardType();
    if (ct2 <> '') then
      FKey += Format(' +(类:%s)', [ct2]);
    race := buildMonsterRace();
    if (race <> '') then
      FKey += Format(' +(族:%s)', [race]);
    ele := buildMonsterElement();
    if (ele <> '') then
      FKey += Format(' +(属性:%s)', [ele]);
    la := buildMonsterLinkArrow();
    if (la <> '') then
      FKey += Format(' +(linkArrow:%s)', [la]);
  end
  else if (FCardType = '魔法') then
  begin
    ct2 := buildMagicCardType();
    if (ct2 <> '') then
      FKey += Format(' +(类:%s)', [ct2]);
  end
  else if (FCardType = '陷阱') then
  begin
    ct2 := buildTrapCardType();
    if (ct2 <> '') then
      FKey += Format(' +(类:%s)', [ct2]);
  end;
  ModalResult := mrOk;
end;

procedure TFormSearch.onBtnSelectorClicked(Sender: TObject);
var
  b: TD2HudCornerButton;
  c: string;
begin
  b := TD2HudCornerButton(Sender);
  c := b.FontFill.Color;
  if (c = vcSkyblue) then
  begin
    b.FontFill.Color := vcWhite;
  end
  else
  begin
    b.FontFill.Color := vcSkyblue;
  end;
end;

end.

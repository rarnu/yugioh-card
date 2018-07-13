unit htmlparser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, jsonparser, fpjson, jsonscanner, android;

type

  { THtmlParser }

  THtmlParser = class
  private
    class function getPackList(ahtml: string): string;
  public
    // json data
    class function getStoredJson(ahtml: string): string;
    class function getArticle(ahtml: string): string;
    class function getLimitList(ahtml: string): string;
    class function getPackageList(ahtml: string): string;
    class function getHotest(ahtml: string): string;

    // pure data
    class function getAdjust(ahtml: string): string;
    class function getWiki(ahtml: string): string;

  end;

  { TSearchResult }

  TSearchResult = class
  public
    class function parseSearchResult(ajsonstr: string): string;
  end;

implementation

{ TSearchResult }

class function TSearchResult.parseSearchResult(ajsonstr: string): string;
var
  json: TJSONObject = nil;
  parser: TJSONParser = nil;
  jarr: TJSONArray;
  ret: string = '';
  i: Integer;
  page: Integer = 0;
  pageCount: Integer = 0;
  ajapname: string = '';
  aenname: string = '';
begin
  ret := '{"result":0, "data":[';
  try
    try
      parser := TJSONParser.Create(ajsonstr, []);
      json := TJSONObject(parser.Parse);
      page := json.Objects['meta'].Integers['cur_page'];
      pageCount:= json.Objects['meta'].Integers['total_page'];
      jarr := json.Arrays['cards'];
      for i := 0 to jarr.Count -1 do begin
        with jarr.Objects[i] do begin
          try
            ajapname:= string(Strings['name_ja']).Replace('"', '\"');
          except
            ajapname:= '';
          end;
          try
            aenname:= string(Strings['name_en']).Replace('"', '\"');
          except
            aenname:= '';
          end;
          ret += Format('{"id":%d,"hashid":"%s","name":"%s","japname":"%s","enname":"%s","cardtype":"%s"},', [
            Integers['id'],
            Strings['hash_id'],
            string(Strings['name']).Replace('"', '\"'),
            ajapname,
            aenname,
            Strings['type_st']
          ]);
        end;

      end;
    except
    end;

  finally
    if (parser <> nil) then parser.Free;
    if (json <> nil) then json.Free;
  end;
  ret := ret.TrimRight([',']);
  ret += '],';
  ret += Format('"page":%d,"pagecount":%d}', [page, pageCount]);
  Exit(ret);
end;

{ THtmlParser }

class function THtmlParser.getPackList(ahtml: string): string;
const
  HTR = '<tr></tr>';
  HHREF = '<tr><td><a href="';
  HSMALL = '<small>';
  HSMALLEND = '</small>';
  HTD = '<td>';
  HTDEND = '</td>';
var
  ret: string = '';
begin
  // get pack list
  ahtml:= ahtml.Substring(ahtml.IndexOf(HTR) + HTR.Length).Trim;
  while (True) do begin
    if (not ahtml.Contains(HHREF)) then Break;
    ret += '{';
    ahtml:= ahtml.Substring(ahtml.IndexOf(HHREF) + HHREF.Length);
    ret += Format('"url":"%s",', [ahtml.Substring(0, ahtml.IndexOf('"')).Trim]);
    ahtml:= ahtml.Substring(ahtml.IndexOf('>') + 1);
    ret += Format('"name":"%s",', [ahtml.Substring(0, ahtml.IndexOf('</a>')).Trim]);
    ahtml:= ahtml.Substring(ahtml.IndexOf(HSMALL) + HSMALL.Length);
    ret += Format('"date":"%s",', [ahtml.Substring(0, ahtml.IndexOf(HSMALLEND)).Trim]);
    ahtml:= ahtml.Substring(ahtml.IndexOf(HTD) + HTD.Length);
    ret += Format('"abbr":"%s",', [ahtml.Substring(0, ahtml.IndexOf(HTDEND)).Trim]);
    ahtml:= ahtml.Substring(ahtml.IndexOf(HTD) + HTD.Length);
    ret += Format('"rare":"%s"', [ahtml.Substring(0, ahtml.IndexOf(HTDEND)).Trim]);
    ret += '},'
  end;

  ret := ret.TrimRight([',']);
  Exit(ret);
end;

class function THtmlParser.getStoredJson(ahtml: string): string;
const
  STORE_BEGIN = 'window.__STORE__ =';
  STORE_END = '</script>';
var
  ret: string = '';
begin
  // get stored json
  if (ahtml.Contains(STORE_BEGIN)) then begin
    ret := ahtml.Substring(ahtml.IndexOf(STORE_BEGIN));
    ret := ret.Substring(0, ret.IndexOf(STORE_END));
    ret := ret.Replace(STORE_BEGIN, '');
    ret := ret.Trim.TrimRight([';']);
  end;
  Exit(ret);
end;

class function THtmlParser.getArticle(ahtml: string): string;
const
  ARTICLE_BEGIN = '<article class="detail">';
  ARTICLE_END = '</article>';
  HDIV = '</div>';
  HTABLE = '</table>';
  HIMGID = 'http://ocg.resource.m2v.cn/';
  H1 = '<div class="val el-col-xs-18 el-col-sm-12 el-col-md-14 el-col-sm-pull-8 el-col-md-pull-6">';
  H2 = '<div class="val el-col-xs-8 el-col-sm-6 el-col-sm-pull-8 el-col-md-6 el-col-md-pull-6">';
  H3 = '<div class="val el-col-xs-10 el-col-sm-6 el-col-sm-pull-8 el-col-md-8 el-col-md-pull-6">';
  H31 = '<div class="val el-col-xs-6 el-col-sm-4">';
  H32 = '<div class="val el-col-xs-18 el-col-sm-4">';
  H33 = '<div class="val el-col-xs-6 el-col-sm-12">';
  H34 = '<div class="val el-col-xs-6 el-col-sm-4 el-col-md-6">';
  H4 = '<div class="val el-col-xs-18 el-col-sm-20">';
  H5 = '<div class="val el-col-24 effect">';
  H6 = '<table style="width:100%" ID="pack_table_main">';
  H7 = '<div class="linkMark-Context visible-xs"></div>';

  HLINKON = 'mark-linkmarker_%d_on';
  HDIVLINE = '<div class="line"></div>';
  HDIVLINE2 = '<div class=''line''></div>';

  ESPLIT = '- - - - - -';
var
  ret: string = '';
  cimgid: string = '';
  cname: string = '';
  cjapname: string = '';
  cenname: string = '';
  ccardtype: string = '';
  ctarr: TStringArray;
  cpassword: string = '';
  climit: string = '';
  cbelongs: string = '';
  crare: string = '';
  cpack: string = '';
  ceffect: string = '';
  crace: string = '';
  celement: string = '';
  clevel: string = '';
  catk: string = '';
  cdef: string = '';
  clink: string = '';
  clinkarrow: string = '';
  tmpArrow: string = '';
  cpacklist: string = '';
  i: Integer;
begin
  // get article
  if (ahtml.Contains(ARTICLE_BEGIN)) then begin
    ret := ahtml.Substring(ahtml.IndexOf(ARTICLE_BEGIN));
    ret := ret.Substring(0, ret.IndexOf(ARTICLE_END));
    ret := ret.Substring(ret.IndexOf(HIMGID) + HIMGID.Length);
    cimgid:= ret.Substring(0, ret.IndexOf('.')).Trim;
    ret := ret.Substring(ret.IndexOf(H1) + H1.Length);
    cname:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
    ret := ret.Substring(ret.IndexOf(H1) + H1.Length);
    cjapname:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
    ret := ret.Substring(ret.IndexOf(H1) + H1.Length);
    cenname:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
    ret := ret.Substring(ret.IndexOf(H1) + H1.Length);
    ccardtype:= ret.Substring(0, ret.IndexOf(HDIV)).Trim.Replace('</span>', '|').Replace('<span>', '');
    ctarr := ccardtype.Split('|');
    ccardtype:= '';
    for i := 0 to Length(ctarr) - 1 do ccardtype += ctarr[i].Trim + ' | ';
    ccardtype:= ccardtype.Trim.TrimRight(['|']);
    ret := ret.Substring(ret.IndexOf(H1) + H1.Length);
    cpassword:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
    ret := ret.Substring(ret.IndexOf(H2) + H2.Length);
    climit:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
    ret := ret.Substring(ret.IndexOf(H3) + H3.Length);
    cbelongs:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;

    if (ccardtype.Contains('怪兽')) then begin
      if (ccardtype.Contains('连接')) then begin
        // link monster
        ret := ret.Substring(ret.IndexOf(H31) + H31.Length);
        crace:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
        ret := ret.Substring(ret.IndexOf(H31) + H31.Length);
        celement:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
        ret := ret.Substring(ret.IndexOf(H31) + H31.Length);
        catk:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
        ret := ret.Substring(ret.IndexOf(H34) + H34.Length);
        clink:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;

        // linkarrow
        ret := ret.Substring(ret.IndexOf(H7) + H7.Length);
        tmpArrow:= ret.Substring(0, ret.IndexOf(HDIV));

        for i:= 1 to 9 do begin
          if (tmpArrow.Contains(Format(HLINKON, [i]))) then begin
            clinkarrow += i.ToString;
          end;
        end;

      end else begin
        // monster
        ret := ret.Substring(ret.IndexOf(H31) + H31.Length);
        crace:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
        ret := ret.Substring(ret.IndexOf(H31) + H31.Length);
        celement:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
        ret := ret.Substring(ret.IndexOf(H32) + H32.Length);
        clevel := ret.Substring(0, ret.IndexOf(HDIV)).Trim;
        ret := ret.Substring(ret.IndexOf(H31) + H31.Length);
        catk:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
        ret := ret.Substring(ret.IndexOf(H33) + H33.Length);
        cdef := ret.Substring(0, ret.IndexOf(HDIV)).Trim;
      end;
    end;

    ret := ret.Substring(ret.IndexOf(H4) + H4.Length);
    crare:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
    if (crare.Contains('>')) then crare:= '';
    ret := ret.Substring(ret.IndexOf(H4) + H4.Length);
    cpack:= ret.Substring(0, ret.IndexOf(HDIV)).Trim;
    if (cpack.Contains('>')) then cpack:= '';
    ret := ret.Substring(ret.IndexOf(H5) + H5.Length).Replace(HDIVLINE, ESPLIT).Replace(HDIVLINE2, ESPLIT).Replace('<br>', '');
    ceffect:= ret.Substring(0, ret.IndexOf(HDIV)).Trim.Replace(#13, '').Replace(#10, '');

    // parse packs list
    ret := ret.Substring(ret.IndexOf(H6) + H6.Length);
    ret := ret.Substring(0, ret.IndexOf(HTABLE)).Trim;
    cpacklist:= getPackList(ret);
  end;

  Exit(Format('{"result":0, "data":{"name":"%s","japname":"%s","enname":"%s","cardtype":"%s","password":"%s","limit":"%s","belongs":"%s","rare":"%s","pack":"%s","effect":"%s","race":"%s","element":"%s","level":"%s","atk":"%s","def":"%s","link":"%s","linkarrow":"%s","imageid":"%s","packs":[%s]}}', [
    cname, cjapname, cenname, ccardtype, cpassword, climit, cbelongs, crare, cpack, ceffect, crace, celement, clevel, catk, cdef, clink, clinkarrow, cimgid, cpacklist
  ]));

end;

class function THtmlParser.getLimitList(ahtml: string): string;
const
  HTABLE = '<table class="deckDetail">';
  HTABLEEND = '</table>';
  HCARD = '<td class="cname"><div class="typeIcon" style="border-color:';
  HREFID = 'https://www.ourocg.cn/card/';
  HTARGET = 'target=_blank>';
  HAEND = '</a>';
  HTBODY = '<tbody>';
var
  strarr: TStringArray;
  i: Integer;
  tmp: string;
  ret: string = '';
begin
  ret := '{"result":0, "data":[';
  if (ahtml.Contains(HTABLE)) then begin
    ahtml:= ahtml.Substring(ahtml.IndexOf(HTABLE));
    ahtml:= ahtml.Substring(0, ahtml.IndexOf(HTABLEEND));
    ahtml:= ahtml.Substring(ahtml.IndexOf(HTBODY) + HTBODY.Length).Trim();

    strarr := ahtml.Split([HTBODY]);
    for i := 0 to Length(strarr) - 1 do begin
      tmp := strarr[i];
      while (True) do begin
        if (not tmp.Contains(HCARD)) then Break;
        ret += Format('{"limit":%d,', [i]);
        tmp := tmp.Substring(tmp.IndexOf(HCARD) + HCARD.Length).Trim;
        ret += Format('"color":"%s",', [tmp.Substring(0, tmp.IndexOf('"')).Trim]);
        tmp := tmp.Substring(tmp.IndexOf(HREFID) + HREFID.Length).Trim;
        ret += Format('"hashid":"%s",', [tmp.Substring(0, tmp.IndexOf('"')).Trim]);
        tmp := tmp.Substring(tmp.IndexOf(HTARGET) + HTARGET.Length).Trim;
        ret += Format('"name":"%s"},', [tmp.Substring(0, tmp.IndexOf(HAEND)).Trim]);
      end;
    end;

  end;
  ret := ret.TrimRight([',']);
  ret += ']}';
  Exit(ret);
end;

class function THtmlParser.getPackageList(ahtml: string): string;
const
  HDIV = '<div class="package-view package-list">';
  HSIDE = '<div class="sidebar-wrapper">';
  HH2 = '<h2>';
  HH2END = '</h2>';
  HLIREF = '<li><a href="';
  HAEND = '</a>';
var
  strarr: TStringArray;
  i: Integer;
  season: string;
  tmp: string;
  ret: string = '';
  namestr: string;
begin
  ret := '{"result":0, "data":[';
  // get package list
  ahtml:= ahtml.Substring(ahtml.IndexOf(HDIV) + HDIV.Length);
  ahtml:= ahtml.Substring(0, ahtml.IndexOf(HSIDE)).Trim;
  ahtml:= ahtml.Substring(ahtml.IndexOf(HH2) + HH2.Length);
  strarr := ahtml.Split([HH2]);
  for i := 0 to Length(strarr) - 1 do begin
    tmp := strarr[i];
    season:= tmp.Substring(0, tmp.IndexOf(HH2END)).Trim;
    while (True) do begin
      if (not tmp.Contains(HLIREF)) then Break;
      ret += Format('{"season":"%s",',  [season]);
      tmp := tmp.Substring(tmp.IndexOf(HLIREF) + HLIREF.Length).Trim;
      ret += Format('"url":"%s",', [tmp.Substring(0, tmp.IndexOf('"')).Trim]);
      tmp := tmp.Substring(tmp.IndexOf('>') + 1);
      namestr:= tmp.Substring(0, tmp.IndexOf(HAEND)).Trim;
      if (namestr.Contains('(')) then begin
        ret += Format('"name":"%s",', [namestr.Substring(0, namestr.IndexOf('(')).Trim]);
        namestr := namestr.Substring(namestr.IndexOf('(') + 1);
        ret += Format('"abbr":"%s"},', [namestr.Substring(0, namestr.IndexOf(')')).Trim]);
      end else begin
        ret += Format('"name":"%s","abbr":""},', [namestr.Trim]);
      end;
    end;
  end;
  ret := ret.TrimRight([',']);
  ret += ']}';
  Exit(ret);
end;

class function THtmlParser.getHotest(ahtml: string): string;
const
  HSEARCH = '<h3>热门搜索</h3>';
  HULEND = '</ul>';
  HSEARCHITEM = '<li class="el-button el-button--info is-plain el-button--small"><a href="';
  HAEND = '</a>';
  HCARD = '<h3 class="no-underline">热门卡片</h3>';
  HCARDITEM = '<li><a href="/card/';
  HPACK = '<h3 class="no-underline">热门卡包';
  HPACKITEM = '<li><a href="';
var
  htmlSearch: string;
  htmlCard: string;
  htmlPack: string;
  strSearch: string = '';
  strCard: string = '';
  strPackage: string = '';
  ret: string;
begin
  // hot search
  htmlSearch:= ahtml.Substring(ahtml.IndexOf(HSEARCH) + HSEARCH.Length);
  htmlSearch:= htmlSearch.Substring(0, htmlSearch.IndexOf(HULEND)).Trim;
  while True do begin
    if (not htmlSearch.Contains(HSEARCHITEM)) then Break;
    htmlSearch:= htmlSearch.Substring(htmlSearch.IndexOf(HSEARCHITEM) + HSEARCHITEM.Length).Trim;
    htmlSearch:= htmlSearch.Substring(htmlSearch.IndexOf('>') + 1).Trim;
    strSearch += Format('"%s",', [htmlSearch.Substring(0, htmlSearch.IndexOf(HAEND)).Trim]);
  end;
  strSearch:= strSearch.TrimRight([',']);

  // hot card
  htmlCard:= ahtml.Substring(ahtml.IndexOf(HCARD) + HCARD.Length);
  htmlCard:= htmlCard.Substring(0, htmlCard.IndexOf(HULEND)).Trim;
  while True do begin
    if (not htmlCard.Contains(HCARDITEM)) then Break;
    htmlCard:= htmlCard.Substring(htmlCard.IndexOf(HCARDITEM) + HCARDITEM.Length).Trim;
    strCard += Format('{"hashid":"%s",', [htmlCard.Substring(0, htmlCard.IndexOf('"')).Trim]);
    htmlCard:= htmlCard.Substring(htmlCard.IndexOf('>') + 1);
    strCard += Format('"name":"%s"},', [htmlCard.Substring(0, htmlCard.IndexOf(HAEND)).Trim]);
  end;
  strCard:= strCard.TrimRight([',']);

  // hot package
  htmlPack:= ahtml.Substring(ahtml.IndexOf(HPACK) + HPACK.Length);
  htmlPack:= htmlPack.Substring(0, htmlPack.IndexOf(HULEND)).Trim;
  while True do begin
    if (not htmlPack.Contains(HPACKITEM)) then Break;
    htmlPack:= htmlPack.Substring(htmlPack.IndexOf(HPACKITEM) + HPACKITEM.Length).Trim;
    strPackage += Format('{"packid":"%s",', [htmlPack.Substring(0, htmlPack.IndexOf('"')).Trim]);
    htmlPack:= htmlPack.Substring(htmlPack.IndexOf('>') + 1).Trim;
    strPackage += Format('"name":"%s"},', [htmlPack.Substring(0, htmlPack.IndexOf(HAEND)).Trim]);
  end;
  strPackage:= strPackage.TrimRight([',']);

  ret := Format('{"result":0, "search":[%s], "card":[%s], "pack":[%s]}', [strSearch, strCard, strPackage]);
  Exit(ret);
end;

class function THtmlParser.getAdjust(ahtml: string): string;
const
  ARTICLE_BEGIN = '<article class="detail">';
  ARTICLE_END = '</article>';
  ADJUST_BEGIN = '<div class="wiki" ID="adjust">';
  HSTRONG = '</strong>';
  HLI = '</li><li>';
  HLIEND = '</li>';
var
  ret: string = '';
begin
  // parse adjust
  if (ahtml.Contains(ARTICLE_BEGIN)) then begin
    ahtml := ahtml.Substring(ahtml.IndexOf(ARTICLE_BEGIN));
    ahtml := ahtml.Substring(0, ahtml.IndexOf(ARTICLE_END));
    if (ahtml.Contains(ADJUST_BEGIN)) then begin
      ahtml := ahtml.Substring(ahtml.IndexOf(ADJUST_BEGIN));
      ahtml := ahtml.Substring(ahtml.IndexOf(HSTRONG) + HSTRONG.Length);
      ahtml := ahtml.Substring(ahtml.IndexOf(HLI) + HLI.Length);
      ahtml := ahtml.Substring(0, ahtml.IndexOf(HLIEND)).Trim;
      ahtml := ahtml.Replace('<br />', '');
      ahtml := ahtml.Replace('&lt;', '<').Replace('&gt;', '>');
      ret := ahtml;
    end;
  end;
  Exit(ret);
end;

class function THtmlParser.getWiki(ahtml: string): string;
const
  HPREEND = '</pre>';
  HDIVEND = '</div>';
var
  ret: string = '';
begin
  // parse wiki
  if (ahtml.Contains(HPREEND)) then begin
    ahtml:= ahtml.Substring(ahtml.IndexOf(HPREEND) + HPREEND.Length);
    ahtml:= ahtml.Substring(0, ahtml.IndexOf(HDIVEND)).Trim;
    ret := ahtml;
  end;
  Exit(ret);
end;

end.


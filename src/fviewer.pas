{
   Seksi Commander
   ----------------------------
   Integrated viewer form

   Licence  : GNU GPL v 2.0
   Author   : radek.cervinka@centrum.cz

   contributors:

   Radek Polak
    ported to lazarus:
    changes:
     23.7.
        - fixed: scroll bar had wrong max value until user pressed key (by Radek Polak)
        - fixed: wrong scrolling with scroll bar - now look at ScrollBarVertScroll (by Radek Polak)

   Dmitry Kolomiets
   15.03.08
   changes:
     - Added WLX api support (TC WLX api v 1.8)

   Rustem Rakhimov
   25.04.10
   changes:
     - fullscreen
     - function for edit image
     - slide show
     - some Viwer function

}

unit fViewer;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls, ComCtrls, LMessages,
  LCLProc, Menus, Dialogs, ExtDlgs, StdCtrls, Buttons, ColorBox, Spin,
  Grids, ActnList, viewercontrol, GifAnim, fFindView, WLXPlugin, uWLXModule,
  uFileSource, fModView, Types, uThumbnails, uFormCommands, uOSForms,Clipbrd;

type

  TViewerCopyMoveAction=(vcmaCopy,vcmaMove);

  { TfrmViewer }

  TfrmViewer = class(TAloneForm, IFormCommands)
    actAbout: TAction;
    actCopyFile: TAction;
    actDeleteFile: TAction;
    actCopyToClipboard: TAction;
    actImageCenter: TAction;
    actFullscreen: TAction;
    actCopyToClipboardFormatted: TAction;
    actShowAsDec: TAction;
    actScreenShotDelay5sec: TAction;
    actScreenShotDelay3Sec: TAction;
    actScreenshot: TAction;
    actZoomOut: TAction;
    actZoomIn: TAction;
    actZoom: TAction;
    actStretchOnlyLarge: TAction;
    actFindNext: TAction;
    actShowGraphics: TAction;
    actExitViewer: TAction;
    actMirrorVert: TAction;
    actSave: TAction;
    actShowPlugins: TAction;
    actShowAsBook: TAction;
    actShowAsWrapText: TAction;
    actShowAsHex: TAction;
    actShowAsBin: TAction;
    actShowAsText: TAction;
    actPreview: TAction;
    actFindPrev: TAction;
    actFind: TAction;
    actSelectAll: TAction;
    actMirrorHorz: TAction;
    actRotate270: TAction;
    actRotate180: TAction;
    actRotate90: TAction;
    actSaveAs: TAction;
    actStretchImage: TAction;
    actMoveFile: TAction;
    actLoadPrevFile: TAction;
    actLoadNextFile: TAction;
    actReload: TAction;
    actionList: TActionList;
    btnCopyFile1: TSpeedButton;
    btnDeleteFile1: TSpeedButton;
    btnMoveFile1: TSpeedButton;
    btnNext1: TSpeedButton;
    btnPrev1: TSpeedButton;
    btnReload1: TSpeedButton;
    cbSlideShow: TCheckBox;
    ColorBoxPaint: TColorBox;
    ComboBoxWidth: TComboBox;
    ComboBoxPaint: TComboBox;
    DrawPreview: TDrawGrid;
    gboxPaint: TGroupBox;
    gboxView: TGroupBox;
    gboxSlideShow: TGroupBox;
    GifAnim: TGifAnim;
    memFolder: TMemo;
    pmiCopyFormatted: TMenuItem;
    miDec: TMenuItem;
    MenuItem2: TMenuItem;
    miScreenshot5sec: TMenuItem;
    miScreenshot3sec: TMenuItem;
    miScreenshotImmediately: TMenuItem;
    miReload: TMenuItem;
    miLookBook: TMenuItem;
    miDiv4: TMenuItem;
    miPreview: TMenuItem;
    miScreenshot: TMenuItem;
    miFullScreen: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    gboxHightlight: TGroupBox;
    Image: TImage;
    lblHightlight: TLabel;
    miZoomOut: TMenuItem;
    miZoomIn: TMenuItem;
    miRotate: TMenuItem;
    miMirror: TMenuItem;
    mi270: TMenuItem;
    mi180: TMenuItem;
    mi90: TMenuItem;
    miSearchPrev: TMenuItem;
    miPrint: TMenuItem;
    miSearchNext: TMenuItem;
    pnlFolder: TPanel;
    pnlPreview: TPanel;
    pnlEditFile: TPanel;
    PanelEditImage: TPanel;
    pmiSelectAll: TMenuItem;
    miDiv5: TMenuItem;
    pmiCopy: TMenuItem;
    pnlImage: TPanel;
    pnlText: TPanel;
    miDiv3: TMenuItem;
    miEncoding: TMenuItem;
    miPlugins: TMenuItem;
    miSeparator: TMenuItem;
    pmEditMenu: TPopupMenu;
    SavePictureDialog: TSavePictureDialog;
    sboxImage: TScrollBox;
    btnCutTuImage: TSpeedButton;
    btnResize: TSpeedButton;
    btnUndo: TSpeedButton;
    btnHightlight: TSpeedButton;
    btn270: TSpeedButton;
    btn90: TSpeedButton;
    btnMirror: TSpeedButton;
    btnZoomIn: TSpeedButton;
    btnZoomOut: TSpeedButton;
    btnReload: TSpeedButton;
    btnPaint: TSpeedButton;
    btnFullScreen: TSpeedButton;
    seTimeShow: TSpinEdit;
    btnRedEye: TSpeedButton;
    btnNext: TSpeedButton;
    btnPrev: TSpeedButton;
    btnMoveFile: TSpeedButton;
    btnDeleteFile: TSpeedButton;
    btnCopyFile: TSpeedButton;
    btnGifMove: TSpeedButton;
    btnGifToBmp: TSpeedButton;
    btnNextGifFrame: TSpeedButton;
    btnPrevGifFrame: TSpeedButton;
    Splitter: TSplitter;
    Status: TStatusBar;
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miPrev: TMenuItem;
    miNext: TMenuItem;
    miView: TMenuItem;
    miExit: TMenuItem;
    miImage: TMenuItem;
    miStretch: TMenuItem;
    miStretchOnlyLarge: TMenuItem;
    miCenter: TMenuItem;
    miText: TMenuItem;
    miBin: TMenuItem;
    miHex: TMenuItem;
    miWrapText: TMenuItem;
    miAbout: TMenuItem;
    miAbout2: TMenuItem;
    miDiv1: TMenuItem;
    miSearch: TMenuItem;
    miDiv2: TMenuItem;
    miGraphics: TMenuItem;
    miEdit: TMenuItem;
    miSelectAll: TMenuItem;
    miCopyToClipboard: TMenuItem;
    TimerScreenshot: TTimer;
    TimerViewer: TTimer;
    ViewerControl: TViewerControl;
    procedure actExecute(Sender: TObject);
    procedure btnCopyMoveFileClick(Sender: TObject);
    procedure btnCutTuImageClick(Sender: TObject);
    procedure btnDeleteFileClick(Sender: TObject);
    procedure btnFullScreenClick(Sender: TObject);
    procedure btnGifMoveClick(Sender: TObject);
    procedure btnGifToBmpClick(Sender: TObject);
    procedure btnPaintHightlight(Sender: TObject);
    procedure btnPrevGifFrameClick(Sender: TObject);
    procedure btnRedEyeClick(Sender: TObject);
    procedure btnResizeClick(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure DrawPreviewDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure DrawPreviewSelection(Sender: TObject; aCol, aRow: Integer);
    procedure DrawPreviewTopleftChanged(Sender: TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GifAnimMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GifAnimMouseEnter(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseEnter(Sender: TObject);
    procedure ImageMouseLeave(Sender: TObject);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ImageMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure miLookBookClick(Sender: TObject);
    procedure PanelEditImageMouseEnter(Sender: TObject);
    procedure pnlImageResize(Sender: TObject);

    procedure pnlTextMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sboxImageMouseEnter(Sender: TObject);
    procedure sboxImageMouseLeave(Sender: TObject);
    procedure sboxImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnNextGifFrameClick(Sender: TObject);
    procedure SplitterChangeBounds;
    procedure TimerScreenshotTimer(Sender: TObject);
    procedure TimerViewerTimer(Sender: TObject);
    procedure ViewerControlMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure frmViewerClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure miChangeEncodingClick(Sender:TObject);
    procedure ViewerControlMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ViewerControlMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ViewerPositionChanged(Sender:TObject);
    function  PluginShowFlags : Integer;
    procedure UpdateImagePlacement;

  private
    FileList: TStringList;
    iActiveFile,
    tmpX, tmpY,
    startX, startY, endX, endY,
    UndoSX, UndoSY, UndoEX, UndoEY,
    cas, i_timer:Integer;
    bAnimation,
    bImage,
    bPlugin,
    bQuickView,
    MDFlag,
    ImgEdit: Boolean;
    FThumbSize: TSize;
    FFindDialog:TfrmFindView;
    FFileSource: IFileSource;
    FLastSearchPos: PtrInt;
    tmp_all: TCustomBitmap;
    FModSizeDialog: TfrmModView;
    FThumbnailManager: TThumbnailManager;
    FBitmapList: TBitmapList;
    FCommands: TFormCommands;
    FZoomFactor: Double;

    //---------------------
    WlxPlugins:TWLXModuleList;
    ActivePlugin:Integer;
    //---------------------
    function GetListerRect: TRect;
    function CheckPlugins(const sFileName: String; bForce: Boolean = False): Boolean;
    function CheckGraphics(const sFileName:String):Boolean;
    function LoadGraphics(const sFileName:String): Boolean;
    procedure AdjustImageSize;
    procedure DoSearch(bQuickSearch: Boolean; bSearchBackwards: Boolean);
    procedure MakeTextEncodingsMenu;
    procedure ActivatePanel(Panel: TPanel);
    procedure ReopenAsTextIfNeeded;
    procedure CheckXY;
    procedure UndoTmp;
    procedure CreateTmp;
    procedure CutToImage;
    procedure Res(W, H: integer);
    procedure RedEyes;
    procedure SaveImageAs (Var sExt: String; senderSave: boolean; Quality: integer);
    procedure CreatePreview(FullPathToFile:string; index:integer; delete: boolean = false);

    property Commands: TFormCommands read FCommands implements IFormCommands;

  protected
    procedure WMSetFocus(var Message: TLMSetFocus); message LM_SETFOCUS;
    procedure UpdateGlobals;

  public
    constructor Create(TheOwner: TComponent; aFileSource: IFileSource; aQuickView: Boolean = False); overload;
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFile(const aFileName: String);
    procedure LoadNextFile(const aFileName: String);
    procedure LoadFile(iIndex:Integer);
    procedure ExitPluginMode;

    procedure SetNormalViewerFont;
    procedure CopyMoveFile(AViewerAction:TViewerCopyMoveAction);
    procedure RotateImage(AGradus:integer);
    procedure MirrorImage(AVertically:boolean=False);

  published
    // Commands for hotkey manager
    procedure cm_About(const Params: array of string);
    procedure cm_Reload(const Params: array of string);
    procedure cm_LoadNextFile(const Params: array of string);
    procedure cm_LoadPrevFile(const Params: array of string);
    procedure cm_MoveFile(const Params: array of string);
    procedure cm_CopyFile(const Params: array of string);
    procedure cm_DeleteFile(const Params: array of string);
    procedure cm_StretchImage(const Params: array of string);
    procedure cm_StretchOnlyLarge(const Params: array of string);
    procedure cm_Save(const Params:array of string);
    procedure cm_SaveAs(const Params: array of string);
    procedure cm_Rotate90(const Params: array of string);
    procedure cm_Rotate180(const Params: array of string);
    procedure cm_Rotate270(const Params: array of string);
    procedure cm_MirrorHorz(const Params: array of string);
    procedure cm_MirrorVert(const Params: array of string);
    procedure cm_ImageCenter(const Params: array of string);
    procedure cm_Zoom(const Params: array of string);
    procedure cm_ZoomIn(const Params: array of string);
    procedure cm_ZoomOut(const Params: array of string);
    procedure cm_Fullscreen(const Params: array of string);
    procedure cm_Screenshot(const Params: array of string);
    procedure cm_ScreenshotWithDelay(const Params: array of string);
    procedure cm_ScreenshotDelay3sec(const Params: array of string);
    procedure cm_ScreenshotDelay5sec(const Params: array of string);

    procedure cm_ChangeEncoding(const Params: array of string);
    procedure cm_CopyToClipboard (const Params: array of string);
    procedure cm_CopyToClipboardFormatted (const Params: array of string);
    procedure cm_SelectAll       (const Params: array of string);
    procedure cm_Find          (const Params: array of string);
    procedure cm_FindNext      (const Params: array of string);
    procedure cm_FindPrev      (const Params: array of string);

    procedure cm_Preview         (const Params: array of string);
    procedure cm_ShowAsText      (const Params: array of string);
    procedure cm_ShowAsBin       (const Params: array of string);
    procedure cm_ShowAsHex       (const Params: array of string);
    procedure cm_ShowAsDec       (const Params: array of string);
    procedure cm_ShowAsWrapText  (const Params: array of string);
    procedure cm_ShowAsBook      (const Params: array of string);

    procedure cm_ShowGraphics    (const Params: array of string);
    procedure cm_ShowPlugins     (const Params: array of string);

    procedure cm_ExitViewer      (const Params: array of string);

  end;

procedure ShowViewer(const FilesToView:TStringList; const aFileSource: IFileSource = nil);

implementation

{$R *.lfm}

uses
  FileUtil, IntfGraphics, Math, uLng, uShowMsg, uGlobs, LCLType, LConvEncoding,
  DCClassesUtf8, uFindMmap, DCStrUtils, uDCUtils, LCLIntf, uDebug, uHotkeyManager,
  uConvEncoding, DCBasicTypes, DCOSUtils, uOSUtils, uFindByrMr,
  fMain;

const
  HotkeysCategory = 'Viewer';

  // Status bar panels indexes.
  sbpFileName             = 0;
  sbpFileNr               = 1;
  // Text
  sbpPosition             = 2;
  sbpFileSize             = 3;
  sbpTextEncoding         = 4;
  // WLX
  sbpPluginName           = 2;
  // Graphics
  sbpCurrentResolution    = 2;
  sbpFullResolution       = 3;

procedure ShowViewer(const FilesToView:TStringList; const aFileSource: IFileSource);
var
  Viewer: TfrmViewer;
begin
  //DCDebug('ShowViewer - Using Internal');
  Viewer := TfrmViewer.Create(Application, aFileSource);
  Viewer.FileList.Assign(FilesToView);// Make a copy of the list
  Viewer.DrawPreview.RowCount:= Viewer.FileList.Count;
  with Viewer.ViewerControl do
  case gViewerMode of
    1: Mode:= vcmText;
    2: Mode:= vcmBin;
    3: Mode:= vcmHex;
    4: Mode:= vcmWrap;
    //5: Mode:= vcmBook;
  end;
  Viewer.LoadFile(0);
  Viewer.Show;

  if Viewer.miPreview.Checked then
    begin
      Viewer.miPreview.Checked := not(Viewer.miPreview.Checked);
      Viewer.cm_Preview(['']);
    end;
end;

constructor TfrmViewer.Create(TheOwner: TComponent; aFileSource: IFileSource;
  aQuickView: Boolean);
begin
  bQuickView:= aQuickView;
  inherited Create(TheOwner);
  FFileSource := aFileSource;
  FLastSearchPos := -1;
  FZoomFactor := 1.0;
  FThumbnailManager:= nil;
  if not bQuickView then Menu:= MainMenu;
  FBitmapList:= TBitmapList.Create(True);
  FCommands := TFormCommands.Create(Self, actionList);

  FontOptionsToFont(gFonts[dcfMain],memFolder.Font);
  memFolder.Color:=gBackColor;

//  This temporary code is for debug
  StartX:=0;
  StartY:=0;
  EndX:=Image.Width-1;
  EndY:=Image.Height-1;
//  CutToImage;


{
  tmp_all:= TBitmap.Create;
  tmp_all.Assign(Image.Picture.Graphic);

  Image.Picture.Bitmap.Canvas.Clear;
  Image.Picture.Bitmap.Canvas.Draw(0,0,tmp_all);
  UndoTmp;
}
//-----------------------------------

end;

constructor TfrmViewer.Create(TheOwner: TComponent);
begin
  Create(TheOwner, nil);
end;

destructor TfrmViewer.Destroy;
begin
  FreeThenNil(FileList);
  FreeThenNil(FThumbnailManager);
  inherited Destroy;
  FreeAndNil(WlxPlugins);
  FFileSource := nil; // If this is temp file source, the files will be deleted.
  tmp_all.Free;
end;

procedure TfrmViewer.LoadFile(const aFileName: String);
var
  i: Integer;
  aName: String;
  dwFileAttributes: TFileAttrs;
begin
  dwFileAttributes := mbFileGetAttr(aFileName);

  if dwFileAttributes = faInvalidAttributes then
  begin
    ShowMessage(rsMsgErrNoFiles);
    Exit;
  end;

  FLastSearchPos := -1;
  Caption := aFileName;

  if bQuickView then
  begin
    iActiveFile := 0;
    FileList.Text := aFileName;
  end;

  // Clear text on status bar.
  for i := 0 to Status.Panels.Count - 1 do
    Status.Panels[i].Text := '';

  Screen.Cursor:= crHourGlass;
  try
    if FPS_ISDIR(dwFileAttributes) then
      aName:= IncludeTrailingPathDelimiter(aFileName)
    else begin
      aName:= aFileName;
    end;
    if CheckPlugins(aName) then
      ActivatePanel(nil)
    else if FPS_ISDIR(dwFileAttributes) then
      begin
        ActivatePanel(pnlFolder);
        memFolder.Clear;
        memFolder.Lines.Add(rsPropsFolder + ': ');
        memFolder.Lines.Add(aFileName);
        memFolder.Lines.Add('');

      end
    else if CheckGraphics(aFileName) and LoadGraphics(aFileName) then
      ActivatePanel(pnlImage)
    else
      begin
        ViewerControl.FileName := aFileName;
        ActivatePanel(pnlText);
      end;

    Status.Panels[sbpFileName].Text:= aFileName;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TfrmViewer.LoadNextFile(const aFileName: String);
begin
  if bPlugin then
    with WlxPlugins.GetWlxModule(ActivePlugin) do
    begin
      if FileParamVSDetectStr(aFileName, False) then
      begin
        if CallListLoadNext(Self.Handle, aFileName, PluginShowFlags) <> LISTPLUGIN_ERROR then
          Exit;
      end;
    end;
  ExitPluginMode;
  ViewerControl.ResetEncoding;
  LoadFile(aFileName);
end;

procedure TfrmViewer.LoadFile(iIndex: Integer);
begin
  iActiveFile := iIndex;
  LoadFile(FileList.Strings[iIndex]);
  gboxPaint.Visible:=false;
  gboxHightlight.Visible:=false;
  Status.Panels[sbpFileNr].Text:=Format('%d/%d',[iIndex+1,FileList.Count]);
end;

procedure TfrmViewer.FormResize(Sender: TObject);
begin
  if bPlugin then WlxPlugins.GetWlxModule(ActivePlugin).ResizeWindow(GetListerRect);
end;

procedure TfrmViewer.FormShow(Sender: TObject);
begin
{$IF DEFINED(LCLGTK2)}
  if not pnlPreview.Visible then
  begin
    pnlPreview.Visible:= True;
    pnlPreview.Visible:= False;
  end;
{$ENDIF}
end;

procedure TfrmViewer.GifAnimMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then
  begin
    pmEditMenu.PopUp;
  end;
end;

procedure TfrmViewer.GifAnimMouseEnter(Sender: TObject);
begin
  if miFullScreen.Checked then TimerViewer.Enabled:=true;
end;

procedure TfrmViewer.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MDFlag := true;
  X:=round(X*Image.Picture.Width/Image.Width);                  // for correct paint after zoom
  Y:=round(Y*Image.Picture.Height/Image.Height);
  cas:=0;
    if (button = mbLeft) and gboxHightlight.Visible then
       begin
         if (X>StartX) and (X<=StartX+10) then
            begin
              if (Y>StartY) and (Y<=StartY+10) then begin
                                                 cas:=1;
                                                 tmpX:=X-StartX;
                                                 tmpY:=Y-StartY;
                                                 end;
              if (Y>StartY+10) and (Y<=EndY-10) then begin
                                                  cas:=2;
                                                  tmpX:=X-StartX;
                                                  end;
              if (Y>EndY-9) and (Y<=EndY) then begin
                                            cas:=3;
                                            tmpX:=X-StartX;
                                            tmpY:=EndY-Y;
                                            end;
              if (Y<StartY) or (Y>EndY) then cas:=0;
            end;
         if (X>StartX+10) and (X<=EndX-10) then
            begin
              if (Y>StartY) and (Y<=StartY+10) then begin
                                                    cas:=4;
                                                    tmpY:=Y-StartY;
                                                    end;
              if (Y>StartY+10) and (Y<=EndY-10)then begin
                                                    cas:=5;
                                                    tmpX:=X-StartX;
                                                    tmpY:=Y-StartY;
                                                    end;
              if (Y>EndY-9) and (Y<=EndY) then begin
                                               cas:=6;
                                               tmpY:=EndY-Y;
                                               end;
              If (Y<StartY) or (Y>EndY) then cas:=0;
            end;
         if (X>EndX-10) and (X<=EndX) then
            begin
              if (Y>StartY) and (Y<=StartY+10) then begin
                                                    cas:=7;
                                                    tmpX := EndX-X;
                                                    tmpY:=StartY-Y;
                                                    end;
              if (Y>StartY+10) and (Y<=EndY-10) then begin
                                                     cas:=8;
                                                     tmpX := EndX-X;
                                                     end;
              if (Y>EndY-9) and (Y<=EndY) then begin
                                               cas:=9;
                                               tmpX := EndX-X;
                                               tmpY:=EndY-Y;
                                               end;
              If (Y<StartY) or (Y>EndY) then cas:=0;
            end;
         if (X<StartX) or (X>EndX) then cas:=0;
        end;
    if Button=mbRight then
      begin
        pmEditMenu.PopUp;
      end;

    if cas=0 then
         begin
           StartX := X;
           StartY := Y;
         end;

    if gboxPaint.Visible then
      begin
        CreateTmp;
        Image.Picture.Bitmap.Canvas.MoveTo (x,y);
    end;
  if not (gboxHightlight.Visible) and not (gboxPaint.Visible) then
    begin
    tmpX:=x;
    tmpY:=y;
    Image.Cursor:=crHandPoint;
    end;
end;

procedure TfrmViewer.ImageMouseEnter(Sender: TObject);
begin
  if miFullScreen.Checked then TimerViewer.Enabled:=true;
end;

procedure TfrmViewer.ImageMouseLeave(Sender: TObject);
begin
  if miFullScreen.Checked then TimerViewer.Enabled:=false;
end;

procedure TfrmViewer.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  tmp: integer;
begin
  if gboxHightlight.Visible then Image.Cursor:=crCross;
  if miFullScreen.Checked then
    begin
      sboxImage.Cursor:=crDefault;
      Image.Cursor:=crDefault;
      i_timer:=0;
    end;
  X:=round(X*Image.Picture.Width/Image.Width);                      // for correct paint after zoom
  Y:=round(Y*Image.Picture.Height/Image.Height);
  if MDFlag then
        begin
      if gboxHightlight.Visible then
        begin
            if cas=0 then
            begin
              EndX:=X;
              EndY:=Y;
            end;
            if cas=1 then
            begin
              StartX:= X-tmpX;
              StartY:=Y-tmpY;
            end;
            if cas=2 then StartX:= X-tmpX;
            if cas=3then
            begin
              StartX:= X-tmpX;
              EndY:=Y+tmpY;
            end;
            if cas=4 then StartY:=Y-tmpY;
            if cas=5 then
            begin
              tmp:=EndX-StartX;
              StartX:= X-tmpX;
              EndX:=StartX+tmp;
              tmp:=EndY-StartY;
              StartY:= Y-tmpY;
              EndY:=StartY+tmp;
            end;
            if cas=6 then EndY:=Y+tmpY;
            if cas=7 then
            begin
              EndX:=X+tmpX;
              StartY:=Y-tmpY;
            end;
            if cas=8 then endX:=X+tmpX;
            if cas=9 then
            begin
              EndX:=X+tmpX;
              EndY:=Y+tmpY;
            end;
            if StartX<0 then
              begin
                StartX:=0;
                EndX:= UndoEX;
              end;
            if StartY<0 then
              begin
                StartY:=0;
                EndY:= UndoEY;
              end;
            if endX> Image.Picture.Width then endX:=Image.Picture.Width;
            if endY> Image.Picture.Height then endY:=Image.Picture.Height;
            with Image.Picture.Bitmap.Canvas do
              begin
                DrawFocusRect(Rect(UndoSX,UndoSY,UndoEX,UndoEY));
                DrawFocusRect(Rect(UndoSX+10,UndoSY+10,UndoEX-10,UndoEY-10));
                DrawFocusRect(Rect(StartX,StartY,EndX,EndY));
                DrawFocusRect(Rect(StartX+10,StartY+10,EndX-10,EndY-10));//Pen.Mode := pmNotXor;
                lblHightlight.Caption := IntToStr(EndX-StartX)+'x'+IntToStr(EndY-StartY);
                UndoSX:=StartX;
                UndoSY:=StartY;
                UndoEX:=EndX;
                UndoEY:=EndY;
              end;
          end;
        if gboxPaint.Visible then
        begin
          with Image.Picture.Bitmap.Canvas do
          begin
            Brush.Style:= bsClear;
            Pen.Width := StrToInt(ComboBoxWidth.Text);
            Pen.Color := ColorBoxPaint.Selected;
            Pen.Style := psSolid;
            tmp:= Pen.Width+10;
            if ComboBoxPaint.text='Pen' then LineTo (x,y)
            else
              begin
                if (startX>x) and (startY<y) then
                CopyRect (Rect(UndoSX+tmp,UndoSY-tmp,UndoEX-tmp,UndoEY+tmp), tmp_all.canvas,Rect(UndoSX+tmp,UndoSY-tmp,UndoEX-tmp,UndoEY+tmp));
                if (startX<x) and (startY>y) then
                CopyRect (Rect(UndoSX-tmp,UndoSY+tmp,UndoEX+tmp,UndoEY-tmp), tmp_all.canvas,Rect(UndoSX-tmp,UndoSY+tmp,UndoEX+tmp,UndoEY-tmp));
                if (startX>x) and (startY>y) then
                CopyRect (Rect(UndoSX+tmp,UndoSY+tmp,UndoEX-tmp,UndoEY-tmp), tmp_all.canvas,Rect(UndoSX+tmp,UndoSY+tmp,UndoEX-tmp,UndoEY-tmp))
                else
                CopyRect (Rect(UndoSX-tmp,UndoSY-tmp,UndoEX+tmp,UndoEY+tmp), tmp_all.canvas,Rect(UndoSX-tmp,UndoSY-tmp,UndoEX+tmp,UndoEY+tmp));//UndoTmp;
                if ComboBoxPaint.text='Rect' then Rectangle(Rect(StartX,StartY,X,Y))else Ellipse(StartX,StartY,X,Y);
              end;
            UndoSX:=StartX;
            UndoSY:=StartY;
            UndoEX:=X;
            UndoEY:=Y;
          end;
        end;
      if not (gboxHightlight.Visible) and not (gboxPaint.Visible) then
    begin
      sboxImage.VertScrollBar.Position:=sboxImage.VertScrollBar.Position+tmpY-y;
      sboxImage.HorzScrollBar.Position:=sboxImage.HorzScrollBar.Position+tmpX-x;
    end;
  end;
end;

procedure TfrmViewer.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  X:=round(X*Image.Picture.Width/Image.Width);             // for correct paint after zoom
  Y:=round(Y*Image.Picture.Height/Image.Height);
  MDFlag:=false;
  if PanelEditImage.Visible then
    begin
      if (button = mbLeft) and gboxHightlight.Visible then
    begin
      UndoTmp;
      CheckXY;
      with Image.Picture.Bitmap.Canvas do
      begin
        Brush.Style := bsClear;
        Pen.Style := psDot;
        Pen.Color := clHighlight;
        DrawFocusRect(Rect(StartX,StartY,EndX,EndY));
        DrawFocusRect(Rect(StartX+10,StartY+10,EndX-10,EndY-10));
        lblHightlight.Caption := IntToStr(EndX-StartX)+'x'+IntToStr(EndY-StartY);
      end;
    end;
    end;
  Image.Cursor:=crDefault;
end;

procedure TfrmViewer.ImageMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if ssCtrl in Shift then cm_Zoom(['0.9']);
end;

procedure TfrmViewer.ImageMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if ssCtrl in Shift then cm_Zoom(['1.1']);
end;

procedure TfrmViewer.miLookBookClick(Sender: TObject);
begin
  cm_ShowAsBook(['']);
//  miLookBook.Checked:=not miLookBook.Checked;
end;

procedure TfrmViewer.CreatePreview(FullPathToFile: string; index: integer;
  delete: boolean);
var
  bmpThumb : TBitmap = nil;
begin
  if pnlPreview.Visible or delete then
    begin
      if not Assigned(FThumbnailManager) then
        FThumbnailManager:= TThumbnailManager.Create(DrawPreview.Canvas.Brush.Color);
      if delete then
        begin
          FThumbnailManager.RemovePreview(FullPathToFile); // delete thumb if need
          if pnlPreview.Visible then FBitmapList.Delete(index);
        end
      else
        begin
          bmpThumb:= FThumbnailManager.CreatePreview(FullPathToFile);
          // Insert to the BitmapList
          FBitmapList.Insert(index, bmpThumb);
        end;
    end;
end;

procedure TfrmViewer.WMSetFocus(var Message: TLMSetFocus);
begin
  if bPlugin then WlxPlugins.GetWlxModule(ActivePlugin).SetFocus;
end;

procedure TfrmViewer.UpdateGlobals;
begin
  gViewerTop:=Top;
  gViewerLeft:=Left;
  gViewerWidth:=Width;
  gViewerHeight:=Height;
end;



procedure TfrmViewer.RedEyes;
var
  tmp:TBitMap;
  x,y,r,g,b: integer;
  col: TColor;
begin
  if (EndX=StartX) or (EndY=StartY) then Exit;
  UndoTmp;
  tmp:=TBitMap.Create;
  tmp.Width:= EndX-StartX;
  tmp.Height:= EndY-StartY;
  for x:=0 to (EndX-StartX) div 2 do
     begin
       for y:=0 to (EndY-StartY) div 2  do
          begin
          if y<round(sqrt((1-(sqr(x)/sqr((EndX-StartX)/2)))*sqr((EndY-StartY)/2))) then
            begin
            col:=Image.Picture.Bitmap.Canvas.Pixels[x+StartX+(EndX-StartX) div 2,y+StartY+(EndY-StartY) div 2];
            r:=GetRValue(col);
            g:=GetGValue(col);
            b:=GetBValue(col);
            if (r>100) and (g<100) and (b<100) then r:=b;
            tmp.Canvas.Pixels[x+(EndX-StartX) div 2,y+(EndY-StartY) div 2]:= rgb(r,g,b);

            col:=Image.Picture.Bitmap.Canvas.Pixels[StartX-x+(EndX-StartX) div 2,y+StartY+(EndY-StartY) div 2];
            r:=GetRValue(col);
            g:=GetGValue(col);
            b:=GetBValue(col);
            if (r>100) and (g<100) and (b<100) then r:=b;
            tmp.Canvas.Pixels[(EndX-StartX) div 2-x,y+(EndY-StartY) div 2]:= rgb(r,g,b);

            col:=Image.Picture.Bitmap.Canvas.Pixels[StartX+x+(EndX-StartX) div 2,StartY-y+(EndY-StartY) div 2];
            r:=GetRValue(col);
            g:=GetGValue(col);
            b:=GetBValue(col);
            if (r>100) and (g<100) and (b<100) then r:=b;
            tmp.Canvas.Pixels[(EndX-StartX) div 2+x,(EndY-StartY) div 2-y]:= rgb(r,g,b);

            col:=Image.Picture.Bitmap.Canvas.Pixels[StartX-x+(EndX-StartX) div 2,StartY-y+(EndY-StartY) div 2];
            r:=GetRValue(col);
            g:=GetGValue(col);
            b:=GetBValue(col);
            if (r>100) and (g<100) and (b<100) then r:=b;
            tmp.Canvas.Pixels[(EndX-StartX) div 2-x,(EndY-StartY) div 2-y]:= rgb(r,g,b);
          end
       else
          begin
            col:=Image.Picture.Bitmap.Canvas.Pixels[x+StartX+(EndX-StartX) div 2,y+StartY+(EndY-StartY) div 2];
            tmp.Canvas.Pixels[x+(EndX-StartX) div 2,y+(EndY-StartY) div 2]:= col;

            col:=Image.Picture.Bitmap.Canvas.Pixels[StartX-x+(EndX-StartX) div 2,y+StartY+(EndY-StartY) div 2];
            tmp.Canvas.Pixels[(EndX-StartX) div 2-x,y+(EndY-StartY) div 2]:= col;

            col:=Image.Picture.Bitmap.Canvas.Pixels[StartX+x+(EndX-StartX) div 2,StartY-y+(EndY-StartY) div 2];
            tmp.Canvas.Pixels[(EndX-StartX) div 2+x,(EndY-StartY) div 2-y]:= col;

            col:=Image.Picture.Bitmap.Canvas.Pixels[StartX-x+(EndX-StartX) div 2,StartY-y+(EndY-StartY) div 2];
            tmp.Canvas.Pixels[(EndX-StartX) div 2-x,(EndY-StartY) div 2-y]:= col;
          end;
          end;
     end;
  Image.Picture.Bitmap.Canvas.Draw (StartX,StartY,tmp);
  CreateTmp;
  tmp.Free;
end;

procedure TfrmViewer.CutToImage;
var
  w,h:integer;
begin
  UndoTmp;

  with Image.Picture.Bitmap do
  begin
    w:=EndX-StartX;
    h:=EndY-StartY;
    Canvas.CopyRect(rect(0,0,w,h), Image.Picture.Bitmap.Canvas, rect(startX,StartY,EndX,EndY));
    SetSize (w,h);
  end;
  Image.Width:=w;
  Image.Height:=h;

  CreateTmp;
  StartX:=0;StartY:=0;EndX:=0;EndY:=0;
end;

procedure TfrmViewer.UndoTmp;
begin
  Image.Picture.Bitmap.Canvas.Clear;
  Image.Picture.Bitmap.Canvas.Draw(0,0,tmp_all);
end;

procedure TfrmViewer.CreateTmp;
begin
  tmp_all.Free;
  tmp_all:= TBitmap.Create;
  tmp_all.Assign(Image.Picture.Graphic);
end;

procedure TfrmViewer.CheckXY;
var
  tmp: integer;
begin
  if EndX<StartX then
    begin
      tmp:=StartX;
      StartX:=EndX;
      EndX:=tmp
    end;
  if EndY<StartY then
    begin
      tmp:=StartY;
      StartY:=EndY;
      EndY:=tmp
    end;
end;

procedure TfrmViewer.Res (W, H: integer);
var
  tmp: TCustomBitmap;
  r: TRect;
begin
  if gboxHightlight.Visible then UndoTmp;
  tmp:= TBitmap.Create;
  tmp.Assign(Image.Picture.Graphic);
  r := Rect(0, 0, W, H);
  Image.Picture.Bitmap.SetSize(W,H);
  Image.Picture.Bitmap.Canvas.Clear;
  Image.Picture.Bitmap.Canvas.StretchDraw(r, tmp);
  tmp.free;
  CreateTmp;
  StartX:=0;
  StartY:=0;
  EndX:=0;
  EndY:=0;
end;

function TfrmViewer.PluginShowFlags : Integer;
begin
  Result:= IfThen(miStretch.Checked, lcp_fittowindow, 0) or
           IfThen(miCenter.Checked, lcp_center, 0) or
           IfThen(miStretchOnlyLarge.Checked, lcp_fitlargeronly, 0)
end;

function TfrmViewer.CheckPlugins(const sFileName: String; bForce: Boolean = False): Boolean;
var
  I: Integer;
  AFileName: String;
  ShowFlags: Integer;
  WlxModule: TWlxModule;
begin
  AFileName:= ExcludeTrailingBackslash(sFileName);
  ShowFlags:= IfThen(bForce, lcp_forceshow, 0) or PluginShowFlags;
  // DCDebug('WlXPlugins.Count = ' + IntToStr(WlxPlugins.Count));
  for I:= 0 to WlxPlugins.Count - 1 do
  if WlxPlugins.GetWlxModule(I).FileParamVSDetectStr(AFileName, bForce) then
  begin
    DCDebug('I = ' + IntToStr(I));
    if not WlxPlugins.LoadModule(I) then Continue;
    WlxModule:= WlxPlugins.GetWlxModule(I);
    DCDebug('WlxModule.Name = ', WlxModule.Name);
    if WlxModule.CallListLoad(Self.Handle, sFileName, ShowFlags) = 0 then
    begin
      WlxModule.UnloadModule;
      Continue;
    end;
    ActivePlugin:= I;
    WlxModule.ResizeWindow(GetListerRect);
    miPrint.Enabled:= WlxModule.CanPrint;
    // Set focus to plugin window
    if not bQuickView then WlxModule.SetFocus;
    Exit(True);
  end;
  // Plugin not found
  ActivePlugin:= -1;
  Result:= False;
end;

procedure TfrmViewer.ExitPluginMode;
begin
  if (WlxPlugins.Count > 0) and (ActivePlugin >= 0) then
  begin
    WlxPlugins.GetWlxModule(ActivePlugin).CallListCloseWindow;
  end;
  bPlugin:= False;
  ActivePlugin:= -1;
  miPrint.Enabled:= False;
end;

procedure TfrmViewer.SetNormalViewerFont;
begin
  if ViewerControl.Mode=vcmBook then
  begin
    with ViewerControl do
      begin
        Mode := vcmBook;
        Color:= gBookBackgroundColor;
        Font.Color:= gBookFontColor;
        Font.Quality:= fqAntialiased;
        ColCount:= gColCount;
        Position:= gTextPosition;
      end;
    FontOptionsToFont(gFonts[dcfViewerBook], ViewerControl.Font);
  end else
  begin
    with ViewerControl do
      begin
        Color:= clWindow;
        Font.Color:= clWindowText;
        Font.Quality:= fqDefault;
        ColCount:= 1;
      end;
    FontOptionsToFont(gFonts[dcfViewer], ViewerControl.Font);
  end;
end;


procedure TfrmViewer.CopyMoveFile(AViewerAction: TViewerCopyMoveAction);
begin
  FModSizeDialog:= TfrmModView.Create(Application);
  try
    FModSizeDialog.pnlQuality.Visible:= False;
    FModSizeDialog.pnlSize.Visible:= False;
    FModSizeDialog.pnlCopyMoveFile.Visible:= True;
    if AViewerAction = vcmaMove then
      FModSizeDialog.Caption:= rsDlgMv
    else
      FModSizeDialog.Caption:= rsDlgCp;
    if FModSizeDialog.ShowModal = mrOk then
    begin
      if FModSizeDialog.Path = '' then
        msgError(rsMsgInvalidPath)
      else
        begin
          CopyFile(FileList.Strings[iActiveFile],FModSizeDialog.Path+PathDelim+ExtractFileName(FileList.Strings[iActiveFile]));
          if AViewerAction = vcmaMove then
          begin
            CreatePreview(FileList.Strings[iActiveFile], iActiveFile, true);
            mbDeleteFile(FileList.Strings[iActiveFile]);
            FileList.Delete(iActiveFile);
            LoadFile(iActiveFile);
            DrawPreview.Repaint;
            SplitterChangeBounds;
          end;
        end;
    end;
  finally
    FreeAndNil(FModSizeDialog);
  end;
end;

procedure TfrmViewer.RotateImage(AGradus: integer);
// AGradus now supported only 90,180,270 values
var
  x, y: Integer;
  xWidth,
  yHeight: Integer;
  SourceImg: TLazIntfImage = nil;
  TargetImg: TLazIntfImage = nil;
begin
  TargetImg:= TLazIntfImage.Create(0, 0);
  SourceImg:= Image.Picture.Bitmap.CreateIntfImage;
  TargetImg.DataDescription:= SourceImg.DataDescription; // use the same image format
  xWidth:= Image.Picture.Bitmap.Width - 1;
  yHeight:= Image.Picture.Bitmap.Height - 1;

  if AGradus = 90 then
  begin
    TargetImg.SetSize(yHeight + 1, xWidth + 1);
    for y:= 0 to xWidth do
    begin
      for x:= 0 to yHeight do
      begin
        TargetImg.Colors[x, y]:= SourceImg.Colors[y, yHeight - x];
      end;
    end;
    x:= Image.Width;
    Image.Width:= Image.Height;
    Image.Height:= x;
  end;

  if AGradus = 180 then
  begin
    TargetImg.SetSize(xWidth + 1, yHeight + 1);
    for y:= 0 to yHeight do
    begin
      for x:= 0 to xWidth do
      begin
        TargetImg.Colors[x, y]:= SourceImg.Colors[xWidth - x, yHeight - y];
      end;
    end;
  end;

  if AGradus = 270 then
  begin
    TargetImg.SetSize(yHeight + 1, xWidth + 1);
    for y:= 0 to xWidth do
    begin
      for x:= 0 to yHeight do
      begin
        TargetImg.Colors[x, y]:= SourceImg.Colors[xWidth - y, x];
      end;
    end;
    x:= Image.Width;
    Image.Width:= Image.Height;
    Image.Height:= x;
  end;

  Image.Picture.Bitmap.LoadFromIntfImage(TargetImg);
  FreeThenNil(SourceImg);
  FreeThenNil(TargetImg);
  AdjustImageSize;
  CreateTmp;
end;

procedure TfrmViewer.MirrorImage(AVertically:boolean);
var
  x, y: Integer;
  xWidth,
  yHeight: Integer;
  SourceImg: TLazIntfImage = nil;
  TargetImg: TLazIntfImage = nil;
begin
  TargetImg:= TLazIntfImage.Create(0, 0);
  SourceImg:= Image.Picture.Bitmap.CreateIntfImage;
  TargetImg.DataDescription:= SourceImg.DataDescription; // use the same image format
  xWidth:= Image.Picture.Bitmap.Width - 1;
  yHeight:= Image.Picture.Bitmap.Height - 1;
  TargetImg.SetSize(xWidth + 1, yHeight + 1);

  if not AVertically then
    for y:= 0 to yHeight do
    begin
      for x:= 0 to xWidth do
      begin
        TargetImg.Colors[x, y]:= SourceImg.Colors[xWidth - x, y];
      end;
    end
  else
    for y:= 0 to yHeight do
    begin
      for x:= 0 to xWidth do
      begin
        TargetImg.Colors[x, y]:= SourceImg.Colors[ x,yHeight - y];
      end;
    end;


  Image.Picture.Bitmap.LoadFromIntfImage(TargetImg);
  FreeThenNil(SourceImg);
  FreeThenNil(TargetImg);
  AdjustImageSize;
  CreateTmp;
end;


procedure TfrmViewer.SaveImageAs(var sExt: String; senderSave: boolean; Quality: integer);
var
  sFileName: string;
  ico : TIcon = nil;
  jpg : TJpegImage = nil;
  pnm : TPortableAnyMapGraphic = nil;
  fsFileStream: TFileStreamEx = nil;
begin
  if senderSave then
    sFileName:= FileList.Strings[iActiveFile]
  else
    begin
      if not SavePictureDialog.Execute then Exit;
      sFileName:= ChangeFileExt(SavePictureDialog.FileName, sExt);
    end;

  try
    fsFileStream:= TFileStreamEx.Create(sFileName, fmCreate);
    if (sExt = '.jpg') or (sExt = '.jpeg') then
      begin
        jpg := TJpegImage.Create;
        try
          jpg.Assign(Image.Picture.Graphic);
          jpg.CompressionQuality := Quality;
          jpg.SaveToStream(fsFileStream);
        finally
          jpg.Free;
        end;
      end;
    if sExt = '.ico' then
      begin
        ico := TIcon.Create;
        try
          ico.Assign(Image.Picture.Graphic);
          ico.SaveToStream(fsFileStream);
        finally
          ico.Free;
        end;
      end;
    if sExt = '.pnm' then
      begin
        pnm := TPortableAnyMapGraphic.Create;
        try
          pnm.Assign(Image.Picture.Graphic);
          pnm.SaveToStream(fsFileStream);
        finally
          pnm.Free;
        end;
      end;
    if (sExt = '.png') or (sExt = '.bmp') then
      begin
        Image.Picture.SaveToStreamWithFileExt(fsFileStream, sExt);
      end;
  finally
    FreeThenNil(fsFileStream);
  end;
end;

procedure TfrmViewer.PanelEditImageMouseEnter(Sender: TObject);
begin
  if miFullScreen.Checked then PanelEditImage.Height:= 50;
end;

procedure TfrmViewer.pnlImageResize(Sender: TObject);
begin
  if bImage then AdjustImageSize;
end;


procedure TfrmViewer.pnlTextMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if Shift=[ssCtrl] then
  begin
    gFonts[dcfMain].Size:=gFonts[dcfMain].Size+1;
    pnlText.Font.Size:=gFonts[dcfMain].Size;
    pnlText.Repaint;
    Handled:=True;
    Exit;
  end;
end;

procedure TfrmViewer.sboxImageMouseEnter(Sender: TObject);
begin
  if miFullScreen.Checked then TimerViewer.Enabled:=true;
end;

procedure TfrmViewer.sboxImageMouseLeave(Sender: TObject);
begin
  if miFullScreen.Checked then TimerViewer.Enabled:=false;
end;

procedure TfrmViewer.sboxImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if miFullScreen.Checked then
  begin
    sboxImage.Cursor:=crDefault;
    Image.Cursor:=crDefault;
    i_timer:=0;
  end;
end;

procedure TfrmViewer.btnNextGifFrameClick(Sender: TObject);
begin
  GifAnim.Animate:=false;
  GifAnim.NextFrame;
end;

procedure TfrmViewer.SplitterChangeBounds;
begin
  if DrawPreview.Width div (DrawPreview.DefaultColWidth+6)>0 then
    DrawPreview.ColCount:= DrawPreview.Width div (DrawPreview.DefaultColWidth + 6);
  if FileList.Count mod DrawPreview.ColCount > 0 then
    DrawPreview.RowCount:= FileList.Count div DrawPreview.ColCount + 1
  else
    DrawPreview.RowCount:= FileList.Count div DrawPreview.ColCount;
  if bPlugin then WlxPlugins.GetWlxModule(ActivePlugin).ResizeWindow(GetListerRect);
end;

procedure TfrmViewer.TimerScreenshotTimer(Sender: TObject);
begin
  cm_Screenshot(['']);
  TimerScreenshot.Enabled:=False;
  Application.Restore;
  Self.BringToFront;
end;

procedure TfrmViewer.DrawPreviewDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  i,z,t, X, Y: Integer;
  sExt, sName, shortName: String;
  bmpThumb: TBitmap;
begin
  aRect:= Classes.Rect(aRect.Left + 2, aRect.Top + 2, aRect.Right - 2, aRect.Bottom - 2);
  i:= (aRow * DrawPreview.ColCount) + aCol; // Calculate FileList index
  if (i >= 0) and (i < FileList.Count) then
    begin
      sName:= ExtractOnlyFileName(FileList.Strings[i]);
      sExt:= ExtractFileExt(FileList.Strings[i]);
      DrawPreview.Canvas.FillRect(aRect); // Clear cell
      if (i >= 0) and (i < FBitmapList.Count) then
        begin
          bmpThumb:= FBitmapList[i];
          z:= DrawPreview.Canvas.TextHeight('Pp') + 4;
          X:= aRect.Left + (aRect.Right - aRect.Left - bmpThumb.Width) div 2;
          Y:= aRect.Top + (aRect.Bottom - aRect.Top - bmpThumb.Height - z) div 2;
          // Draw thumbnail at center
          DrawPreview.Canvas.Draw(X, Y, bmpThumb);
        end;
      z:= (DrawPreview.Width - DrawPreview.ColCount * DrawPreview.DefaultColWidth) div DrawPreview.ColCount div 2;
      if DrawPreview.Canvas.GetTextWidth(sName+sExt) < DrawPreview.DefaultColWidth then
        begin
          t:= (DrawPreview.DefaultColWidth-DrawPreview.Canvas.GetTextWidth(sName+sExt)) div 2;
          DrawPreview.Canvas.TextOut(aRect.Left+z+t, aRect.Top + FThumbSize.cy + 2, sName+sExt);
        end
      else
        begin
          shortName:= '';
          t:= 1;
          while DrawPreview.Canvas.GetTextWidth(shortName+'...'+sExt) < (DrawPreview.DefaultColWidth-15) do
            begin
              shortName:= shortName + sName[t];
              Inc(t);
            end;
          DrawPreview.Canvas.TextOut(aRect.Left+z, aRect.Top + FThumbSize.cy + 2, shortName+'...'+sExt);
        end;
    end;
end;

procedure TfrmViewer.DrawPreviewSelection(Sender: TObject; aCol, aRow: Integer);
var
  I: Integer;
begin
  gboxHightlight.Visible:= False;
  gboxPaint.Visible:= False;
  I:= DrawPreview.Row * DrawPreview.ColCount + DrawPreview.Col;
  if I < Filelist.Count then LoadNextFile(FileList.Strings[I]);
end;

procedure TfrmViewer.DrawPreviewTopleftChanged(Sender: TObject);
begin
  DrawPreview.LeftCol:= 0;
end;

procedure TfrmViewer.TimerViewerTimer(Sender: TObject);
begin
  if (miFullScreen.Checked) and (PanelEditImage.Height>3) then
  PanelEditImage.Height := PanelEditImage.Height-1;
  i_timer:=i_timer+1;
  if (cbSlideShow.Checked) and (i_timer=60*seTimeShow.Value) then
    begin
     cm_LoadNextFile([]);
     i_timer:=0;
    end;
  if i_timer=180 then
    begin
     sboxImage.Cursor:=crNone;
     Image.Cursor:=crNone;
    end;
end;


procedure TfrmViewer.ViewerControlMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    pmEditMenu.PopUp();
end;

procedure TfrmViewer.frmViewerClose(Sender: TObject;
                                    var CloseAction: TCloseAction);
begin
  if not miFullScreen.Checked then UpdateGlobals;
  CloseAction:=caFree;
  gImageStretch:= miStretch.Checked;
  gImageStretchOnlyLarge:= miStretchOnlyLarge.Checked;
  gImageCenter:= miCenter.Checked;
  gPreviewVisible := miPreview.Checked;
  gImagePaintMode := ComboBoxPaint.text;
  gImagePaintWidth := StrToInt(ComboBoxWidth.Text) ;
  gImagePaintColor := ColorBoxPaint.Selected;
  gTextPosition := ViewerControl.Position;
  case ViewerControl.Mode of
    vcmText: gViewerMode := 1;
    vcmBin : gViewerMode := 2;
    vcmHex : gViewerMode := 3;
    vcmWrap: gViewerMode := 4;
    vcmBook: gViewerMode := 4;
  end;

  if Assigned(WlxPlugins) then
     begin
       ExitPluginMode;
     end;
end;

procedure TfrmViewer.UpdateImagePlacement;
begin
  if bImage then
  begin
    if gboxHightlight.Visible then 
    begin
      gboxPaint.Visible:=false;
      gboxHightlight.Visible:=false;
      gboxView.Visible:=true;
      UndoTmp;
    end;
    AdjustImageSize;
  end
  else if bPlugin then
    WlxPlugins.GetWLxModule(ActivePlugin).CallListSendCommand(lc_newparams , PluginShowFlags)
end;

procedure TfrmViewer.FormCreate(Sender: TObject);
var
  HMViewer: THMForm;
begin
  if not bQuickView then InitPropStorage(Self);
  HMViewer := HotMan.Register(Self, HotkeysCategory);
  HMViewer.RegisterActionList(actionList);

  ViewerControl.OnGuessEncoding:= @DetectEncoding;

  FontOptionsToFont(gFonts[dcfViewer], ViewerControl.Font);

  FileList := TStringList.Create;

  WlxPlugins:=TWLXModuleList.Create;
  WlxPlugins.Assign(gWLXPlugins);
  DCDebug('WLX: Load - OK');

  FFindDialog:=nil; // dialog is created in first use
  
  sboxImage.DoubleBuffered := True;
  miStretch.Checked := gImageStretch;
  miStretchOnlyLarge.Checked := gImageStretchOnlyLarge;
  miCenter.Checked := gImageCenter;
  miPreview.Checked := gPreviewVisible;
  ComboBoxPaint.Text := gImagePaintMode;
  ComboBoxWidth.Text := IntToStr(gImagePaintWidth);
  ColorBoxPaint.Selected := gImagePaintColor;

  Image.Stretch:= True;
  Image.AutoSize:= False;
  Image.Proportional:= False;
  Image.SetBounds(0, 0, sboxImage.ClientWidth, sboxImage.ClientHeight);

  FThumbSize := gThumbSize;
  DrawPreview.DefaultColWidth := FThumbSize.cx + 4;
  DrawPreview.DefaultRowHeight := FThumbSize.cy + DrawPreview.Canvas.TextHeight('Pp') + 6;

  MakeTextEncodingsMenu;

  Status.Panels[sbpFileNr].Alignment := taRightJustify;
  Status.Panels[sbpPosition].Alignment := taRightJustify;
  Status.Panels[sbpFileSize].Alignment := taRightJustify;

  ViewerPositionChanged(Self);

  FixFormIcon(Handle);

  GifAnim.Align:=alClient;

  HotMan.Register(pnlText ,'Text files');
  HotMan.Register(pnlImage,'Image files');
end;

procedure TfrmViewer.btnCutTuImageClick(Sender: TObject);
begin
  CutToImage;
end;

procedure TfrmViewer.btnDeleteFileClick(Sender: TObject);
begin
  if msgYesNo(Format(rsMsgDelSel, [FileList.Strings[iActiveFile]])) then
    begin
      CreatePreview(FileList.Strings[iActiveFile], iActiveFile, true);
      mbDeleteFile(FileList.Strings[iActiveFile]);
      FileList.Delete(iActiveFile);
      LoadFile(iActiveFile);
      DrawPreview.Repaint;
      SplitterChangeBounds;
    end;
end;

procedure TfrmViewer.btnCopyMoveFileClick(Sender: TObject);
begin
  FModSizeDialog:= TfrmModView.Create(Application);
  try
    FModSizeDialog.pnlQuality.Visible:= False;
    FModSizeDialog.pnlSize.Visible:= False;
    FModSizeDialog.pnlCopyMoveFile.Visible:= True;
    if Sender = btnMoveFile then
      FModSizeDialog.Caption:= rsDlgMv
    else
      FModSizeDialog.Caption:= rsDlgCp;
    if FModSizeDialog.ShowModal = mrOk then
    begin
      if FModSizeDialog.Path = '' then
        msgError(rsMsgInvalidPath)
      else
        begin
          CopyFile(FileList.Strings[iActiveFile],FModSizeDialog.Path+PathDelim+ExtractFileName(FileList.Strings[iActiveFile]));
          if (Sender = btnMoveFile) or (Sender = btnMoveFile1) then
          begin
            CreatePreview(FileList.Strings[iActiveFile], iActiveFile, true);
            mbDeleteFile(FileList.Strings[iActiveFile]);
            FileList.Delete(iActiveFile);
            LoadFile(iActiveFile);
            DrawPreview.Repaint;
            SplitterChangeBounds;
          end;
        end;
    end;
  finally
    FreeAndNil(FModSizeDialog);
  end;
end;

procedure TfrmViewer.actExecute(Sender: TObject);
var
  cmd: string;
begin
  cmd := (Sender as TAction).Name;
  cmd := 'cm_' + Copy(cmd, 4, Length(cmd) - 3);
  Commands.ExecuteCommand(cmd, []);
end;

procedure TfrmViewer.btnFullScreenClick(Sender: TObject);
begin
  cm_Fullscreen(['']);
end;

procedure TfrmViewer.btnGifMoveClick(Sender: TObject);
begin
  GifAnim.Animate:=not GifAnim.Animate;
  btnNextGifFrame.Enabled:= not GifAnim.Animate;
  btnPrevGifFrame.Enabled:= not GifAnim.Animate;
  if GifAnim.Animate then btnGifMove.Caption:='||' else btnGifMove.Caption:='|>';
end;

procedure TfrmViewer.btnGifToBmpClick(Sender: TObject);
begin
  GifAnim.Animate:=False;
  Image.Picture.Bitmap.Create;
  Image.Picture.Bitmap.Width := GifAnim.Width;
  Image.Picture.Bitmap.Height := GifAnim.Height;
  Image.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,GifAnim.Width,GifAnim.Height),GifAnim.Canvas,Rect(0,0,GifAnim.Width,GifAnim.Height));
  cm_SaveAs(['']);
end;

procedure TfrmViewer.btnPaintHightlight(Sender: TObject);
var
  bmp: TCustomBitmap = nil;
  GraphicClass: TGraphicClass;
  sExt: String;
  fsFileStream: TFileStreamEx = nil;
begin
  if not ImgEdit then
    begin
    try
      sExt:= ExtractFileExt(FileList.Strings[iActiveFile]);
      fsFileStream:= TFileStreamEx.Create(FileList.Strings[iActiveFile], fmOpenRead or fmShareDenyNone);
      GraphicClass := GetGraphicClassForFileExtension(sExt);
      if (GraphicClass <> nil) and (GraphicClass.InheritsFrom(TCustomBitmap)) then
        begin
          Image.DisableAutoSizing;
          bmp := TCustomBitmap(GraphicClass.Create);
          bmp.LoadFromStream(fsFileStream);
          Image.Picture.Bitmap := TBitmap.Create;
          Image.Picture.Bitmap.Height:= bmp.Height;
          Image.Picture.Bitmap.Width:= bmp.Width;
          Image.Picture.Bitmap.Canvas.Draw(0, 0, bmp);
          Image.EnableAutoSizing;
        end;
    finally
      FreeThenNil(bmp);
      FreeThenNil(fsFileStream);
    end;
    {miStretch.Checked:= False;
    Image.Stretch:= miStretch.Checked;
    Image.Proportional:= Image.Stretch;
    Image.Autosize:= not(miStretch.Checked);
    AdjustImageSize; }
    end;
  if gboxHightlight.Visible then UndoTmp;
  if Sender = btnHightlight then
    begin
      gboxHightlight.Visible := not (gboxHightlight.Visible);
      gboxPaint.Visible:= False;
    end
  else
    begin
      gboxPaint.Visible:= not (gboxPaint.Visible);
      gboxHightlight.Visible:= False;
    end;
  ImgEdit:= True;
  CreateTmp;
end;

procedure TfrmViewer.btnPrevGifFrameClick(Sender: TObject);
begin
  GifAnim.Animate:=False;
  GifAnim.PriorFrame;
end;

procedure TfrmViewer.btnRedEyeClick(Sender: TObject);
begin
  RedEyes;
end;

procedure TfrmViewer.btnResizeClick(Sender: TObject);
begin
  FModSizeDialog:= TfrmModView.Create(Application);
  try
    FModSizeDialog.pnlQuality.Visible:=false;
    FModSizeDialog.pnlCopyMoveFile.Visible :=false;
    FModSizeDialog.pnlSize.Visible:=true;
    FModSizeDialog.teHeight.Text:= IntToStr(Image.Picture.Bitmap.Height);
    FModSizeDialog.teWidth.Text := IntToStr(Image.Picture.Bitmap.Width);
    FModSizeDialog.Caption:= rsViewNewSize;
    if FModSizeDialog.ShowModal = mrOk then
    begin
      Res(StrToInt(FModSizeDialog.teWidth.Text), StrToInt(FModSizeDialog.teHeight.Text));
      AdjustImageSize;
    end;
  finally
    FreeAndNil(FModSizeDialog);
  end;
end;

procedure TfrmViewer.btnUndoClick(Sender: TObject);
begin
  UndoTmp;
end;

procedure TfrmViewer.FormDestroy(Sender: TObject);
begin
  if Assigned(HotMan) then
  begin
    HotMan.UnRegister(pnlText);
    HotMan.UnRegister(pnlImage);
  end;


  FreeAndNil(FFindDialog);
  FreeAndNil(FBitmapList);
  HotMan.UnRegister(Self);
end;

procedure TfrmViewer.ReopenAsTextIfNeeded;
begin
  if bImage or bAnimation or bPlugin then
  begin
    Image.Picture := nil;
    ViewerControl.FileName := FileList.Strings[iActiveFile];
    ActivatePanel(pnlText);
  end;
end;

procedure TfrmViewer.miChangeEncodingClick(Sender: TObject);
begin
  cm_ChangeEncoding([(Sender as TMenuItem).Caption]);
end;

procedure TfrmViewer.ViewerControlMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if (Shift=[ssCtrl])and(gFonts[dcfViewer].Size>MIN_FONT_SIZE_VIEWER) then
  begin
    gFonts[dcfViewer].Size:=gFonts[dcfViewer].Size-1;
    ViewerControl.Font.Size:=gFonts[dcfViewer].Size;
    ViewerControl.Repaint;
    Handled:=True;
    Exit;
  end;
end;

procedure TfrmViewer.ViewerControlMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if (Shift=[ssCtrl])and(gFonts[dcfViewer].Size<MAX_FONT_SIZE_VIEWER) then
  begin
    gFonts[dcfViewer].Size:=gFonts[dcfViewer].Size+1;
    ViewerControl.Font.Size:=gFonts[dcfViewer].Size;
    ViewerControl.Repaint;
    Handled:=True;
    Exit;
  end;
end;

function TfrmViewer.CheckGraphics(const sFileName:String):Boolean;
var
  sExt: String;
{$IFDEF LCLGTK2}
  fsBitmap: TFileStreamEx = nil;
{$ENDIF}
begin
  sExt:= LowerCase(ExtractFileExt(sFileName));
  {$IFDEF LCLGTK2}
  // TImage crash on displaying monochrome bitmap on Linux/GTK2
  // See details at http://bugs.freepascal.org/view.php?id=12362
  if (sExt = '.bmp') then
  try
    fsBitmap:= TFileStreamEx.Create(sFileName, fmOpenRead or fmShareDenyNone);
    // Get the number of bits per pixel from bitmap header
    fsBitmap.Seek($1C, soFromBeginning);
    // Don't open monochrome bitmap as image
    if (fsBitmap.ReadWord = 1) then Exit(False);
  finally
    fsBitmap.Free;
  end;
  {$ENDIF}
  Result:= Image.Picture.FindGraphicClassWithFileExt(sExt, False) <> nil;
end;

// Adjust Image size (width and height) to sboxImage size
procedure TfrmViewer.AdjustImageSize;
const
  fmtImageInfo = '%dx%d (%.0f %%)';
var
  dScaleFactor : Double;
  iLeft, iTop, iWidth, iHeight : Integer;
begin
  if (Image.Picture=nil) then exit;
  if (Image.Picture.Width=0)or(Image.Picture.Height=0)then exit;

  dScaleFactor:= FZoomFactor;

  // Place and resize image
  if (miStretch.Checked) then
  begin
    dScaleFactor:= Min(sboxImage.ClientWidth / Image.Picture.Width ,sboxImage.ClientHeight / Image.Picture.Height);
    dScaleFactor:= IfThen((miStretchOnlyLarge.Checked) and (dScaleFactor > 1.0), 1.0, dScaleFactor);
  end;

  iWidth:= Trunc(Image.Picture.Width * dScaleFactor);
  iHeight:= Trunc(Image.Picture.Height * dScaleFactor);
  if (miCenter.Checked) then
  begin
    iLeft:= (sboxImage.ClientWidth - iWidth) div 2;
    iTop:= (sboxImage.ClientHeight - iHeight) div 2;
  end
  else
  begin
    iLeft:= 0;
    iTop:= 0;
  end;
  Image.SetBounds(Max(iLeft,0), Max(iTop,0), iWidth , iHeight);

  // Update scrollbars
  // TODO: fix - calculations are correct but it seems like scroll bars
  // are being updated only after a second call to Form.Resize
  if (iLeft < 0) then
    sboxImage.HorzScrollBar.Position:= -iLeft;
  if (iTop < 0) then
    sboxImage.VertScrollBar.Position:= -iTop;

  // Update status bar
  Status.Panels[sbpCurrentResolution].Text:= Format(fmtImageInfo, [iWidth,iHeight,  100.0 * dScaleFactor]);
  Status.Panels[sbpFullResolution].Text:= Format(fmtImageInfo, [Image.Picture.Width,Image.Picture.Height, 100.0]);
end;

function TfrmViewer.GetListerRect: TRect;
begin
  Result:= ClientRect;
  Dec(Result.Bottom, Status.Height);
  if Splitter.Visible then
  begin
    Inc(Result.Left, Splitter.Left + Splitter.Width);
  end;
end;

function TfrmViewer.LoadGraphics(const sFileName:String): Boolean;
var
  sExt: String;
  fsFileHandle: System.THandle;
  fsFileStream: TFileStreamEx = nil;
  gifHeader: array[0..5] of AnsiChar;
begin
  FZoomFactor:= 1.0;
  sExt:= ExtractOnlyFileExt(sFilename);
  if SameText(sExt, 'gif') then
  begin
    fsFileHandle:= mbFileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if (fsFileHandle = feInvalidHandle) then Exit(False);
    FileRead(fsFileHandle, gifHeader, SizeOf(gifHeader));
    FileClose(fsFileHandle);
  end;
  // GifAnim supports only GIF89a
  if gifHeader <> 'GIF89a' then
    begin
      Image.Visible:= True;
      GifAnim.Visible:= False;
      try
        fsFileStream:= TFileStreamEx.Create(sFileName, fmOpenRead or fmShareDenyNone);
        try
          Image.Picture.LoadFromStreamWithFileExt(fsFileStream, sExt);
          btnHightlight.Visible:= True;
          btnPaint.Visible:= True;
          btnResize.Visible:= True;
          miImage.Visible:= True;
          btnZoomIn.Visible:= True;
          btnZoomOut.Visible:= True;
          btn270.Visible:= True;
          btn90.Visible:= True;
          btnMirror.Visible:= True;
          btnGifMove.Visible:= False;
          btnGifToBmp.Visible:= False;
          btnNextGifFrame.Visible:= False;
          btnPrevGifFrame.Visible:= False;
        finally
          FreeAndNil(fsFileStream);
        end;
          AdjustImageSize;
      except
        Exit(False);
      end;
    end
  else
    begin
      GifAnim.Visible:= True;
      Image.Visible:= False;
      try
        GifAnim.FileName:= sFileName;
        btnHightlight.Visible:= False;
        btnPaint.Visible:= False;
        btnResize.Visible:= False;
        miImage.Visible:= False;
        btnZoomIn.Visible:= False;
        btnZoomOut.Visible:= False;
        btn270.Visible:= False;
        btn90.Visible:= False;
        btnMirror.Visible:= False;
        btnGifMove.Visible:= True;
        btnGifToBmp.Visible:= True;
        btnNextGifFrame.Visible:= True;
        btnPrevGifFrame.Visible:= True;
      except
        Exit(False);
      end;
    end;
  ImgEdit:= False;
end;

procedure TfrmViewer.DoSearch(bQuickSearch: Boolean; bSearchBackwards: Boolean);
var
  PAdr: PtrInt;
  PAnsiAddr: PByte;
  bTextFound: Boolean;
  sSearchTextU: String;
  sSearchTextA: AnsiString;
  iSearchParameter: Integer;
  RecodeTable: TRecodeTable;
begin
  // in first use create dialog
  if not Assigned(FFindDialog) then
     FFindDialog:= TfrmFindView.Create(Application);

  if (bQuickSearch and gFirstTextSearch) or not bQuickSearch then
    begin
      if bPlugin then
        begin
          // if plugin has specific search dialog
          if WlxPlugins.GetWLxModule(ActivePlugin).CallListSearchDialog(0) = LISTPLUGIN_OK then
            Exit;
        end;
      // Load search history
      FFindDialog.cbDataToFind.Items.Assign(glsSearchHistory);
      if FFindDialog.ShowModal <> mrOK then Exit;
      if FFindDialog.cbDataToFind.Text = '' then Exit;
      sSearchTextU:= FFindDialog.cbDataToFind.Text;
      // Save search history
      glsSearchHistory.Assign(FFindDialog.cbDataToFind.Items);
      gFirstTextSearch:= False;
    end
  else
    begin
      if bPlugin then
        begin
          // if plugin has specific search dialog
          if WlxPlugins.GetWLxModule(ActivePlugin).CallListSearchDialog(1) = LISTPLUGIN_OK then
            Exit;
        end;
      if glsSearchHistory.Count > 0 then
        sSearchTextU:= glsSearchHistory[0];
    end;

  if bPlugin then
    begin
      iSearchParameter:= 0;
      if FFindDialog.cbCaseSens.Checked then iSearchParameter:= lcs_matchcase;
      WlxPlugins.GetWLxModule(ActivePlugin).CallListSearchText(sSearchTextU, iSearchParameter);
    end
  else
    begin
      // Choose search start position.
      if not bSearchBackwards then
      begin
        if FLastSearchPos = -1 then
          FLastSearchPos := 0
        else if FLastSearchPos < ViewerControl.FileSize - 1 then
          FLastSearchPos := FLastSearchPos + 1;
      end
      else
      begin
        if FLastSearchPos = -1 then
          FLastSearchPos := ViewerControl.FileSize - 1
        else if FLastSearchPos > 0 then
          FLastSearchPos := FLastSearchPos - 1;
      end;

      sSearchTextA:= ViewerControl.ConvertFromUTF8(sSearchTextU);
      // Using standard search algorithm if case insensitive and multibyte
      if FFindDialog.cbCaseSens.Checked and (ViewerControl.Encoding in ViewerEncodingMultiByte) then
      begin
        PAnsiAddr := PosMem(ViewerControl.GetDataAdr, ViewerControl.FileSize,
                            FLastSearchPos, sSearchTextA,
                            FFindDialog.cbCaseSens.Checked, bSearchBackwards);
        bTextFound := (PAnsiAddr <> Pointer(-1));
        if bTextFound then FLastSearchPos := PAnsiAddr - ViewerControl.GetDataAdr;
      end
      // Using very slow search algorithm
      else if (ViewerControl.Encoding in ViewerEncodingMultiByte) or bSearchBackwards then
      begin
        PAdr := ViewerControl.FindUtf8Text(FLastSearchPos, sSearchTextU,
                                           FFindDialog.cbCaseSens.Checked,
                                           bSearchBackwards);
        bTextFound := (PAdr <> PtrInt(-1));
        if bTextFound then FLastSearchPos := PAdr;
      end
      // Using very fast Boyer–Moore search algorithm
      else begin
        RecodeTable:= InitRecodeTable(ViewerControl.EncodingName, FFindDialog.cbCaseSens.Checked);
        PAdr := PosMemBoyerMur(ViewerControl.GetDataAdr + FLastSearchPos,
                               ViewerControl.FileSize - FLastSearchPos, sSearchTextA, RecodeTable);
        bTextFound := (PAdr <> PtrInt(-1));
        if bTextFound then FLastSearchPos := PAdr + FLastSearchPos;
      end;

      if bTextFound then
        begin
          // Text found, show it in ViewerControl if not visible
          ViewerControl.MakeVisible(FLastSearchPos);
          // Select found text.
          ViewerControl.SelectText(FLastSearchPos, FLastSearchPos + Length(sSearchTextA));
        end
      else
        begin
          msgOK(Format(rsViewNotFound, ['"' + sSearchTextU + '"']));
          FLastSearchPos := -1;
        end;
    end;
end;

procedure TfrmViewer.MakeTextEncodingsMenu;
var
  I: Integer;
  mi: TMenuItem;
  EncodingsList: TStringList;
begin
  miEncoding.Clear;
  EncodingsList := TStringList.Create;
  try
    ViewerControl.GetSupportedEncodings(EncodingsList);
    for I:= 0 to EncodingsList.Count - 1 do
      begin
        mi:= TMenuItem.Create(miEncoding);
        mi.Caption:= EncodingsList[I];
        mi.AutoCheck:= True;
        mi.RadioItem:= True;
        mi.GroupIndex:= 1;
        mi.OnClick:= @miChangeEncodingClick;
        if ViewerControl.EncodingName = EncodingsList[I] then
          mi.Checked := True;
        miEncoding.Add(mi);
      end;
  finally
    FreeAndNil(EncodingsList);
  end;
end;

procedure TfrmViewer.ViewerPositionChanged(Sender:TObject);
begin
  if ViewerControl.FileSize > 0 then
    begin
      Status.Panels[sbpPosition].Text :=
          cnvFormatFileSize(ViewerControl.Position) +
          ' (' + IntToStr(ViewerControl.Percent) + ' %)';
    end
  else
    Status.Panels[sbpPosition].Text:= cnvFormatFileSize(0) + ' (0 %)';
end;

procedure TfrmViewer.ActivatePanel(Panel: TPanel);
var
  i:integer;
  b :boolean;
begin
  pnlFolder.Hide;
  pnlImage.Hide;
  pnlText.Hide;

  if Assigned(Panel) then Panel.Visible := True;

  if Panel = nil then
  begin
    Status.Panels[sbpPluginName].Text:= WlxPlugins.GetWLxModule(ActivePlugin).Name;
  end
  else if Panel = pnlText then
  begin
    if (not bQuickView) and CanFocus and ViewerControl.CanFocus then
       ViewerControl.SetFocus;

    case ViewerControl.Mode of
      vcmText: miText.Checked := True;
      vcmWrap: miWrapText.Checked := True;
      vcmBin:  miBin.Checked := True;
      vcmHex:  miHex.Checked := True;
      vcmDec:  miDec.Checked := True;
      vcmBook: miLookBook.Checked := True;
    end;

    Status.Panels[sbpFileSize].Text:= cnvFormatFileSize(ViewerControl.FileSize) + ' (100 %)';
    Status.Panels[sbpTextEncoding].Text := rsViewEncoding + ': ' + ViewerControl.EncodingName;
  end
  else if Panel = pnlImage then
  begin
    PanelEditImage.Visible:= not bQuickView;
    pnlImage.TabStop:=True;
    Self.ActiveControl:=pnlImage;
  end;


  bAnimation           := (GifAnim.Visible);
  bImage               := (Panel = pnlImage) and (bAnimation = False);
  bPlugin              := (Panel = nil);
  miPlugins.Checked    := (Panel = nil);
  miGraphics.Checked   := (Panel = pnlImage);
  miEncoding.Visible   := (Panel = pnlText);
  miEdit.Visible       := (Panel = pnlText) or (Panel = nil);
  miImage.Visible      := (bImage or bPlugin);
  miRotate.Visible     := bImage;
  miZoomIn.Visible     := bImage;
  miZoomOut.Visible    := bImage;
  miFullScreen.Visible := bImage;
  miScreenshot.Visible := bImage;
  miSave.Visible       := bImage;
  miSaveAs.Visible     := bImage;

  pmiSelectAll.Visible     := (Panel = pnlText);
  pmiCopyFormatted.Visible := (Panel = pnlText);




  WindowState:=wsNormal;
  Top   :=gViewerTop;
  Left  :=gViewerLeft;
  Width :=gViewerWidth;
  Height:=gViewerHeight;

end;

procedure TfrmViewer.cm_About(const Params: array of string);
begin
  MsgOK(rsViewAboutText);
end;

procedure TfrmViewer.cm_Reload(const Params: array of string);
begin
  LoadFile(iActiveFile);
end;

procedure TfrmViewer.cm_LoadNextFile(const Params: array of string);
var
  I : Integer;
begin
  I:= iActiveFile + 1;
  if I >= FileList.Count then
    I:= 0;

  if bPlugin then
  begin
    if (WlxPlugins.GetWlxModule(ActivePlugin).CallListLoadNext(Self.Handle, FileList[I], PluginShowFlags) <> LISTPLUGIN_ERROR) then
    Exit;
  end;
  ExitPluginMode;
  if pnlPreview.Visible then
    begin
      if DrawPreview.Col = DrawPreview.ColCount-1 then
        begin
          DrawPreview.Col:=0;
          DrawPreview.Row:= DrawPreview.Row+1;
        end
      else
        DrawPreview.Col:=DrawPreview.Col+1
    end
  else LoadFile(I);
end;

procedure TfrmViewer.cm_LoadPrevFile(const Params: array of string);
var
  I: Integer;
begin
  I:= iActiveFile - 1;
  if I < 0 then
    I:= FileList.Count - 1;

  if bPlugin then
  begin
    if (WlxPlugins.GetWlxModule(ActivePlugin).CallListLoadNext(Self.Handle, FileList[I], PluginShowFlags) <> LISTPLUGIN_ERROR) then
      Exit;

  end;
  if pnlPreview.Visible then
    begin
      if DrawPreview.Col = 0  then
        begin
          DrawPreview.Col:=DrawPreview.ColCount-1;
          DrawPreview.Row:= DrawPreview.Row-1;
        end
      else
        DrawPreview.Col:=DrawPreview.Col-1
    end
  else LoadFile(I);
end;




procedure TfrmViewer.cm_MoveFile(const Params: array of string);
begin
  CopyMoveFile(vcmaMove);
end;

procedure TfrmViewer.cm_CopyFile(const Params: array of string);
begin
  CopyMoveFile(vcmaCopy);
end;

procedure TfrmViewer.cm_DeleteFile(const Params: array of string);
begin
  btnDeleteFileClick(Self);
end;

procedure TfrmViewer.cm_StretchImage(const Params: array of string);
begin
  miStretch.Checked:=not miStretch.Checked;
  if bImage then
  begin
    if miStretch.Checked then
    begin
      FZoomFactor:= 1.0;
      UpdateImagePlacement;
    end else
    begin
      UpdateImagePlacement;
    end;
  end;
end;

procedure TfrmViewer.cm_StretchOnlyLarge(const Params: array of string);
begin
  miStretchOnlyLarge.Checked:= not miStretchOnlyLarge.Checked;
  UpdateImagePlacement;
end;

procedure TfrmViewer.cm_Save(const Params: array of string);
var
  sExt: String;
begin
  DrawPreview.BeginUpdate;
  try
    CreatePreview(FileList.Strings[iActiveFile], iActiveFile, True);
    sExt:= ExtractFileExt(FileList.Strings[iActiveFile]);
    SaveImageAs(sExt, True, 80);
    CreatePreview(FileList.Strings[iActiveFile], iActiveFile);
  finally
    DrawPreview.EndUpdate;
  end;
end;

procedure TfrmViewer.cm_SaveAs(const Params: array of string);
begin
  if bAnimation or bImage then
  begin
    FModSizeDialog:= TfrmModView.Create(Application);
    try
      FModSizeDialog.pnlSize.Visible:=false;
      FModSizeDialog.pnlCopyMoveFile.Visible :=false;
      FModSizeDialog.pnlQuality.Visible:=true;
      FModSizeDialog.Caption:= rsViewImageType;
      if FModSizeDialog.ShowModal = mrOk then
      begin
        if StrToInt(FModSizeDialog.teQuality.Text)<=100 then
          SaveImageAs(FModSizeDialog.sExt,false,StrToInt(FModSizeDialog.teQuality.Text))
        else
          msgError(rsViewBadQuality);
      end
    finally
      FreeAndNil(FModSizeDialog);
    end;
  end;
end;

procedure TfrmViewer.cm_Rotate90(const Params: array of string);
begin
  if bImage then RotateImage(90);
end;

procedure TfrmViewer.cm_Rotate180(const Params: array of string);
begin
  if bImage then RotateImage(180);
end;

procedure TfrmViewer.cm_Rotate270(const Params: array of string);
begin
  if bImage then RotateImage(270);
end;

procedure TfrmViewer.cm_MirrorHorz(const Params: array of string);
begin
  if bImage then MirrorImage;
end;

procedure TfrmViewer.cm_MirrorVert(const Params: array of string);
begin
  if bImage then MirrorImage(True);
end;

procedure TfrmViewer.cm_ImageCenter(const Params: array of string);
begin
   miCenter.Checked:= not miCenter.Checked;
   UpdateImagePlacement;
end;

procedure TfrmViewer.cm_Zoom(const Params: array of string);
var
  k:double;
begin
  try
    k:=StrToFloat(Params[0]);
  except
    exit;
  end;

  miStretch.Checked := False;
  FZoomFactor := FZoomFactor * k;
  AdjustImageSize;
end;

procedure TfrmViewer.cm_ZoomIn(const Params: array of string);
begin
  if miGraphics.Checked then
     cm_Zoom(['1.1'])
  else
  begin
    gFonts[dcfViewer].Size:=gFonts[dcfViewer].Size+1;
    ViewerControl.Font.Size:=gFonts[dcfViewer].Size;
    ViewerControl.Repaint;
  end;

end;

procedure TfrmViewer.cm_ZoomOut(const Params: array of string);
begin
  if miGraphics.Checked then
     cm_Zoom(['0.9'])
  else
  begin
    gFonts[dcfViewer].Size:=gFonts[dcfViewer].Size-1;
    ViewerControl.Font.Size:=gFonts[dcfViewer].Size;
    ViewerControl.Repaint;
  end;
end;

procedure TfrmViewer.cm_Fullscreen(const Params: array of string);
begin
  miFullScreen.Checked:= not (miFullScreen.Checked);
  if miFullScreen.Checked then
    begin
      UpdateGlobals;
      WindowState:= wsMaximized;
      BorderStyle:= bsNone;
      MainMenu.Items.Visible:=false;       // it sometime not work by unknown reason
      MainMenu.Parent:=nil;                // so now we have no choice and workaround it by this trick
      gboxPaint.Visible:= false;
      gboxHightlight.Visible:=false;
      miStretch.Checked:= miFullScreen.Checked;
      if miPreview.Checked then
         cm_Preview(['']);
    end
  else
    begin
      MainMenu.Parent:=Self;            // workaround code to attach detached menu

      WindowState:= wsNormal;
      BorderStyle:= bsSizeable;
      //Viewer.MainMenu.Items.Visible:=true;            // why it work ???

      Left  :=gViewerLeft;
      Top   :=gViewerTop;
      Width :=gViewerWidth;
      Height:=gViewerHeight;

      PanelEditImage.Height:= 50;
      if (Left+Width>Screen.Width)or(Top+Height>Screen.Height) then  // if looks bad - correct size
      begin
        Width :=Screen.Width -Left-10;
        Height:=Screen.Height-Top -10;
        gViewerWidth:=Width;
        gViewerHeight:=Height;
      end;

    end;
  if ExtractOnlyFileExt(FileList.Strings[iActiveFile]) <> 'gif' then
    begin
      btnHightlight.Visible:=not(miFullScreen.Checked);
      btnPaint.Visible:=not(miFullScreen.Checked);
      btnResize.Visible:=not(miFullScreen.Checked);
    end;
  sboxImage.HorzScrollBar.Visible:= not(miFullScreen.Checked);
  sboxImage.VertScrollBar.Visible:= not(miFullScreen.Checked);
  TimerViewer.Enabled:=miFullScreen.Checked;
  btnReload.Visible:=not(miFullScreen.Checked);
  Status.Visible:=not(miFullScreen.Checked);
  gboxSlideShow.Visible:=miFullScreen.Checked;
  AdjustImageSize;
  ShowOnTop;
end;

procedure TfrmViewer.cm_Screenshot(const Params: array of string);
var
  ScreenDC: HDC;
  bmp: TCustomBitmap;
begin
  Visible:= False;
  Application.ProcessMessages; // Hide viewer window
  bmp := TBitmap.Create;
  ScreenDC := GetDC(0);
  bmp.LoadFromDevice(ScreenDC);
  ReleaseDC(0, ScreenDC);
  Image.Picture.Bitmap.Height:= bmp.Height;
  Image.Picture.Bitmap.Width:= bmp.Width;
  Image.Picture.Bitmap.Canvas.Draw(0, 0, bmp);
  CreateTmp;
  bmp.Free;
  Visible:= True;
  ImgEdit:= True;
end;

procedure TfrmViewer.cm_ScreenshotWithDelay(const Params: array of string);
var
  i:integer;
begin
  i:=StrToInt(Params[0]);
  i:=i*1000;
  TimerScreenshot.Interval:=i;
  TimerScreenshot.Enabled:=True;
end;

procedure TfrmViewer.cm_ScreenshotDelay3sec(const Params: array of string);
begin
  cm_ScreenshotWithDelay(['3']);
end;

procedure TfrmViewer.cm_ScreenshotDelay5sec(const Params: array of string);
begin
  cm_ScreenshotWithDelay(['5']);
end;

procedure TfrmViewer.cm_ChangeEncoding(const Params: array of string);
begin
  ViewerControl.EncodingName := Params[0];
  Status.Panels[4].Text := rsViewEncoding + ': ' + ViewerControl.EncodingName;
  miEncoding.Find(ViewerControl.EncodingName).Checked:=True;
end;

procedure TfrmViewer.cm_CopyToClipboard(const Params: array of string);
begin
  if bPlugin then
   WlxPlugins.GetWLxModule(ActivePlugin).CallListSendCommand(lc_copy, 0)
  else begin
    if (miGraphics.Checked)and(Image.Picture<>nil)and(Image.Picture.Bitmap<>nil)then
    begin
      if not bAnimation then
        Clipboard.Assign(Image.Picture)
      else
        Clipboard.Assign(GifAnim.GifBitmaps[GifAnim.GifIndex].Bitmap);
    end else
       ViewerControl.CopyToClipboard;

  end;

end;

procedure TfrmViewer.cm_CopyToClipboardFormatted(const Params: array of string);
begin
  ViewerControl.CopyToClipboardF;
end;

procedure TfrmViewer.cm_SelectAll(const Params: array of string);
begin
  if bPlugin then
     WlxPlugins.GetWLxModule(ActivePlugin).CallListSendCommand(lc_selectall, 0)
  else
      ViewerControl.SelectAll;
end;

procedure TfrmViewer.cm_Find(const Params: array of string);
begin
  //if (not (bImage or bAnimation)) then
  if not miGraphics.Checked then
  begin
    FLastSearchPos := -1;
    DoSearch(False, False);
  end;
end;

procedure TfrmViewer.cm_FindNext(const Params: array of string);
begin
  DoSearch(True, False);
end;

procedure TfrmViewer.cm_FindPrev(const Params: array of string);
begin
  DoSearch(True, True);
end;

procedure TfrmViewer.cm_Preview(const Params: array of string);
var
  i: integer;
begin
  miPreview.Checked:= not (miPreview.Checked);
  pnlPreview.Visible := miPreview.Checked;
  Splitter.Visible := pnlPreview.Visible;
  if not pnlPreview.Visible then
    FBitmapList.Clear;
  Application.ProcessMessages;
  if miPreview.Checked then
   begin
     for i:=0 to FileList.Count-1 do
     CreatePreview(FileList.Strings[i], i);
     DrawPreview.FixedRows:= 0;
     DrawPreview.FixedCols:= 0;
     DrawPreview.Refresh;
   end;
  if bPlugin then WlxPlugins.GetWlxModule(ActivePlugin).ResizeWindow(GetListerRect);
end;

procedure TfrmViewer.cm_ShowAsText(const Params: array of string);
begin
  ViewerControl.Mode := vcmText;
  SetNormalViewerFont;
  ExitPluginMode;
  ReopenAsTextIfNeeded;
  ActivatePanel(pnlText);
end;

procedure TfrmViewer.cm_ShowAsBin(const Params: array of string);
begin
  ViewerControl.Mode := vcmBin;
  SetNormalViewerFont;
  ExitPluginMode;
  ReopenAsTextIfNeeded;
  ActivatePanel(pnlText);
end;

procedure TfrmViewer.cm_ShowAsHex(const Params: array of string);
begin
  ViewerControl.Mode := vcmHex;
  SetNormalViewerFont;
  ExitPluginMode;
  ReopenAsTextIfNeeded;
  ActivatePanel(pnlText);
end;

procedure TfrmViewer.cm_ShowAsDec(const Params: array of string);
begin
  ViewerControl.Mode := vcmDec;
  SetNormalViewerFont;
  ExitPluginMode;
  ReopenAsTextIfNeeded;
  ActivatePanel(pnlText);
end;

procedure TfrmViewer.cm_ShowAsWrapText(const Params: array of string);
begin
  ViewerControl.Mode := vcmWrap;
  SetNormalViewerFont;
  ExitPluginMode;
  ReopenAsTextIfNeeded;
  ActivatePanel(pnlText);
end;

procedure TfrmViewer.cm_ShowAsBook(const Params: array of string);
begin
  ViewerControl.Mode := vcmBook;
  SetNormalViewerFont;
  ExitPluginMode;
  ReopenAsTextIfNeeded;
  ActivatePanel(pnlText);
end;

procedure TfrmViewer.cm_ShowGraphics(const Params: array of string);
begin
  if CheckGraphics(FileList.Strings[iActiveFile]) then
    begin
      ViewerControl.FileName := ''; // unload current file if any is loaded
      if LoadGraphics(FileList.Strings[iActiveFile]) then
        ActivatePanel(pnlImage)
      else
        begin
          ViewerControl.FileName := FileList.Strings[iActiveFile];
          ActivatePanel(pnlText);
        end;
    end;
end;

procedure TfrmViewer.cm_ShowPlugins(const Params: array of string);
begin
  bPlugin:= CheckPlugins(FileList.Strings[iActiveFile], True);
  if bPlugin then
    ActivatePanel(nil)
  else
    ViewerControl.FileName := FileList.Strings[iActiveFile];
end;

procedure TfrmViewer.cm_ExitViewer(const Params: array of string);
begin
     Close;
end;

initialization
  TFormCommands.RegisterCommandsForm(TfrmViewer, HotkeysCategory, @rsHotkeyCategoryViewer);

end.


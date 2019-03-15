unit ListViewAdd;
// TListView additional functional

{$mode objfpc}{$H+}

interface

uses
  {$ifdef mswindows}
  Windows, CommCtrl, Win32Proc,
  {$endif}
  Classes, SysUtils, Controls, ComCtrls;

type

  { TListView }

  TListView = class(ComCtrls.TListView)
  {$ifdef mswindows}
  private
    OldParentProc  : TParentMsgHandlerProc;
  public
    procedure CreateHandle; override;
  {$endif}
  private
    fOnAfterScroll : TNotifyEvent;
  protected
    procedure DoAfterScroll;
  published
    property OnAfterScroll : TNotifyEvent read fOnAfterScroll write fOnAfterScroll;
  end;

procedure SyncListViewTop(master, slave: TListView);

implementation

{$ifdef mswindows}
function WMNotifyListView(const AWinControl: TWinControl; Window: HWnd;
      Msg: UInt; WParam: Windows.WParam; LParam: Windows.LParam;
      var MsgResult: Windows.LResult; var WinProcess: Boolean): Boolean;
var
  lv : TListView;
begin
  Result := false;
  if not (AWinControl is TListView) then Exit;

  lv := TListView(AWinControl);
  case PtrInt(PNMHdr(LParam)^.code) of
    LVN_ENDSCROLL: lv.DoAfterScroll;
  else
    if Assigned(lv.OldParentProc) then
      Result := lv.OldParentProc(AWinControl, Window, Msg, WParam, LParam, MsgResult, WinProcess);
  end;
end;

procedure SyncListViewTop(master, slave: TListView);
var
  mi, si: integer;
  r: TRECT;
begin
  mi:=SendMessage(master.Handle, LVM_GETTOPINDEX, 0, 0);
  si:=SendMessage(slave.Handle, LVM_GETTOPINDEX, 0, 0);
  if mi<>si then begin
    r.left := LVIR_BOUNDS;
    SendMessage(slave.Handle, LVM_GETITEMRECT, 0, PtrUInt(@r));
    SendMessage(slave.Handle, LVM_SCROLL, 0, (mi-si)*(r.Bottom-r.Top));
  end;
end;

{ TListView }

procedure TListView.CreateHandle;
var
  info : PWin32Windowinfo;
begin
  inherited CreateHandle;
  info := GetWin32WindowInfo(Handle);
  OldParentProc := info^.ParentMsgHandler;
  info^.ParentMsgHandler := @WMNotifyListView;
end;

{$else}
procedure SyncListViewTop(master, slave: TListView);
begin
  //todo:
end;
{$endif}


procedure TListView.DoAfterScroll;
begin
  if Assigned(OnAfterScroll) then OnAfterScroll(Self);
end;

end.

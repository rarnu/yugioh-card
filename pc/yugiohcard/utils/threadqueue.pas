unit threadqueue;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type

  TThreads = specialize TFPGList<TThread>;
  TThreadTerminates = specialize TFPGList<TNotifyEvent>;

  { TThreadQueue }
  TThreadQueue = class
  private
    FOnAllThreadCompleted: TNotifyEvent;
    FRunning: Boolean;
    FThreads: TThreads;
    FThreadTerminates: TThreadTerminates;
    procedure onPoolThreadTerminated(Sender: TObject);
    procedure runOneThread();
  public
    procedure AddThread(t: TThread);
    procedure DeleteThread(t: TThread);
    procedure DeleteThread(idx: Integer);
    constructor Create;
    destructor Destroy; override;
  public
    property OnAllThreadCompleted: TNotifyEvent read FOnAllThreadCompleted write FOnAllThreadCompleted;
  end;

implementation

{ TThreadQueue }

procedure TThreadQueue.onPoolThreadTerminated(Sender: TObject);
var
  n: TNotifyEvent;
begin
  n := FThreadTerminates[0];
  if (n <> nil) then begin
    n(Sender);
  end;
  DeleteThread(0);
  FRunning := False;
  if (FThreads.Count > 0) then begin
    runOneThread();
  end else begin
    if (Assigned(FOnAllThreadCompleted)) then begin
      FOnAllThreadCompleted(Self);
    end;
  end;
end;

procedure TThreadQueue.runOneThread();
var
  t: TThread;
begin
  FRunning:= True;
  t := FThreads[0];
  t.Start;
end;

procedure TThreadQueue.AddThread(t: TThread);
var
  n: TNotifyEvent;
begin
  n := t.OnTerminate;
  t.OnTerminate:=@onPoolThreadTerminated;
  FThreads.Add(t);
  FThreadTerminates.Add(n);
  if (not FRunning) then begin
    runOneThread();
  end;
end;

procedure TThreadQueue.DeleteThread(t: TThread);
var
  idx: Integer;
begin
  idx := FThreads.IndexOf(t);
  if (idx <> -1) then begin
    FThreads.Delete(idx);
    FThreadTerminates.Delete(idx);
  end;
end;

procedure TThreadQueue.DeleteThread(idx: Integer);
begin
  FThreadTerminates.Delete(idx);
  FThreads.Delete(idx);
end;

constructor TThreadQueue.Create;
begin
  FRunning := False;
  FThreads := TThreads.Create;
  FThreadTerminates := TThreadTerminates.Create;
end;

destructor TThreadQueue.Destroy;
begin
  FThreadTerminates.Free;
  FThreads.Free;
  inherited Destroy;
end;

end.


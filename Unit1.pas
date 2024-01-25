unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  mormot.orm.core,
  mormot.rest.http.server,
  mormot.rest.core,
  mormot.rest.sqlite3,
  mormot.db.raw.sqlite3,
  mormot.core.base,
  mormot.db.raw.sqlite3.static,
  mormot.db.sql,
  mormot.core.log, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    EditSQL: TEdit;
    CheckLog: TCheckBox;
    Test: TButton;
    CheckUseTSQLDB: TCheckBox;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TestClick(Sender: TObject);
    procedure CheckLogClick(Sender: TObject);
  private
   Model: TOrmModel; // TSQLModel;
    Server: TRestHttpServer;//TSQLHttpServer;
    defaultBatchCmdCount:Integer;
    DB,DB2: TRestServerDB;

    procedure createsomedata;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
 uses BetStruct,gethttputils2;
{$R *.dfm}
var
 UseTSQLDB:boolean;

procedure IntSQLFuncTestData(Context: TSQLite3FunctionContext;
  argc: integer; var argv: TSQLite3ValueArray); {$ifndef SQLITE3_FASTCALL}cdecl;{$endif}
var
 aEvent_id,game_id,aLimit:Integer;
 aLang,aGameGroup:RawUTF8;
 aResult:RawUTF8;
begin
 //GetGameDataLock.Acquire;
 //try
  aEvent_id :=  sqlite3.value_int64 (argv[0]);

  if argc<>1 then begin
    ErrorWrongNumberOfArgs(Context,'IntSQLFuncTestData');
    exit;
  end;

   if UseTSQLDB then       //rare error
    aResult:=  TRestServerDB(Form1.DB).DB.ExecuteJson(
     'select count(*) as cc from wsbet_events where event_id='+IntToStr(aevent_id)+';')
   else                    // error with iterations
    aResult:=  TRestServerDB(Form1.DB).ExecuteJson([],
   'select count(*) as cc from wsbet_events where event_id='+IntToStr(aevent_id)+';');


    if Pos('"rowCount":0',aResult)>0  then
      aResult:='{}';
    RawUtf8ToSQlite3Context(aResult,Context,false);
//  finally
//  GetGameDataLock.Release;
// end;

end;

procedure TForm1.TestClick(Sender: TObject);
var
 resulttext:String;
 aEvent:TSQLBET_EVENTS;
begin
  UseTSQLDB  := CheckUseTSQLDB.Checked;

  GetHttpRequest2('http://127.0.0.1:'+Edit1.Text+'/root?sql='+Editsql.Text,resulttext);
  memo1.Lines.Add('===='+ EditSQL.Text+'     executejson on TSQLDB '+boolToStr(UseTSQLDB,true));
  memo1.Lines.Add(resulttext);
  memo1.Lines.Add(' time '+ DatetimetoStr(now));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 try
  Screen.Cursor:=crHourGlass;
  if not assigned(Model) then
   Model:=CreateBetDataModel;

  DB := TRestServerDB.Create(Model,':memory:');   // ??

  TRestServerDB(DB).DB.RegisterSQLFunction(IntSQLFuncTestData,1,'testget');
  TRestServerDB(DB).CreateMissingTables;

  TRestServerDB(DB).NoAJAXJSON := false; // expanded json

  Server := TRestHttpServer.Create(Edit1.Text,[TRestServerDB(DB)],'+',HTTP_DEFAULT_MODE);

  createsomedata;
 finally
  Screen.Cursor:= crDefault;
 end;

end;

procedure TForm1.CheckLogClick(Sender: TObject);
begin
  if CheckLog.Checked  then
   SynDBLog.Family.Level := LOG_VERBOSE
{   DB.LogClass.Family.Level
     DB.LogClass.Family.Level := [sllDB,sllHTTP,
     sllInfo, sllDebug, sllTrace, sllWarning, sllError,
     sllEnter, sllLeave,
     sllLastError, sllException, sllExceptionOS, sllMemory, sllStackTrace,
     sllFail, sllSQL, sllCache, sllResult, sllDB, sllHTTP, sllClient, sllServer,
     sllServiceCall, sllServiceReturn, sllUserAuth,
     sllCustom1, sllCustom2, sllCustom3, sllCustom4, sllNewRun,
     sllDDDError, sllDDDInfo, sllMonitoring]}
    else
    SynDBLog.Family.Level := [sllHTTP,sllError,sllException,sllDDDError];

end;

procedure TForm1.createsomedata;
var
 aBetEvent:TSQLBET_EVENTS;
 aWsbetEvent: TSQLWSBET_EVENTS;
 i,j,aEvent_id,k:Integer;

begin
 try
  aBetEvent := TSQLBET_EVENTS.Create;
  aWsbetEvent := TSQLWSBET_EVENTS.Create;

  for I := 1 to 50000 do
  begin
    aBetEvent.IDValue :=i;
    aBetEvent.EVENT_ID := i;
    aBetEvent.ACTUAL_DATE:=now;
    DB.Orm.Add(aBetEvent ,true,true);
  end;

  k:=1;
  for I := 1 to 3000 do
  begin
     aEvent_id:=i+1000;
    for j := 1 to 10 do
    begin
      aWsbetEvent.IDValue := k; inc(k);
      aWsbetEvent.EVENT_ID := aEvent_id;
      aWsbetEvent.CONTROL_ID := j;
      DB.Orm.Add(aWsbetEvent ,true,true);
    end;
  end;
  memo1.Lines.Add(
   'DB.TableRowCount(TSQLBET_EVENTS)='+IntToStr(DB.TableRowCount(TSQLBET_EVENTS)) );

 finally
  aBetEvent.Free;
  aWsbetEvent.Free;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 UseTSQLDB := False;
end;

end.

unit GetHttpUtils2;


interface
uses System.Net.HttpClient,System.Net.URLClient,System.Net.HttpClientComponent,
  system.Classes,system.SysUtils;

type
 TSimpleHttpClientReader=class
 private
    ExpectSmallTextResponse:boolean;
    SimpleHttpResponseText:String;
 public
    logLines:TStrings;  //not a good idea, todo: replace with main project logging method
    NetHTTPClient: TNetHTTPClient;
    constructor create(const aExpectSmallTextResponse:boolean=True);
    procedure NetHTTPClient1NeedClientCertificate(const Sender: TObject;
      const ARequest: TURLRequest; const ACertificateList: TCertificateList;
      var AnIndex: Integer);
    procedure NetHTTPClient1ReceiveData(const Sender: TObject; AContentLength,
      AReadCount: Int64; var AAbort: Boolean);
    procedure NetHTTPClient1RequestError(const Sender: TObject;
      const AError: string);
    procedure NetHTTPClient1RequestCompleted(const Sender: TObject;
      const AResponse: IHTTPResponse);
    function httpget(aUrl:String;var responseText:String;const aExpectSmallTextResponse:boolean=True):boolean;
    destructor Destroy;
 end;

 function GetHttpRequest2(AURL : string; out AResponse : string ): boolean;


 // here we can use the ipub.rtl.gmessaging notification unit to post a message to the main app
 // for when the download has finished, and even make an interface for the data result structure..
 //TODO: function DownloadLargeBinaryFile( AURL, ADestFilename : string ) : boolean;

 // see AutoUpdateUtils.pas  does it approx what we need??
 // function DownloadLargeBinaryFile( AURL, ADestFilename : string ) : boolean;



implementation


function OperSystemIsWin7:boolean;
begin
  result:= False;
  {$IFDEF MSWINDOWS}
    Result:= ((System.SysUtils.TOSVersion.Major = 6) and (System.SysUtils.TOSVersion.Minor = 1))
  {$ENDIF}
end;

{ TSimpleHttpClientReader }

constructor TSimpleHttpClientReader.create(const aExpectSmallTextResponse:boolean=True);
begin
   ExpectSmallTextResponse := aExpectSmallTextResponse;
   SimpleHttpResponseText:='';
   NetHTTPClient:= TNetHTTPClient.Create(nil);

   NetHTTPClient.Asynchronous := False;
   // fix windows7 issue ...
   if OperSystemIsWin7 then
   NetHTTPClient.SecureProtocols :=
    [THTTPSecureProtocol.SSL3, THTTPSecureProtocol.TLS1,THTTPSecureProtocol.TLS11,THTTPSecureProtocol.TLS12]
  else
    NetHTTPClient.SecureProtocols := CHTTPDefSecureProtocols;

   NetHTTPClient.OnNeedClientCertificate := NetHTTPClient1NeedClientCertificate;
   NetHTTPClient.OnReceiveData := NetHTTPClient1ReceiveData;
   NetHTTPClient.OnRequestCompleted := NetHTTPClient1RequestCompleted;
   NetHTTPClient.OnRequestError := NetHTTPClient1RequestError;
end;

destructor TSimpleHttpClientReader.Destroy;
begin
  NetHTTPClient.Free;
end;

function TSimpleHttpClientReader.httpget(aUrl: String; var responseText: String;
  const aExpectSmallTextResponse: boolean): boolean;
begin
  //  aExpectSmallTextResponse= false is not implemented yet. Supposed to be for streams or large files
  ExpectSmallTextResponse := aExpectSmallTextResponse;
  SimpleHttpResponseText:='';
  if NetHTTPClient.Get(aUrl).StatusCode in [200,201,202] then
   Result:= True else Result:=false; // todo add redirect ??
  // synchronous ...
  responseText:=SimpleHttpResponseText;
end;

procedure TSimpleHttpClientReader.NetHTTPClient1NeedClientCertificate(
  const Sender: TObject; const ARequest: TURLRequest;
  const ACertificateList: TCertificateList; var AnIndex: Integer);
begin
   if assigned(logLines) then logLines.Add(' NetHTTPClient1NeedClientCertificate ');
end;

procedure TSimpleHttpClientReader.NetHTTPClient1ReceiveData(
  const Sender: TObject; AContentLength, AReadCount: Int64;
  var AAbort: Boolean);
begin
   if assigned(logLines) then logLines.Add(' NetHTTPClient1ReceiveData '+
        IntToStr(AReadCount)+' '+IntToStr(AContentLength));
end;

procedure TSimpleHttpClientReader.NetHTTPClient1RequestCompleted(
  const Sender: TObject; const AResponse: IHTTPResponse);
begin
  if ExpectSmallTextResponse then
    SimpleHttpResponseText:=AResponse.ContentAsString;
  if assigned(logLines) then
   logLines.Add(' NetHTTPClient1RequestCompleted completed - receive len='+IntToStr(length(SimpleHttpResponseText)));
end;

procedure TSimpleHttpClientReader.NetHTTPClient1RequestError(
  const Sender: TObject; const AError: string);
begin
  if assigned(logLines) then loglines.Add(' NetHTTPClient1RequestError  '+AError);
  SimpleHttpResponseText:='';
end;


function GetHttpRequest2(AURL : string; out AResponse : string ): boolean;
var
 httpCl: TSimpleHttpClientReader;
begin
   //send http get request, save response to SimpleHttpResponseText
  try
    // TB - trap errors ( so it fails gracefully)
    try
      httpCl:= TSimpleHttpClientReader.create;
      httpCl.logLines := nil;
      httpCl.httpget(AUrl,AResponse) ;
      Result := (AResponse <> '');
    except
      Result := False;
    end;
  finally
   httpCl.Free;
  end;

end;

end.

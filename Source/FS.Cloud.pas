{*******************************************************************************
                                Falcon Sistemas

                          www.falconsistemas.com.br
                         suporte@falconsistemas.com.br
                 Written by Marlon Nardi - ALL RIGHTS RESERVED.
*******************************************************************************}
unit FS.Cloud;

interface

{$IF Defined(ANDROID) OR Defined(IOS)}
  {$IF CompilerVersion < 34.0}
    {$DEFINE INDY}
  {$ENDIF}
{$ENDIF}
{$IF CompilerVersion < 29.0}
  {$DEFINE INDY}
{$ENDIF}

{Se for definido indy para mobile, Adicione ao seu projeto Android as duas lib .so
  http://indy.fulgan.com/SSL/
  libcrypto.so
  libssl.so
  adicione os mesmos em deploymet .\assets\internal\
}

uses
  {$IFNDEF INDY}
  System.Net.URLClient,
  System.Net.HttpClient,
  System.NetConsts,
  {$ELSE}
  uIdHTTP,
  uIdSSLOpenSSL,
  uIdSSLOpenSSLHeaders,
  {$ENDIF}
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections,
  System.json;

const
  FUserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0';
  FContentType = 'application/x-www-form-urlencoded; charset=ISO-8859-1';
  FAccept = '';

type
  EFSCloudException = class(Exception);

  TFSHeader = class(TPersistent)
  private
    FKey: string;
    FValue: string;
  protected
    property Key: string read FKey write FKey;
    property Value: string read FValue write FValue;
  public
    constructor Create(Key, Value: string);
  end;

  TFSCloud = class(TComponent)
  private
    {$IFNDEF INDY}
    FNetHttp: THTTPClient;
    {$ELSE}
    FIdHttp: TIdHTTP;
    FIdSsl: TIdSSLIOHandlerSocketOpenSSL;
    {$ENDIF}
    FParams: TStringList;
    FHeaders: TObjectList<TFSHeader>;
  protected
    {$IFNDEF INDY}
    procedure CertValid(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate; var Accepted: Boolean);
    {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Get(const AURL: string; AToken:string = ''): string; overload;
    function Get(const AURL: string; Encondig: TEncoding): string; overload;
    function Get(const AURL: string; const AResponseContent: TStream): string; overload;
    function Get(const AURL: string; const AResponseContent: TStream; AHeader: TObjectList<TFSHeader>): string; overload;

    function Post(AURL: string; ASource: TStrings): string; overload;
    function Post(AURL: string; ASource: TStrings; Encondig: TEncoding): string; overload;
    function Post(AURL: string; ASource: string; AHeader: TObjectList<TFSHeader>): string; overload;
    function Post(AURL: string; AJson:TJSONObject): string; overload;

    function Put(AURL: string; AJson:TJSONObject): string;

    function Delete(AURL: string): string;

    procedure SetContentType(Content: string);
    procedure SetTimeout(Timeout: Integer);
    procedure SetAccept(Accept: string);
    procedure SetAcceptLanguage(AcceptLanguage: string);
    procedure SetUserAgent(UserAgent: string);
    function Path(AURL, ASource: string; AHeader: TObjectList<TFSHeader>): string;

    property Params: TStringList read FParams write FParams;
    property Headers: TObjectList<TFSHeader> read FHeaders write FHeaders;
  end;

implementation

{ TFSCloud }

{$IFNDEF INDY}
procedure TFSCloud.CertValid(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate; var Accepted: Boolean);
begin
  Accepted  := True;
end;
{$ENDIF}

function TFSCloud.Path(AURL: string; ASource: string; AHeader: TObjectList<TFSHeader>): string;
{$IFNDEF INDY}
var
  vSource: TStream;
  vResponseContent: TStream;
  ArrayNetHeader: TNameValueArray;
  NetHeader: TNetHeader;
  vI: Integer;
{$ENDIF}
begin
  try
    {$IFNDEF INDY}
    vSource := TStringStream.Create(ASource, TEncoding.UTF8);
    vResponseContent := TStringStream.Create('', TEncoding.UTF8);
    try
      SetLength(ArrayNetHeader, AHeader.Count);

      for vI := 0 to AHeader.Count -1 do
      begin
        NetHeader := TNetHeader.Create(Headers[vI].Key, Headers[vI].Value);
        ArrayNetHeader[vI]:= NetHeader;
      end;


      Result := FNetHttp.Patch(AURL, vSource, vResponseContent, ArrayNetHeader).ContentAsString(TEncoding.ANSI);
    finally
      FreeAndNil(vSource);
      FreeAndNil(vResponseContent);
    end;

    {$ELSE}
    FIdHttp.Request.Referer := AURL;
    Result := FIdHttp.Post(AURL, ASource);
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;

end;

constructor TFSCloud.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParams := TStringList.Create;
  FHeaders := TObjectList<TFSHeader>.Create;
  {$IFNDEF INDY}
  FNetHttp := THTTPClient.Create;

  FNetHttp.UserAgent := FUserAgent;
  FNetHttp.ContentType := FContentType;
  FNetHttp.Accept := FAccept;
  FNetHttp.OnValidateServerCertificate := CertValid;
  {$IF CompilerVersion > 31.0}
  FNetHttp.SecureProtocols := [THTTPSecureProtocol.TLS12];
  {$ENDIF}
  {$ELSE}
    {$IF Defined(ANDROID)}
    IdOpenSSLSetLibPath(TPath.GetDocumentsPath);
    {$ENDIF}
  FIdHttp := TIdHTTP.Create(Self);
  FIdSsl := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
  FIdHttp.IOHandler := FIdSsl;
  FIdSsl.SSLOptions.Method := sslvTLSv1_2;
  FIdHttp.Request.UserAgent := FUserAgent;
  FIdHttp.Request.ContentType := FContentType;
  FIdHttp.Request.Accept := FAccept;
  {$ENDIF}

  Self.SetTimeout(60000);
end;

function TFSCloud.Delete(AURL: string): string;
begin
  try

    {$IFNDEF INDY}
    Result := FNetHttp.Delete(AURL).ContentAsString(TEncoding.UTF8);
    {$ELSE}
    FIdHttp.Request.Referer := AURL;
    Result := FIdHttp.Delete(AURL);
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;

end;

destructor TFSCloud.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FHeaders);
  {$IFNDEF INDY}
  FreeAndNil(FNetHttp);
  {$ELSE}
  FreeAndNil(FIdHttp);
  FreeAndNil(FIdSsl);
  {$ENDIF}
  inherited;
end;

function TFSCloud.Get(const AURL: string; Encondig: TEncoding): string;
begin
  try
    {$IFNDEF INDY}
    Result := FNetHttp.Get(AURL).ContentAsString(Encondig);
    {$ELSE}
    Result := FIdHttp.Get(AURL);
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;
end;

function TFSCloud.Get(const AURL: string; AToken:string = ''): string;
{$IFNDEF INDY}
var
 Headers: TNetHeaders;
{$ENDIF}
begin
  try
    {$IFNDEF INDY}
    if AToken.IsEmpty then
      Result := FNetHttp.Get(AURL).ContentAsString(TEncoding.ANSI)
    else
    begin

      SetLength(Headers,1);
      Headers[0].Name:= 'Authorization';
      Headers[0].Value:= 'Bearer '+AToken;

      Result := FNetHttp.Get(AURL,nil,Headers).ContentAsString(TEncoding.ANSI);
    end;
    {$ELSE}
    Result := FIdHttp.Get(AURL);
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;
end;

function TFSCloud.Get(const AURL: string; const AResponseContent: TStream): string;
begin
  try
    {$IFNDEF INDY}
    FNetHttp.Get(AURL, AResponseContent);
    {$ELSE}
    FIdHttp.Get(AURL, AResponseContent);
    AResponseContent.Position := 0;
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;
end;

function TFSCloud.Get(const AURL: string; const AResponseContent: TStream;
  AHeader: TObjectList<TFSHeader>): string;
var
  vI: Integer;
  {$IFNDEF INDY}
  ArrayNetHeader: TNameValueArray;
  NetHeader: TNetHeader;
  {$ENDIF}
begin
  try
    {$IFNDEF INDY}
    SetLength(ArrayNetHeader, AHeader.Count);

    for vI := 0 to AHeader.Count -1 do
    begin
      NetHeader := TNetHeader.Create(Headers[vI].Key, Headers[vI].Value);
      ArrayNetHeader[vI]:= NetHeader;
    end;

    Result := FNetHttp.Get(AURL, AResponseContent, ArrayNetHeader).ContentAsString(TEncoding.ANSI);
    {$ELSE}
    FIdHttp.Request.CustomHeaders.FoldLines := False;

    for vI := 0 to AHeader.Count -1 do
    begin
      FIdHttp.Request.CustomHeaders.AddValue(Headers[vI].Key, Headers[vI].Value);
    end;

    Result := FIdHttp.Get(AURL);
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;
end;

function TFSCloud.Post(AURL: string; AJson: TJSONObject): string;
var
  vSource: TStringStream;
begin
  try

    vSource:=  TStringStream.Create(AJson.ToString);
    {$IFNDEF INDY}
    Result := FNetHttp.Post(AURL,vSource).ContentAsString(TEncoding.UTF8);
    {$ELSE}
    FIdHttp.Request.Referer := AURL;
    Result := FIdHttp.Post(AURL, vSource);
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;

end;

function TFSCloud.Put(AURL: string; AJson: TJSONObject): string;
var
  vSource: TStringStream;
begin
  try

    vSource:=  TStringStream.Create(AJson.ToString);
    {$IFNDEF INDY}
    Result := FNetHttp.Put(AURL,vSource).ContentAsString(TEncoding.UTF8);
    {$ELSE}
    FIdHttp.Request.Referer := AURL;
    Result := FIdHttp.Put(AURL, vSource);
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;

end;

function TFSCloud.Post(AURL: string; ASource: TStrings;
  Encondig: TEncoding): string;
begin
  try
    {$IFNDEF INDY}
    Result := FNetHttp.Post(AURL, ASource).ContentAsString(Encondig);
    {$ELSE}
    FIdHttp.Request.Referer := AURL;
    Result := FIdHttp.Post(AURL, ASource);
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;
end;

function TFSCloud.Post(AURL: string; ASource: string; AHeader: TObjectList<TFSHeader>): string;
{$IFNDEF INDY}
var
  vSource: TStream;
  vResponseContent: TStream;
  ArrayNetHeader: TNameValueArray;
  NetHeader: TNetHeader;
  vI: Integer;
{$ENDIF}
begin
  try
    {$IFNDEF INDY}
    vSource := TStringStream.Create(ASource, TEncoding.UTF8);
    vResponseContent := TStringStream.Create('', TEncoding.UTF8);
    try
      SetLength(ArrayNetHeader, AHeader.Count);

      for vI := 0 to AHeader.Count -1 do
      begin
        NetHeader := TNetHeader.Create(Headers[vI].Key, Headers[vI].Value);
        ArrayNetHeader[vI]:= NetHeader;
      end;

      Result := FNetHttp.Post(AURL, vSource, vResponseContent, ArrayNetHeader).ContentAsString(TEncoding.UTF8);
    finally
      FreeAndNil(vSource);
      FreeAndNil(vResponseContent);
    end;
    {$ELSE}
    FIdHttp.Request.Referer := AURL;
    Result := FIdHttp.Post(AURL, ASource);
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;
end;

function TFSCloud.Post(AURL: string; ASource: TStrings): string;
begin
  try
    {$IFNDEF INDY}
    Result := FNetHttp.Post(AURL, ASource).ContentAsString(TEncoding.ANSI);
    {$ELSE}
    FIdHttp.Request.Referer := AURL;
    Result := FIdHttp.Post(AURL, ASource);
    {$ENDIF}
  except
    on e: Exception do
      raise EFSCloudException.Create(e.Message);
  end;
end;

procedure TFSCloud.SetAccept(Accept: string);
begin
  {$IFNDEF INDY}
  FNetHttp.Accept := Accept;
  {$ELSE}
  FIdHttp.Request.Accept := Accept;
  {$ENDIF}
end;

procedure TFSCloud.SetAcceptLanguage(AcceptLanguage: string);
begin
  {$IFNDEF INDY}
  FNetHttp.AcceptLanguage := AcceptLanguage;
  {$ELSE}
  FIdHttp.Request.AcceptLanguage := AcceptLanguage;
  {$ENDIF}
end;

procedure TFSCloud.SetContentType(Content: string);
begin
  {$IFNDEF INDY}
  FNetHttp.ContentType := Content;
  {$ELSE}
  FIdHttp.Request.ContentType := Content;
  {$ENDIF}
end;

procedure TFSCloud.SetTimeout(Timeout: Integer);
begin
  {$IFNDEF INDY}
    {$IF CompilerVersion >= 31.0}
    FNetHttp.ConnectionTimeout := Timeout;
    FNetHttp.ResponseTimeout := Timeout;
    {$ENDIF}
  {$ELSE}
  FIdHttp.ConnectTimeout := Timeout;
  FIdHttp.ReadTimeout := Timeout;
  {$ENDIF}
end;

procedure TFSCloud.SetUserAgent(UserAgent: string);
begin
  {$IFNDEF INDY}
  FNetHttp.UserAgent := UserAgent;
  {$ELSE}
  FIdHttp.Request.UserAgent := UserAgent;
  {$ENDIF}
end;

{ TFSHeader }

constructor TFSHeader.Create(Key, Value: string);
begin
  Self.FKey := Key;
  Self.FValue := Value;
end;

end.

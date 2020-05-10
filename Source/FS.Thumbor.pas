{*******************************************************************************
                                 Falcon Sistemas

                          www.falconsistemas.com.br
                         suporte@falconsistemas.com.br
                 Written by Marlon Nardi - ALL RIGHTS RESERVED.
*******************************************************************************}

unit FS.Thumbor;

interface

uses
  System.Classes,
  System.SysUtils,
  System.NetEncoding,
  System.Hash;

type
  TThumbor = class(TObject)
  private
    FUrlServerThumbor: string;
    FSecretKey: string;
  protected
    FBuildImage: string;
    FWidth: Integer;
    FHeight: Integer;
    FSmart: Boolean;
    FCustom: string;
    FQuality: Integer;
    FGrayScale: Boolean;
  public
    constructor Create(UrlServerThumbor, SecretKey: string);
    constructor CreateWithoutKey(UrlServerThumbor: string);

    function BuildImage(Path: string): TThumbor;
    function Resize(Width, Height: Integer): TThumbor;
    function Smart(): TThumbor;
    function Quality(Value: Integer): TThumbor;
    function GrayScale(): TThumbor;
    function Custom(Value: string): TThumbor;

    function ToUrl(): string;
  end;

implementation

{ TThumbor }

function TThumbor.BuildImage(Path: string): TThumbor;
begin
  Result := Self;
  FBuildImage := Path;
end;

constructor TThumbor.Create(UrlServerThumbor, SecretKey: string);
begin
  FUrlServerThumbor := UrlServerThumbor;
  FSecretKey := SecretKey;
end;

constructor TThumbor.CreateWithoutKey(UrlServerThumbor: string);
begin
  FUrlServerThumbor := UrlServerThumbor;
end;

function TThumbor.Custom(Value: string): TThumbor;
begin
  Result := Self;
  FCustom := Value;
end;

function TThumbor.GrayScale: TThumbor;
begin
  Result := Self;
  FGrayScale := True;
end;

function TThumbor.Quality(Value: Integer): TThumbor;
begin
  Result := Self;
  FQuality := Value;
end;

function TThumbor.Resize(Width, Height: Integer): TThumbor;
begin
  Result := Self;
  FWidth := Width;
  FHeight := Height;
end;

function TThumbor.Smart: TThumbor;
begin
  Result := Self;
  FSmart := True;
end;

function TThumbor.ToUrl: string;
var
  StrBuilder: TStringBuilder;
  vUrlParth: TBytes;
  vSecretKey: TBytes;
  vTk: TBytes;
  vB64: string;
begin
  StrBuilder := TStringBuilder.Create;
  try
    if (FWidth > 0) or (FHeight > 0) and (FCustom.IsEmpty) then
      StrBuilder.Append(FWidth.ToString + 'x' + FHeight.ToString + '/');
    if FSmart and (FCustom.IsEmpty) then
      StrBuilder.Append('smart/');
    if (FQuality > 0) and (FQuality <= 100) and (FCustom.IsEmpty) then
      StrBuilder.Append('filters:quality(' + FQuality.ToString + ')/');
    if FCustom <> EmptyStr then
      StrBuilder.Append(FCustom + '/');

    StrBuilder.Append(FBuildImage);

    vUrlParth := TEncoding.UTF8.GetBytes(StrBuilder.ToString);

    if not FSecretKey.IsEmpty then
    begin
      vSecretKey := TEncoding.UTF8.GetBytes(FSecretKey);
      vTk := THashSHA1.GetHMACAsBytes(vUrlParth, vSecretKey);
    end;

    vB64 := TEncoding.UTF8.GetString(TNetEncoding.Base64.Encode(vTk));
    vB64 := StringReplace(vB64, '+', '-', [rfReplaceAll]);
    vB64 := StringReplace(vB64, '/', '_', [rfReplaceAll]);

    Result := FUrlServerThumbor + vB64 + '/' + StrBuilder.ToString;
  finally
    StrBuilder.Free;
  end;
end;

end.


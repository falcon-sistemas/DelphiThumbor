# DelphiThumb

<br />

DelphiThumb is a class to make easier to use the thumbor imaging service (http://github.com/globocom/thumbor) in Delphi projects.

<img src="https://github.com/marlonnardi/DelphiThumbor/blob/master/Samples/images/thumbor.png" height="250" />

<img src="https://github.com/marlonnardi/DelphiThumbor/blob/master/Samples/images/thumbor2.png" height="250" />

## Prerequisite
This library wotk with **Delphi 10.3 Rio**, **Delphi 10.2 Tokyo**, **Delphi 10.1 Berlin**, **Delphi 10 Seattle** and **Delphi XE8**

#### Libraries/Units dependencies
This library has no dependencies on external libraries/units.

Delphi units used:
- System.Hash (DXE8+)
- System.NetEncoding (DXE7+)

## Installation
Simply add the source path "Source" to your Delphi project path and.. you are good to go!

## Code Examples

#### Using TThumbor class

```delphi
var
  Thumbor: TThumbor;
begin
  Thumbor := TThumbor.Create('https://urlserverthumbor.com', 'secretkey');
  try
    Thumbor
      .BuildImage('path_image')
      .Resize(300, 0)
      .Smart()
      .ToUrl();
  finally
    Thumbor.Free;
  end;
```

```delphi
var
  Thumbor: TThumbor;
begin
  Thumbor := TThumbor.Create('https://urlserverthumbor.com', 'secretkey');
  try
    Thumbor
      .BuildImage('path_image')
      .Quality(90)
      .ToUrl();
  finally
    Thumbor.Free;
  end;
```

#### Using TThumbor Custom dinamic

```delphi
var
  Thumbor: TThumbor;
begin
  Thumbor := TThumbor.Create('https://urlserverthumbor.com', 'secretkey');
  try
    Thumbor
      .BuildImage('path_image')
      .Custom('0x250/filters:quality(80):grayscale():round_corner(30,255,255,255)')
      .ToUrl();
  finally
    Thumbor.Free;
  end;
```

<hr />
<div style="text-align:right">Marlon Nardi</div>

unit uFrmThumbor;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.NetEncoding,
  System.Hash,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Imaging.jpeg,
  Vcl.Buttons,
  Vcl.Samples.Spin,
  FS.Cloud,
  FS.Thumbor;

type
  TForm4 = class(TForm)
    edtSecretKey: TEdit;
    lbl1: TLabel;
    memUrl: TMemo;
    edtUrlServerThumbor: TEdit;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edtPathImage: TEdit;
    chkUseSmart: TCheckBox;
    imgThumbor: TImage;
    btnGenerateByClass: TBitBtn;
    edtWitdh: TSpinEdit;
    lbl5: TLabel;
    edtHeigth: TSpinEdit;
    procedure btnGenerateByClassClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetImageByUrl(URL: string; APicture: TPicture);
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.btnGenerateByClassClick(Sender: TObject);
var
  Thumbor: TThumbor;
  vUrlThumbor: string;
begin
  Thumbor := TThumbor.Create(edtUrlServerThumbor.Text, edtSecretKey.Text);
  try
    vUrlThumbor :=
      Thumbor
        .BuildImage(edtPathImage.Text)
        .Resize(edtWitdh.Value, edtHeigth.Value)
        .Smart()
        .ToUrl();

    memUrl.Lines.Add(vUrlThumbor);
    GetImageByUrl(vUrlThumbor, imgThumbor.Picture);
  finally
    Thumbor.Free;
  end;
end;

procedure TForm4.GetImageByUrl(URL: string; APicture: TPicture);
var
  Jpeg: TJPEGImage;
  Strm: TMemoryStream;
  Cloud: TFSCloud;
begin
  Jpeg := TJPEGImage.Create;
  Strm := TMemoryStream.Create;
  Cloud := TFSCloud.Create(Self);
  try
    Cloud.Get(URL, Strm);
    if (Strm.Size > 0) then
    begin
      Strm.Position := 0;
      Jpeg.LoadFromStream(Strm);
      APicture.Assign(Jpeg);
    end;
  finally
    Strm.Free;
    Jpeg.Free;
    Cloud.Free;
  end;
end;

end.

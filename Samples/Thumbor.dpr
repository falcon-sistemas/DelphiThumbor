program Thumbor;

uses
  Vcl.Forms,
  uFrmThumbor in 'uFrmThumbor.pas' {Form4},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Carbon');
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

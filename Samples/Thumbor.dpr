program Thumbor;

uses
  Vcl.Forms,
  uFrmThumbor in 'uFrmThumbor.pas' {frmThumbor},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Carbon');
  Application.CreateForm(TfrmThumbor, frmThumbor);
  Application.Run;
end.

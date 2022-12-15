unit Unico;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TFrmUnico = class(TForm)
    Lbl: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUnico: TFrmUnico;

implementation

{$R *.dfm}

uses ServerCont, Lib;

procedure TFrmUnico.FormActivate(Sender: TObject);
begin
  if not FileExists(ExtractFilePath(Application.ExeName)+'libmysql.dll') then
  begin
    Application.MessageBox('Biblioteca libmysql.dll não encontrada','Erro',MB_OK+MB_ICONERROR);
    Application.Terminate
  end;

  ServerContainer.DSTCPServerTransport.Port:= StrToInt(GetParms('PortaDTS'));
  ServerContainer.DSServer.Start;
end;

end.


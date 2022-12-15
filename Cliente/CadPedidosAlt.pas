unit CadPedidosAlt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.DBCtrls;

type
  TFrmCadPedidosAlt = class(TForm)
    Pnl: TPanel;
    BtnSalvar: TButton;
    BtnCancelar: TButton;
    Label3: TLabel;
    Label4: TLabel;
    DBEQtd: TEdit;
    DBEPrcVenda: TEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BtnSalvarClick(Sender: TObject);
    procedure DBEQtdKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function PedidosItmAlt(var Qtd: Real; var Prc: Real): Boolean;

implementation

{$R *.dfm}

function PedidosItmAlt(var Qtd: Real; var Prc: Real): Boolean;
var FrmCadPedidosAlt: TFrmCadPedidosAlt;
begin
  FrmCadPedidosAlt:= TFrmCadPedidosAlt.Create(Application);
  with FrmCadPedidosAlt do
  begin
    DBEQtd.Text     := FloatToStr(Qtd);
    DBEPrcVenda.Text:= FloatToStr(Prc);
    Result:= ShowModal = mrOk;
    if Result then
    begin
      Qtd:= StrToFloat(DBEQtd.Text);
      Prc:= StrToFloat(DBEPrcVenda.Text)
    end;
  end;
  FreeAndNil(FrmCadPedidosAlt)
end;

procedure TFrmCadPedidosAlt.BtnSalvarClick(Sender: TObject);
begin
  if (Trim(DBEQtd.Text) = '') or (Trim(DBEPrcVenda.Text) = '') then raise Exception.Create('Quatidade ou valor não informado');
  if (StrToFloat(DBEQtd.Text) <= 0) or (StrToFloat(DBEPrcVenda.Text) <= 0) then raise Exception.Create('Quantidade ou valor zerado ou negativo');
  ModalResult:= mrOk
end;

procedure TFrmCadPedidosAlt.DBEQtdKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',',',#8,#13]) then Key:= #0
end;

procedure TFrmCadPedidosAlt.FormActivate(Sender: TObject);
begin
  Top:= 100
end;

procedure TFrmCadPedidosAlt.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Perform(40,0,0)
end;

end.

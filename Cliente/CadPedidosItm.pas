unit CadPedidosItm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Mask;

type
  TFrmCadPedidosItm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBECodProd: TDBEdit;
    DBLCodProd: TDBLookupComboBox;
    DBEQtd: TDBEdit;
    DBEPrcVenda: TDBEdit;
    Pnl: TPanel;
    BtnSalvar: TButton;
    BtnCancelar: TButton;
    DsCadPedidoItm: TDataSource;
    DsProduto: TDataSource;
    CDSPedProd: TClientDataSet;
    procedure BtnSalvarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DBECodProdExit(Sender: TObject);
    procedure Alteracao(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function PodeHabilita: Boolean;
  public
    { Public declarations }
    function Exibir(DataSet: TDataSet): Boolean;
  end;

var
  FrmCadPedidosItm: TFrmCadPedidosItm;

implementation

{$R *.dfm}

uses Server;

procedure TFrmCadPedidosItm.Alteracao(Sender: TObject);
begin
  BtnSalvar.Enabled := PodeHabilita;
end;

procedure TFrmCadPedidosItm.BtnSalvarClick(Sender: TObject);
begin
  with DsCadPedidoItm.DataSet do
  begin
    FieldByName('NumPed').AsInteger   := 0;
    FieldByName('ValorItem').AsFloat:= FieldByName('Qtd').AsFloat * FieldByName('PrcVenda').AsFloat;
    if FieldByName('ValorItem').AsFloat <= 0 then raise Exception.Create('Valor total zerado ou negativo');
    Post
  end;
  ModalResult:= mrOk
end;

procedure TFrmCadPedidosItm.DBECodProdExit(Sender: TObject);
begin
  Alteracao(Sender);
  if Trim(DBECodProd.EditText) <> '' then
  if CDSPedProd.Locate('CodProd',DBECodProd.EditText,[]) then
  begin
    DsCadPedidoItm.DataSet.Edit;
    DsCadPedidoItm.DataSet['Descricao']:= CDSPedProd['Descricao'];
    DsCadPedidoItm.DataSet['PrcVenda'] := CDSPedProd['PrcVenda'];
  end;
end;

function TFrmCadPedidosItm.Exibir(DataSet: TDataSet): Boolean;
begin
  DsCadPedidoItm.DataSet:= DataSet;
  DMServer.AbrirDados(CDSPedProd);
  DataSet.Append;
  Result:= ShowModal = mrOk;
  FreeAndNil(Self)
end;

procedure TFrmCadPedidosItm.FormActivate(Sender: TObject);
begin
  Top:= 100
end;

procedure TFrmCadPedidosItm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if DsCadPedidoItm.DataSet.State = dsInsert then DsCadPedidoItm.DataSet.Cancel
end;

procedure TFrmCadPedidosItm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key= #13 then Perform(40,0,0)
end;

function TFrmCadPedidosItm.PodeHabilita: Boolean;
begin
  Result:= (Trim(DBLCodProd.Text) <> '') and
           (Trim(DBEQtd.EditText) <> '') and
           (Trim(DBEPrcVenda.EditText) <> '')
end;

end.

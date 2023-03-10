unit CadPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls, MidasLib,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ToolWin, Vcl.DBCtrls, Data.SqlExpr,
  Datasnap.DBClient;

type
  TFrmCadPedidos = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    DBTDatEmis: TDBText;
    DBLCodCli: TDBLookupComboBox;
    DBG: TDBGrid;
    Pnl: TPanel;
    BtnSalvar: TButton;
    BtnCancelar: TButton;
    Label2: TLabel;
    DBTValorTot: TDBText;
    DsCadPedidos: TDataSource;
    DsCadPedidosItm: TDataSource;
    DsPedCli: TDataSource;
    CDSCadPedidos: TClientDataSet;
    CDSCadPedidosItm: TClientDataSet;
    CDSPedCli: TClientDataSet;
    ToolBar: TToolBar;
    BtnInc: TToolButton;
    BtnAlt: TToolButton;
    BtnExc: TToolButton;
    procedure Alteracao(Sender: TObject);
    procedure BtnIncClick(Sender: TObject);
    procedure CDSCadPedidosAfterInsert(DataSet: TDataSet);
    procedure CDSCadPedidosItmAfterInsert(DataSet: TDataSet);
    procedure BtnExcClick(Sender: TObject);
    procedure BtnAltClick(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure DBGEnter(Sender: TObject);
    procedure DBGExit(Sender: TObject);
    procedure DBGKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGKeyPress(Sender: TObject; var Key: Char);
    procedure CDSCadPedidosAfterOpen(DataSet: TDataSet);
    procedure CDSCadPedidosItmAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
    procedure CalcValores(Fat: Integer);
    function PodeHabilita: Boolean;
  public
    { Public declarations }
    procedure SetParams(NumPed: Variant);
    function Exibir(AltCon: Byte {0 Inclusao, 1 Alteracao, 2 Consulta}): Boolean;
  end;

var
  FrmCadPedidos: TFrmCadPedidos;

implementation

{$R *.dfm}

uses Server, CadPedidosItm, CadPedidosAlt, Proxy;

procedure TFrmCadPedidos.Alteracao(Sender: TObject);
begin
  BtnSalvar.Enabled := PodeHabilita;
end;

procedure TFrmCadPedidos.BtnAltClick(Sender: TObject);
var Qtd, Prc: Real;
begin
  inherited;
  if CDSCadPedidosItm.IsEmpty then raise Exception.Create('Nenhum item para alterar');
  Qtd:= CDSCadPedidosItm.FieldByName('Qtd').AsFloat;
  Prc:= CDSCadPedidosItm.FieldByName('PrcVenda').AsFloat;
  if PedidosItmAlt(Qtd, Prc) then
  begin
    CalcValores(-1);
    CDSCadPedidosItm.Edit;
    CDSCadPedidosItm['Qtd']:= Qtd;
    CDSCadPedidosItm['PrcVenda']:= Prc;
    CDSCadPedidosItm['ValorItem']:= CDSCadPedidosItm.FieldByName('Qtd').AsFloat * CDSCadPedidosItm.FieldByName('PrcVenda').AsFloat;
    CDSCadPedidosItm.Post;
    CalcValores(1);
  end;
end;

procedure TFrmCadPedidos.BtnExcClick(Sender: TObject);
begin
  if CDSCadPedidosItm.IsEmpty then raise Exception.Create('Nenhum item para excluir');
  if Application.MessageBox('Deseja excluir esse item?','Confirma??o', MB_YESNO+MB_DEFBUTTON2+MB_ICONQUESTION) = idno then Exit;
  CalcValores(-1);
  CDSCadPedidosItm.Delete
end;

procedure TFrmCadPedidos.BtnIncClick(Sender: TObject);
var OK: Boolean;
begin
  inherited;
  FrmCadPedidosItm:= TFrmCadPedidosItm.Create(Self);
  OK:= FrmCadPedidosItm.Exibir(CDSCadPedidosItm);
  if OK then CalcValores(1);
  if OK then BtnInc.Click;
  Alteracao(DBLCodCli)
end;

procedure TFrmCadPedidos.BtnSalvarClick(Sender: TObject);
var TD: TTransactionDesc; vProxy: TServerMethodsClient;
begin
  if CDSCadPedidos['ValorTot'] <= 0 then raise Exception.Create('Pedido com valor total zerado');
  if CDSCadPedidos.State in [dsEdit,dsInsert] then
  begin
    DMServer.DSPBanco.Connected:= True;
    DMServer.SQLCon.Connected:= True;

    vProxy:= TServerMethodsClient.Create(DMServer.SQLCon.DBXConnection);
    if CDSCadPedidos['NumPed'] = Null then CDSCadPedidos['NumPed']:= vProxy.MaisUm('Pedido','NumPed');
    FreeAndNil(vProxy);

    CDSCadPedidos.Post;
    CDSCadPedidosItm.First;
    while not CDSCadPedidosItm.Eof do
    begin
      if CDSCadPedidosItm['NumPed'] = 0 then
      begin
        CDSCadPedidosItm.Edit;
        CDSCadPedidosItm['NumPed']:= CDSCadPedidos['NumPed'];
        CDSCadPedidosItm.Post
      end;
      CDSCadPedidosItm.Next
    end;

    DMServer.SQLCon.StartTransaction(TD);
    try
      CDSCadPedidos.ApplyUpdates(0);
      CDSCadPedidosItm.ApplyUpdates(0);
      DMServer.SQLCon.Commit(TD);
    except
      on E: Exception do
      begin
        DMServer.SQLCon.Rollback(TD);
        Application.HandleException(Sender);
        Abort
      end;
    end;
    DMServer.SQLCon.Connected:= False;
    DMServer.DSPBanco.Connected:= False;
  end;
  ModalResult:= mrOk
end;

procedure TFrmCadPedidos.CalcValores(Fat: Integer);
begin
  CDSCadPedidos.Edit;
  CDSCadPedidos.FieldByName('ValorTot').AsFloat:= CDSCadPedidos.FieldByName('ValorTot').AsFloat + CDSCadPedidosItm.FieldByName('ValorItem').AsFloat * Fat
end;

procedure TFrmCadPedidos.CDSCadPedidosAfterInsert(DataSet: TDataSet);
begin
  DataSet['ValorTot']:= 0;
  DataSet['DatEmis'] := Date;
end;

procedure TFrmCadPedidos.CDSCadPedidosAfterOpen(DataSet: TDataSet);
begin
  TFloatField(DataSet.FieldByName('ValorTot')).currency:= True;
end;

procedure TFrmCadPedidos.CDSCadPedidosItmAfterInsert(DataSet: TDataSet);
begin
  DataSet['NumPedItem']:= DataSet.Tag;
  DataSet.Tag:= DataSet.Tag + 1
end;

procedure TFrmCadPedidos.CDSCadPedidosItmAfterOpen(DataSet: TDataSet);
begin
  TFloatField(DataSet.FieldByName('PrcVenda')).currency:= True;
  TFloatField(DataSet.FieldByName('ValorItem')).currency:= True;
  DataSet.FieldByName('NumPedItem').ReadOnly:= False;
  DataSet.FieldByName('Descricao').ReadOnly:= False;
  DataSet.FieldByName('NumPed').Required:= False;
end;

procedure TFrmCadPedidos.DBGEnter(Sender: TObject);
begin
  KeyPreview:= False
end;

procedure TFrmCadPedidos.DBGExit(Sender: TObject);
begin
  KeyPreview:= True
end;

procedure TFrmCadPedidos.DBGKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then BtnAlt.Click
end;

procedure TFrmCadPedidos.DBGKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  45 : BtnInc.Click;
  46 : BtnExc.Click
  end;
end;

function TFrmCadPedidos.Exibir(AltCon: Byte): Boolean;

procedure Desabilita;
begin
  DBLCodCli.Enabled:= False;
  ToolBar.Enabled:= False;
  DBG.OnKeyPress:= nil;
  DBG.OnKeyUp:= nil;
end;

begin
  case AltCon of
  1 : DBLCodCli.Enabled:= False;
  2 : Desabilita
  end;
  DMServer.AbrirDados(CDSPedCli);
  DMServer.AbrirDados(CDSCadPedidos);
  DMServer.AbrirDados(CDSCadPedidosItm);
  CDSCadPedidosItm.Tag:= CDSCadPedidosItm.FieldByName('UltPedItem').AsInteger + 1;
  Alteracao(DBLCodCli);
  Result:= ShowModal = mrOk;
  FreeAndNil(Self)
end;

function TFrmCadPedidos.PodeHabilita: Boolean;
begin
  Result:= (Trim(DBLCodCli.Text) <> '') and ToolBar.Enabled
end;

procedure TFrmCadPedidos.SetParams(NumPed: Variant);
begin
  CDSCadPedidos.Params.ParamByName('NumPed').Value   := NumPed;
  CDSCadPedidosItm.Params.ParamByName('NumPed').Value:= NumPed;
end;

end.

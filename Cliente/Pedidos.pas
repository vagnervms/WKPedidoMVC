unit Pedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DbxDatasnap,
  Data.DBXCommon, IPPeerClient, Data.SqlExpr, Datasnap.DBClient,
  Datasnap.DSConnect;

type
  TFrmPedidos = class(TForm)
    PnlFiltro: TPanel;
    BtnLocalizar: TButton;
    BtnLimpar: TButton;
    BtnClose: TButton;
    ToolBar: TToolBar;
    BtnInc: TToolButton;
    BtnAlt: TToolButton;
    BtnExc: TToolButton;
    BtnCon: TToolButton;
    DBG: TDBGrid;
    DsPedido: TDataSource;
    CDSPedido: TClientDataSet;
    Label1: TLabel;
    Label3: TLabel;
    EdtNumPed: TEdit;
    EdtDatEmis: TDateTimePicker;
    EdtCliente: TEdit;
    ChkDatEmis: TCheckBox;
    CDSPedidoItm: TClientDataSet;
    DsPedidoItm: TDataSource;
    Splitter1: TSplitter;
    DBGItm: TDBGrid;
    procedure BtnLocalizarClick(Sender: TObject);
    procedure BtnLimparClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnIncClick(Sender: TObject);
    procedure CDSPedidoAfterOpen(DataSet: TDataSet);
    procedure CDSPedidoItmAfterOpen(DataSet: TDataSet);
    procedure CDSPedidoAfterScroll(DataSet: TDataSet);
    procedure FormActivate(Sender: TObject);
    procedure BtnExcClick(Sender: TObject);
    procedure DBGKeyPress(Sender: TObject; var Key: Char);
    procedure DBGKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedidos: TFrmPedidos;

implementation

{$R *.dfm}

uses Server, CadPedidos, Teste, Proxy, Lib;

procedure TFrmPedidos.BtnCloseClick(Sender: TObject);
begin
  Close
end;

procedure TFrmPedidos.BtnExcClick(Sender: TObject);
var vProxy: TServerMethodsClient;
begin
  if CDSPedido.IsEmpty then raise Exception.Create('Nenhum registro encontrado');
  if Application.MessageBox('Deseja excluir esse item?','Confirma��o', MB_YESNO+MB_DEFBUTTON2+MB_ICONQUESTION) = idyes then
  begin
    DMServer.DSPBanco.Connected:= True;
    DMServer.SQLCon.Connected:= True;

    vProxy:= TServerMethodsClient.Create(DMServer.SQLCon.DBXConnection);
    vProxy.ExecSQL('delete from pedido where NumPed = :NumPed',VarArrayOf(['NumPed']),VarArrayOf([CDSPedido['NumPed']]));
    FreeAndNil(vProxy);

    DMServer.SQLCon.Connected:= False;
    DMServer.DSPBanco.Connected:= False;

    DMServer.AbrirDados(CDSPedido);
    DMServer.AbrirDados(CDSPedidoItm);
  end;
end;

procedure TFrmPedidos.BtnIncClick(Sender: TObject);
var NumPed: Integer;
begin
  if (TToolButton(Sender).Name <> 'BtnInc') and CDSPedido.IsEmpty then raise Exception.Create('Nenhum registro selecionado');
  FrmCadPedidos:= TFrmCadPedidos.Create(Self);
  if TToolButton(Sender).Name = 'BtnInc'
  then FrmCadPedidos.SetParams(Null)
  else FrmCadPedidos.SetParams(CDSPedido['NumPed']);

  if FrmCadPedidos.Exibir(TToolButton(Sender).Tag) and CDSPedido.Active then
  begin
    NumPed:= CDSPedido.FieldByName('NumPed').AsInteger;
    DMServer.AbrirDados(CDSPedido);
    DMServer.AbrirDados(CDSPedidoItm);
    CDSPedido.Locate('NumPed',NumPed,[]);
  end;
end;

procedure TFrmPedidos.BtnLimparClick(Sender: TObject);
var X: Word;
begin
  CDSPedido.Close;
  CDSPedidoItm.Close;
  with PnlFiltro do
    for X := 0 to ControlCount-1 do
      if TWinControl(Controls[X]).InheritsFrom(TCustomEdit) then
        TCustomEdit(Controls[X]).Clear
end;

procedure TFrmPedidos.BtnLocalizarClick(Sender: TObject);

procedure SetParams(Edt: TEdit; Params: String);
begin
  if Trim(Edt.Text) <> ''
  then CDSPedido.Params.ParamByName(Params).Value:= Edt.Text
  else CDSPedido.Params.ParamByName(Params).Value:= Null
end;

var X: Byte; Nulos: Boolean;
begin
  CDSPedido.Close;
  SetParams(EdtNumPed,'NumPed');
  SetParams(EdtCliente,'NomCli');
  if ChkDatEmis.Checked
  then CDSPedido.Params.ParamByName('DatEmis').Value:= EdtDatEmis.Date
  else CDSPedido.Params.ParamByName('DatEmis').Value:= Null;

  Nulos:= True;
  for X:= 0 to CDSPedido.Params.Count-1 do
    if Copy(CDSPedido.Params[X].Name,1,1) <> '_' then
       Nulos:= Nulos and (CDSPedido.Params[X].Value = Null);
  if Nulos then
  if CDSPedido.Tag <> 0
  then raise Exception.Create('Nemhum par�metro foi preenchido, busca n�o pode ser realizada')
  else if Application.MessageBox('Nenhum par�metro foi preenchido, essa opera��o poder� levar muito tempo. Deseja continuar?',
                                 'Confirma��o',MB_YESNO+MB_DEFBUTTON2+MB_ICONQUESTION) = IDNO then Abort;

  DMServer.AbrirDados(CDSPedido);
  if CDSPedido.IsEmpty
  then Application.MessageBox('Nenhum registro localizado','Aviso',MB_OK+MB_ICONINFORMATION);
  DMServer.AbrirDados(CDSPedidoItm);
end;

procedure TFrmPedidos.CDSPedidoAfterOpen(DataSet: TDataSet);
begin
  TFloatField(CDSPedido.FieldByName('ValorTot')).currency:= True;
end;

procedure TFrmPedidos.CDSPedidoAfterScroll(DataSet: TDataSet);
begin
  CDSPedidoItm.ParamByName('NumPed').Value:= CDSPedido.FieldByName('NumPed').AsInteger;
  DMServer.AbrirDados(CDSPedidoItm)
end;

procedure TFrmPedidos.CDSPedidoItmAfterOpen(DataSet: TDataSet);
begin
  TFloatField(CDSPedidoItm.FieldByName('PrcVenda')).currency:= True;
  TFloatField(CDSPedidoItm.FieldByName('ValorItem')).currency:= True;
end;

procedure TFrmPedidos.DBGKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then BtnAlt.Click
end;

procedure TFrmPedidos.DBGKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  45 : BtnInc.Click;
  46 : BtnExc.Click
  end;
end;

procedure TFrmPedidos.FormActivate(Sender: TObject);
begin
  DMServer.SQLCon.Params.Values['Port']:= GetParms('Porta');
  EdtDatEmis.Date:= Date;
end;

end.

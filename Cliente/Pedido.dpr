program Pedido;

uses
  Vcl.Forms,
  Pedidos in 'Pedidos.pas' {FrmPedidos},
  Server in 'Server.pas' {DMServer: TDataModule},
  CadPedidos in 'CadPedidos.pas' {FrmCadPedidos},
  CadPedidosItm in 'CadPedidosItm.pas' {FrmCadPedidosItm},
  CadPedidosAlt in 'CadPedidosAlt.pas' {FrmCadPedidosAlt},
  Proxy in 'Proxy.pas',
  Lib in 'Lib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMServer, DMServer);
  Application.CreateForm(TFrmPedidos, FrmPedidos);
  Application.Run;
end.

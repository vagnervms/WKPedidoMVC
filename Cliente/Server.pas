unit Server;

interface

uses
  System.SysUtils, System.Classes, Data.DbxDatasnap, Data.DBXCommon,
  IPPeerClient, Data.SqlExpr, Data.DB, Datasnap.DBClient, Datasnap.DSConnect,
  Data.FMTBcd;

type
  TDMServer = class(TDataModule)
    DSPBanco: TDSProviderConnection;
    SQLCon: TSQLConnection;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AbrirDados(DataSet: TDataSet);
  end;

var
  DMServer: TDMServer;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDMServer.AbrirDados(DataSet: TDataSet);
{label 1;
var X: Byte; Ret: Boolean;}
begin
  DMServer.SQLCon.Connected:= False;
  DMServer.DSPBanco.Connected:= False;
  DataSet.Close;
  DataSet.Open;
  DMServer.DSPBanco.Connected:= False;
  DMServer.SQLCon.Connected:= False;
{  X:= 0; Ret:= False;
  if DataSet.Active then DataSet.Close;
1:try
    DataSet.Open;
  except
    DMServer.DSPBanco.Close;
    DMServer.DSPBanco.Open;
    Inc(X);
    Ret:= True;
    if (X > 3) then raise Exception.Create('Realizada 3 tentativas sem conex?o com o servidor');
  end;
  if Ret then Goto 1;}
end;

end.

//
// Created by the DataSnap proxy generator.
// 13/12/2022 19:20:28
//

unit Proxy;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethodsClient = class(TDSAdminClient)
  private
    FBancoBeforeConnectCommand: TDBXCommand;
    FEchoStringCommand: TDBXCommand;
    FReverseStringCommand: TDBXCommand;
    FExecSQLCommand: TDBXCommand;
    FMaisUmCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    procedure BancoBeforeConnect(Sender: TObject);
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    procedure ExecSQL(SQL: string; Params: OleVariant; Values: OleVariant);
    function MaisUm(Tabela: string; Campo: string): Integer;
  end;

implementation

procedure TServerMethodsClient.BancoBeforeConnect(Sender: TObject);
begin
  if FBancoBeforeConnectCommand = nil then
  begin
    FBancoBeforeConnectCommand := FDBXConnection.CreateCommand;
    FBancoBeforeConnectCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FBancoBeforeConnectCommand.Text := 'TServerMethods.BancoBeforeConnect';
    FBancoBeforeConnectCommand.Prepare;
  end;
  if not Assigned(Sender) then
    FBancoBeforeConnectCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FBancoBeforeConnectCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FBancoBeforeConnectCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(Sender), True);
      if FInstanceOwner then
        Sender.Free
    finally
      FreeAndNil(FMarshal)
    end
  end;
  FBancoBeforeConnectCommand.ExecuteUpdate;
end;

function TServerMethodsClient.EchoString(Value: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FDBXConnection.CreateCommand;
    FEchoStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FEchoStringCommand.Text := 'TServerMethods.EchoString';
    FEchoStringCommand.Prepare;
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.ExecuteUpdate;
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethodsClient.ReverseString(Value: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FDBXConnection.CreateCommand;
    FReverseStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FReverseStringCommand.Text := 'TServerMethods.ReverseString';
    FReverseStringCommand.Prepare;
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.ExecuteUpdate;
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

procedure TServerMethodsClient.ExecSQL(SQL: string; Params: OleVariant; Values: OleVariant);
begin
  if FExecSQLCommand = nil then
  begin
    FExecSQLCommand := FDBXConnection.CreateCommand;
    FExecSQLCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FExecSQLCommand.Text := 'TServerMethods.ExecSQL';
    FExecSQLCommand.Prepare;
  end;
  FExecSQLCommand.Parameters[0].Value.SetWideString(SQL);
  FExecSQLCommand.Parameters[1].Value.AsVariant := Params;
  FExecSQLCommand.Parameters[2].Value.AsVariant := Values;
  FExecSQLCommand.ExecuteUpdate;
end;

function TServerMethodsClient.MaisUm(Tabela: string; Campo: string): Integer;
begin
  if FMaisUmCommand = nil then
  begin
    FMaisUmCommand := FDBXConnection.CreateCommand;
    FMaisUmCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FMaisUmCommand.Text := 'TServerMethods.MaisUm';
    FMaisUmCommand.Prepare;
  end;
  FMaisUmCommand.Parameters[0].Value.SetWideString(Tabela);
  FMaisUmCommand.Parameters[1].Value.SetWideString(Campo);
  FMaisUmCommand.ExecuteUpdate;
  Result := FMaisUmCommand.Parameters[2].Value.GetInt32;
end;

constructor TServerMethodsClient.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

constructor TServerMethodsClient.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

destructor TServerMethodsClient.Destroy;
begin
  FBancoBeforeConnectCommand.DisposeOf;
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FExecSQLCommand.DisposeOf;
  FMaisUmCommand.DisposeOf;
  inherited;
end;

end.


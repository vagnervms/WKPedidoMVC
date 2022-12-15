unit ServerCont;

interface

uses System.SysUtils, System.Classes, IPPeerServer, Datasnap.DSCommonServer,
  Datasnap.DSServer, Datasnap.DSTCPServerTransport,
  IPPeerAPI, Datasnap.DSAuth;

type
  TServerContainer = class(TDataModule)
    DSServer: TDSServer;
    DSTCPServerTransport: TDSTCPServerTransport;
    DSServerClass: TDSServerClass;
    procedure DSServerClassGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
  private
    { Private declarations }
  public
  end;

var
  ServerContainer: TServerContainer;

implementation

{$R *.dfm}

uses
  ServerMet;

procedure TServerContainer.DSServerClassGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := ServerMet.TServerMethods;
end;

end.


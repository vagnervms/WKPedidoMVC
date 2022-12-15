unit Teste;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids, MidasLib,
  Vcl.DBGrids, Vcl.StdCtrls;

type
  TFrmCadTeste = class(TForm)
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    ListBox1: TListBox;
    DBGrid1: TDBGrid;
    procedure ClientDataSet1AfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
    procedure AddList(const Str: String);
  public
    { Public declarations }
  end;

var
  FrmCadTeste: TFrmCadTeste;

implementation

{$R *.dfm}

uses Server;

procedure TFrmCadTeste.AddList(const Str: String);
begin
  ListBox1.Items.Add(Str);
end;

procedure TFrmCadTeste.ClientDataSet1AfterPost(DataSet: TDataSet);
begin
  ClientDataSet1.ApplyUpdates(0)
end;

procedure TFrmCadTeste.FormCreate(Sender: TObject);
begin
  DMServer.DSPBanco.GetProviderNames(AddList);
end;

procedure TFrmCadTeste.ListBox1Click(Sender: TObject);
begin
  ClientDataSet1.Close;
  ClientDataSet1.ProviderName:= ListBox1.Items[ListBox1.ItemIndex];
  ClientDataSet1.Open;
end;

end.

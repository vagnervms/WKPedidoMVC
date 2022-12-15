object FrmCadTeste: TFrmCadTeste
  Left = 0
  Top = 0
  Caption = 'FrmCadTeste'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 177
    Height = 299
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object DBGrid1: TDBGrid
    Left = 177
    Top = 0
    Width = 458
    Height = 299
    Align = alClient
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    RemoteServer = DMServer.DSPBanco
    AfterPost = ClientDataSet1AfterPost
    Left = 32
    Top = 48
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 96
    Top = 48
  end
end

object FrmCadPedidosItm: TFrmCadPedidosItm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pedidos item'
  ClientHeight = 102
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 19
    Height = 13
    Caption = 'C'#243'd'
  end
  object Label2: TLabel
    Left = 64
    Top = 8
    Width = 38
    Height = 13
    Caption = 'Produto'
  end
  object Label3: TLabel
    Left = 280
    Top = 8
    Width = 22
    Height = 13
    Caption = 'Qtd.'
  end
  object Label4: TLabel
    Left = 352
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Pre'#231'o'
  end
  object DBECodProd: TDBEdit
    Left = 8
    Top = 26
    Width = 41
    Height = 21
    DataField = 'CodProd'
    DataSource = DsCadPedidoItm
    TabOrder = 0
    OnExit = DBECodProdExit
  end
  object DBLCodProd: TDBLookupComboBox
    Left = 64
    Top = 26
    Width = 201
    Height = 21
    DataField = 'CodProd'
    DataSource = DsCadPedidoItm
    Enabled = False
    KeyField = 'CodProd'
    ListField = 'Descricao'
    ListSource = DsProduto
    TabOrder = 1
  end
  object DBEQtd: TDBEdit
    Left = 280
    Top = 26
    Width = 57
    Height = 21
    DataField = 'Qtd'
    DataSource = DsCadPedidoItm
    TabOrder = 2
    OnExit = Alteracao
  end
  object DBEPrcVenda: TDBEdit
    Left = 352
    Top = 26
    Width = 89
    Height = 21
    DataField = 'PrcVenda'
    DataSource = DsCadPedidoItm
    TabOrder = 3
    OnExit = Alteracao
  end
  object Pnl: TPanel
    Left = 0
    Top = 61
    Width = 454
    Height = 41
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    ExplicitTop = 68
    ExplicitWidth = 462
    DesignSize = (
      454
      41)
    object BtnSalvar: TButton
      Left = 243
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Salvar'
      Enabled = False
      TabOrder = 0
      OnClick = BtnSalvarClick
      ExplicitLeft = 251
    end
    object BtnCancelar: TButton
      Left = 331
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 339
    end
  end
  object DsCadPedidoItm: TDataSource
    Left = 32
    Top = 54
  end
  object DsProduto: TDataSource
    DataSet = CDSPedProd
    Left = 174
    Top = 54
  end
  object CDSPedProd: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DsPedProd'
    RemoteServer = DMServer.DSPBanco
    Left = 112
    Top = 54
  end
end

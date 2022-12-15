object FrmCadPedidosAlt: TFrmCadPedidosAlt
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pedidos Item'
  ClientHeight = 107
  ClientWidth = 260
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 32
    Top = 8
    Width = 22
    Height = 13
    Caption = 'Qtd.'
  end
  object Label4: TLabel
    Left = 128
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Pre'#231'o'
  end
  object Pnl: TPanel
    Left = 0
    Top = 66
    Width = 260
    Height = 41
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    ExplicitTop = 60
    ExplicitWidth = 261
    DesignSize = (
      260
      41)
    object BtnSalvar: TButton
      Left = 49
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Salvar'
      TabOrder = 0
      OnClick = BtnSalvarClick
      ExplicitLeft = 50
    end
    object BtnCancelar: TButton
      Left = 137
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 138
    end
  end
  object DBEQtd: TEdit
    Left = 32
    Top = 26
    Width = 57
    Height = 21
    TabOrder = 0
    OnKeyPress = DBEQtdKeyPress
  end
  object DBEPrcVenda: TEdit
    Left = 128
    Top = 26
    Width = 89
    Height = 21
    TabOrder = 1
  end
end

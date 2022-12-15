object ServerMethods: TServerMethods
  OldCreateOrder = False
  Height = 262
  Width = 436
  object Banco: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'Password=vms1996'
      'Server=localhost'
      'Database=wk'
      'MonitorBy=FlatFile'
      'DriverID=MySQL')
    TxOptions.DisconnectAction = xdRollback
    LoginPrompt = False
    BeforeConnect = BancoBeforeConnect
    Left = 23
    Top = 8
  end
  object FDPDriver: TFDPhysMySQLDriverLink
    VendorLib = 'D:\WinDesenv\WKPedido\libmysql.dll'
    Left = 91
    Top = 8
  end
  object QryPedido: TFDQuery
    Connection = Banco
    SQL.Strings = (
      'select NumPed, DatEmis, NomCli, Cidade, UF, ValorTot'
      'from pedido p inner join cliente c on p.CodCli = c.CodCli'
      'where NumPed = coalesce(:NumPed, NumPed) and'
      '      DatEmis = coalesce(:DatEmis, DatEmis) and'
      '      1 = case when :NomCli is null then 1 else'
      
        '            case when NomCli like concat('#39'%'#39',:NomCli,'#39'%'#39') then 1' +
        ' end'
      #9#9'  end')
    Left = 24
    Top = 56
    ParamData = <
      item
        Name = 'NUMPED'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'DATEMIS'
        DataType = ftDate
        ParamType = ptInput
      end
      item
        Name = 'NOMCLI'
        DataType = ftString
        ParamType = ptInput
      end>
  end
  object DsPPedido: TDataSetProvider
    DataSet = QryPedido
    Left = 91
    Top = 56
  end
  object QryPedidoItm: TFDQuery
    MasterFields = 'NumPed'
    Connection = Banco
    SQL.Strings = (
      'select i.*, Descricao'
      'from pedidoitem i inner join produto p on i.CodProd = p.CodProd'
      'where NumPed = :NumPed')
    Left = 24
    Top = 102
    ParamData = <
      item
        Name = 'NUMPED'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object DsPedidoItm: TDataSetProvider
    DataSet = QryPedidoItm
    Left = 93
    Top = 102
  end
  object QryCadPedido: TFDQuery
    Connection = Banco
    SQL.Strings = (
      'select * from pedido'
      'where NumPed = :NumPed')
    Left = 183
    Top = 53
    ParamData = <
      item
        Name = 'NUMPED'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object QryCadPedidoItm: TFDQuery
    Connection = Banco
    UpdateObject = UpCadPedidoItm
    SQL.Strings = (
      
        'select i.*, Descricao, (select Max(NumPedItem) from pedidoitem) ' +
        'UltPedItem'
      'from pedidoitem i inner join produto p on i.CodProd = p.CodProd'
      'where NumPed = :NumPed')
    Left = 184
    Top = 102
    ParamData = <
      item
        Name = 'NUMPED'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object UpCadPedidoItm: TFDUpdateSQL
    Connection = Banco
    InsertSQL.Strings = (
      'INSERT INTO pedidoitem'
      '(numped, codprod, qtd, prcvenda, valoritem)'
      
        'VALUES (:new_numped, :new_codprod, :new_qtd, :new_prcvenda, :new' +
        '_valoritem)')
    ModifySQL.Strings = (
      'UPDATE pedidoitem'
      
        'SET numped = :new_numped, codprod = :new_codprod, qtd = :new_qtd' +
        ', '
      '  prcvenda = :new_prcvenda, valoritem = :new_valoritem'
      'WHERE numpeditem = :old_numpeditem')
    DeleteSQL.Strings = (
      'DELETE FROM pedidoitem'
      'WHERE numpeditem = :old_numpeditem')
    FetchRowSQL.Strings = (
      'SELECT numpeditem, numped, codprod, qtd, prcvenda, valoritem'
      'FROM pedidoitem'
      'WHERE numpeditem = :old_numpeditem')
    Left = 360
    Top = 102
  end
  object DsCadPedidos: TDataSetProvider
    DataSet = QryCadPedido
    Left = 272
    Top = 54
  end
  object DsCadPedidosItm: TDataSetProvider
    DataSet = QryCadPedidoItm
    Left = 272
    Top = 102
  end
  object QryPedProd: TFDQuery
    Connection = Banco
    SQL.Strings = (
      'select * from produto')
    Left = 184
    Top = 149
  end
  object QryPedCli: TFDQuery
    Connection = Banco
    SQL.Strings = (
      'select * from Cliente'
      'order by NomCli')
    Left = 184
    Top = 197
  end
  object DsPedProd: TDataSetProvider
    DataSet = QryPedProd
    Left = 272
    Top = 149
  end
  object DsPedCli: TDataSetProvider
    DataSet = QryPedCli
    Left = 272
    Top = 197
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 184
    Top = 8
  end
  object FDMoniFlatFileClientLink: TFDMoniFlatFileClientLink
    Left = 290
    Top = 8
  end
end

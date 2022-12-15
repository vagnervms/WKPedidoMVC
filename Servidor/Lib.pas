unit Lib;

interface

uses Winapi.Windows, System.SysUtils, Vcl.Forms, IniFiles;

function GetParms(Parametro: String): String;

implementation

function GetParms(Parametro: String): String;
label 1;
var Arquivo : TIniFile;
begin
1:   Arquivo := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
     Result  := Arquivo.ReadString('Config',Parametro,Result);
     FreeAndNil(Arquivo);
     if Result = '' then
     if Application.MessageBox(PChar(Parametro+' sem valor definido no arquivo INI.'+#13+
                               'O programa pode não funcionar corretamente.'+#13+#13+
                               'Deseja localizar o paramentro novamente?'),'Aviso',MB_YESNO+MB_ICONWARNING) = IdYes then goto 1;
end;


end.

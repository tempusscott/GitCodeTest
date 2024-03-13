unit uScottsInterfaces;

interface

type
  IScottInterface = interface
    ['{AC8F44A7-AC0F-4DB0-8235-3B98F1F7F092}']
    function GetSomeResult: string;
  end;

  TScottObject = class(TInterfacedObject, IScottInterface)
     function GetSomeResult: string;
     function NotInterfacedFunction: string;
  end;

  TFrancescoObject = class(TInterfacedObject, IScottInterface)
     function GetSomeResult: string;
     function AnotherNotInterfacedFunction: string;
  end;

  function CreateNewScott: IScottInterface; overload;
  function CreateNewFrancesco: IScottInterface; overload;

implementation

{ TScottObject }

function CreateNewScott: IScottInterface; overload;
begin
   Result := TScottObject.Create;
end;

function CreateNewFrancesco: IScottInterface; overload;
begin
   Result := TFrancescoObject.Create;
end;

function TScottObject.GetSomeResult: string;
begin
   Result := 'This is Scott''s interface';
end;

function TScottObject.NotInterfacedFunction: string;
begin
   Result := 'You cannot reach this function thru the interface';
end;

{ TFrancescoObject }

function TFrancescoObject.AnotherNotInterfacedFunction: string;
begin
   Result := 'You cannot reach this function thru the interface';
end;

function TFrancescoObject.GetSomeResult: string;
begin
   Result := 'This is still Scott''s interface';
end;


end.

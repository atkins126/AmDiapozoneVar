unit AmDiapozoneVar;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,AmuserType,AmList,math;




   {
     TDiaMain класс для перебора разных вариантов комбинаций значений
      аналог
      for i:=0 do Arr1.count-1 do
      for z:=0 do Arr2.count-1 do
      for x:=0 do Arr3.count-1 do
      showmessage(Arr1[i] +' '+ Arr2[z] +' '+Arr3[x]);



      D.AddNewVar('Y',10,11,1);
      D.AddNewVar('X',1,2,1);

      //Lev.AddNewVar('X','X.1',100,101,1);
     // Lev.AddNewVar('X','X.2',500,502,1);
      D.FinishAdd;

     while not ISNeedBreak do
     begin
          S:='';
          D.GetValue(ISNeedBreak, procedure (PVar:TDiapozoneItem)
                  begin
                   S:=S+' '+PVar.Name+':'+  AMStr(PVar.Value);
                  end);


       //   Memo4.Lines.Add(S);
     end;

   }




   {
    TFunDiapozoneVarChilds= class;


   TDiapozoneItem =class
     private
      procedure GetArr;
      // сгенирирует  Arr GetArr
      var
      ArrI:integer;
      ArrCount:integer;
      Arr:TArray<real>;
      IsLastItem:boolean;
      LastItem:TDiapozoneItem;
      function IncI :boolean;
     public
      //указать при создании класса
      Childs:TFunDiapozoneVarChilds;

      Name:string;
      ValueMin:real;
      ValueMax:real;
      Step:real;

      // после real хранит значение
      var Value:real;
      function GetValue(var IsNeedBreak:boolean;Proc:TFunDiapozoneVar):real;
      procedure Clear;
      constructor Create;
      destructor Destroy;override;
   end;
    TDiapozoneArr = TAmList<TDiapozoneItem>;

    TFunDiapozoneVarChilds =class
    public
      Parent: TFunDiapozoneVarChilds;
      ListName:TAmListvar<string>;
      Items: TAmList<TDiapozoneArr>;
      function AddNewItem:TDiapozoneArr;
      procedure Clear;
      constructor Create;
      destructor Destroy;override;
    end;

   type

    TDiapozoneList  = class ;
    TDiapozoneSplit       = class (TAmList<TDiapozoneList>);

    //класс для генерации разных комбинации значений на основе Real
    TDiapozoneList =class
     private
      Childs:TFunDiapozoneVarChilds;
     // procedure SerchEx(Name:string; out Index:integer;out IsSerch:boolean );
      function SerchExParent(NameParent:string):TFunDiapozoneVarChilds;
      function SerchExParentChild(NameParent:string; ItemInput:TDiapozoneArr):TDiapozoneArr;
      Procedure SetLastItem(L:TDiapozoneArr);
      Procedure GetCountIteration;

     // function Add:integer;


     public
      function AddNewVar(ANameParent,AName:string;IndexParent:integer;AMin,AMax,AStep:real):integer;
      procedure FinishAdd;
      var
      CountIteration:int64;
      var
      ItemLast: TDiapozoneItem;
      function Count:integer;
      function Items(Index:integer):boolean;overload;
     // function Items(Name:string):boolean;overload;
    //  function Serch(Name:string):integer;
      procedure GetValue(var IsNeedBreak:boolean;Proc:TFunDiapozoneVar);

      // разбить текуший список на несколько новых что бы в разных потоках прогнать разные комбинации
      function ToSplit(ACount:integer):TDiapozoneSplit;
      procedure CopyToSelf(From:TDiapozoneList);
      var
      ListSplit: TDiapozoneSplit;
      procedure ListSplitFreeC;
      class procedure ListSplit_ClearFree( AListSplit:TDiapozoneSplit); static;

      procedure Clear;
      procedure Reset;
      constructor Create;
      destructor Destroy;override;
    end;

      }

 type
 TDiarParam= record
   AMax,AMin,AStep:real;
 end;
 TDiaCld=class;
 TDiaMain=class;
 TFunDiapozoneVar =reference to procedure  (PVar:TDiaCld);
 TDiaMainList = class (TAmList<TDiaMain>)
      procedure Clear(isFree:boolean);
      destructor Destroy;override;
 end;
 TDiaCldList =  class (TAmList<TDiaCld>)
     public
      function GetCountIteration:int64;
      procedure Clear;
      procedure ResetArr;
      procedure CopyFrom(From:TDiaCldList;AParent:TDiaCld);
      destructor Destroy;override;
 end;
 TDiaCldListList =  class (TAmList<TDiaCldList>)
   public
    function GetCountIteration:int64;
    procedure Clear;
    procedure ResetArr;
    procedure CopyFrom(From:TDiaCldListList;AParent:TDiaCld);
    destructor Destroy;override;
 end;

  TDiaCld=class
  private
    function  GetCountIteration:int64;
  protected
    FValue:real;
    FValuePointer:PDouble;
    FName:string;
    FNameArrPointer: PArrStr;
    FNameArr: TArrStr;
    variantIndexNow:integer;
    variant:TAmListVar<real>;
    Param:TDiarParam;



    Cld:TDiaCldListList;
    Parent:TDiaCld;
    YIsLast:boolean;
    YIsFerst:boolean;
    YLast:TDiaCld;
    YNext:TDiaCld;
    //YNeedInc:boolean;
    IsArray:boolean;
    IsEndArray:boolean;
    function GetValuePointer :Pdouble;
    function GetIsEndArray:boolean;
    function GetIsArrayNextParent:boolean; overload;
    function GetIsArrayNext:boolean; overload;
    procedure SetIsEndArray(V:boolean);
    procedure VariantExp();
    procedure SetVar(AMax,AMin,AStep:real);
    procedure GetValue(var IsNeedBreak:boolean;Proc:TFunDiapozoneVar);
    function IncIndexNow :boolean;

   public

    property Value:real read FValue;
    property ValuePointer:Pdouble read GetValuePointer;
    property Name:string read FName;
    property NameArr:PArrStr read FNameArrPointer;
    procedure CopyFrom(From:TDiaCld;AParent:TDiaCld);
    procedure ResetArr;
    constructor Create;
    destructor Destroy;override;
  end;

  TDiaMain =class
    private
     Procedure SetLastItem(LCld:TDiaCldList);
     Procedure SetNextItem(LCld:TDiaCldList);
     Procedure SetNeedInc(LCld:TDiaCldList);
     Procedure GetCountIteration;
     function AddNew(AParentId:Cardinal;AName:string;AIsArray:boolean;Index:integer;AMin,AMax,AStep:real) :Cardinal;
    public
     Cld:TDiaCldList;
     CountIteration:int64;
     function AddNewVar(AName:string;AMin,AMax,AStep:real):Cardinal;
     function AddNewArray(AName:string;ACount:integer):Cardinal;
     function AddNewElemArray(AParentId:Cardinal;AName:string;Index:integer;AMin,AMax,AStep:real):Cardinal;
     procedure FinishAdd;

     procedure GetValue(var IsNeedBreak:boolean;Proc:TFunDiapozoneVar);
     procedure Clear;
     procedure CopyFrom(From:TDiaMain);
     var
     LSplit:TDiaMainList;
     function ToSplit(ACount:integer):TDiaMainList;
     procedure Reset;
     constructor Create;
     destructor Destroy;override;
  end;


implementation

procedure TDiaMainList.Clear(isFree:boolean);
var i:integer;
begin
  if isFree then  
   for I := 0 to Count-1 do
     Items[i].Free;
  inherited Clear;

end;
destructor TDiaMainList.Destroy;
begin
    Clear(true);
    inherited;
end;

function TDiaCldList.GetCountIteration:int64;
var i:integer;
R:int64;
begin
   Result:=0;
   if Count>0 then
   begin
     for I := 0 to Count-1 do
     if Assigned(Items[i]) then
     begin
         R:=  Items[i].GetCountIteration;
         if R>0 then
         Result:= max(Result,1) *  R;
     end;
   end;

end;
procedure TDiaCldList.Clear;
var i:integer;
begin
   for I := 0 to Count-1 do
     Items[i].Free;
  inherited Clear;
end;
procedure TDiaCldList.ResetArr;
var i:integer;
begin
   for I := 0 to Count-1 do
     Items[i].ResetArr;

end;
destructor TDiaCldList.Destroy;
begin
    Clear;
    inherited;
end;
procedure TDiaCldList.CopyFrom(From:TDiaCldList;AParent:TDiaCld);
var i:integer;
begin
   Clear;
   for I := 0 to From.Count-1 do
   Add(TDiaCld.Create);
   for I := 0 to Count-1 do
   Items[i].CopyFrom(From[i],AParent);
end;


function TDiaCldListList.GetCountIteration:int64;
var i:integer;
R:int64;
begin
   Result:=0;
   if Count>0 then
   begin
     for I := 0 to Count-1 do
     if Assigned(Items[i]) then
     begin
         R:=  Items[i].GetCountIteration;
         if R>0 then
         Result:= Result +  R;
     end;
   end;

end;
procedure TDiaCldListList.Clear;
var i:integer;
begin
   for I := 0 to Count-1 do
   if Assigned(Items[i]) then
   Items[i].Free;
  inherited Clear;
end;
procedure TDiaCldListList.ResetArr;
var i:integer;
begin
   for I := 0 to Count-1 do
   if Assigned(Items[i]) then
   Items[i].ResetArr;

end;
destructor TDiaCldListList.Destroy;
begin
    Clear;
    inherited;
end;
procedure TDiaCldListList.CopyFrom(From:TDiaCldListList;AParent:TDiaCld);
var i:integer;
    L:TDiaCldList;
begin
   Clear;
   for I := 0 to From.Count-1 do
   Add(TDiaCldList.Create);
   for I := 0 to Count-1 do
   Items[i].CopyFrom(From[i],AParent);
end;




constructor TDiaMain.Create;
begin
    inherited create;
    Cld:=TDiaCldList.Create;
    CountIteration:=0;
end;
destructor TDiaMain.Destroy;
begin
    Clear;
    Cld.Free;
    inherited;
end;
procedure TDiaMain.Clear;
begin
  CountIteration:=0;
  Cld.Clear;
end;
procedure TDiaMain.Reset;
begin
   Cld.ResetArr;
end;
procedure TDiaMain.CopyFrom(From:TDiaMain);

begin
   Clear;
   Cld.CopyFrom(From.Cld,nil);
   FinishAdd;
end;
function TDiaMain.ToSplit(ACount:integer):TDiaMainList;
var I,IterForOne,Counter,X: Int64;
IsNeedBreak:boolean;
CountListResult:integer;
 ItemR:TDiaMain;
begin
   Reset;
   Result:= TDiaMainList.create;

      Counter:=0;
      X:=0;
      CountListResult:=0;
      IsNeedBreak:= Cld.Count<=0;
      IterForOne:=round(CountIteration / ACount);
      if (IterForOne<=0) and  (CountIteration>0) then  IterForOne:=CountIteration;


      while not ISNeedBreak do
      begin
          if (X>=Counter) then
          begin
             if CountListResult<ACount then
             begin
              inc(CountListResult);

              ItemR:= TDiaMain.Create;
              Result.add(ItemR);
              ItemR.CopyFrom(self);
              Counter:=Counter+IterForOne;

              if CountListResult<ACount then
              ItemR.CountIteration:= IterForOne
              else
              begin
              ItemR.CountIteration:=  CountIteration -  X;
              break;
              end;


             end;
          end;


          GetValue(ISNeedBreak,procedure (PVar:TDiaCld)begin end);
           {
          AListValue.Clear;
          AListValue.SetLineCount(Count);

          for I := 0 to Count-1 do
          begin
             Items(I);
             AListValue.SetItem(i,ItemLast.Name,ItemLast.GetValue(ISNeedBreak));
          end;
          AList.Add(AListValue);
          }
          inc(X);
      end;

end;
function TDiaMain.AddNewVar(AName:string;AMin,AMax,AStep:real):Cardinal;
begin
   REsult:=AddNew(0,AName,False,-1,AMin,AMax,AStep);
end;
function TDiaMain.AddNewArray(AName:string;ACount:integer):Cardinal;
begin
   REsult:=AddNew(0,AName,True,-1,0,ACount-1,1);
end;
function TDiaMain.AddNewElemArray(AParentId:Cardinal;AName:string;Index:integer;AMin,AMax,AStep:real):Cardinal;
begin
   REsult:=AddNew(AParentId,AName,False,Index,AMin,AMax,AStep);
end;
function TDiaMain.AddNew(AParentId:Cardinal;AName:string;AIsArray:boolean;Index:integer;AMin,AMax,AStep:real) :Cardinal;
var Item,ItemCld:TDiaCld;
    List:TDiaCldList;
    AParent:TDiaCld;
begin

    if AParentId=0 then
    begin
      ItemCld:= TDiaCld.Create;
      ItemCld.variant.Clear;
      ItemCld.FName:=AName;
      ItemCld.FNameArr.Arr:= AName.Split(['.']);
      ItemCld.FNameArr.CountRefreshAllRange;
      ItemCld.Parent:=nil;
      ItemCld.IsArray:=AIsArray;
      ItemCld.IsEndArray:=false;
      ItemCld.SetVar(AMax,AMin,AStep);
      Cld.Add(ItemCld);
      Result:= LParam(ItemCld);
    end
    else
    begin
        AParent:=TDiaCld(AParentId);
        while True do
        begin

           if Index>AParent.Cld.Count-1 then
           begin
               List:=TDiaCldList.Create;
               AParent.Cld.Add(List);

           end
           else
           begin
             break;
           end;
        end;


       
       ItemCld:= TDiaCld.Create;
       ItemCld.variant.Clear;
       ItemCld.FName:=AName;
       ItemCld.FNameArr.Arr:= AName.Split(['.']);
       ItemCld.FNameArr.CountRefreshAllRange;
       ItemCld.Parent:=AParent;
       ItemCld.IsArray:=AIsArray;
       ItemCld.IsEndArray:=false;
       ItemCld.SetVar(AMax,AMin,AStep);
       AParent.Cld[Index].Add(ItemCld);
       Result:= LParam(ItemCld);

    end;

end;

procedure TDiaMain.GetValue(var IsNeedBreak:boolean;Proc:TFunDiapozoneVar);
var i:integer;
begin
   if Cld.Count=0 then
   begin
      IsNeedBreak:=true;
      exit;
   end;
   for I := 0 to Cld.Count-1 do
   Cld[i].GetValue(IsNeedBreak,Proc);
end;
procedure TDiaMain.FinishAdd;
begin
    // GetCountIteration;
     SetLastItem(Cld);
     SetNextItem(Cld);
     GetCountIteration;
end;
Procedure TDiaMain.GetCountIteration;
begin
   CountIteration:=Cld.GetCountIteration;
end;
Procedure TDiaMain.SetLastItem(LCld:TDiaCldList);
var i:integer;
   procedure SetLastItemList(L:TDiaCldListList);
   var i:integer;
   begin
      for I := 0 to L.Count-1 do
      SetLastItem(L[i]);
   end;
begin


   if LCld.Count=1 then
   begin
    LCld[0].YLast:= nil;
    LCld[0].YIsLast:= true;
    SetLastItemList(LCld[0].Cld);
   end
   else
   begin
      for I := 1 to LCld.Count-1 do
      begin
      LCld[i].YLast:= LCld[i-1];
      LCld[i].YIsLast:= i = LCld.Count-1;
      end;

      for I := 0 to LCld.Count-1 do
      SetLastItemList(LCld[i].Cld);
   end;


end;
Procedure TDiaMain.SetNextItem(LCld:TDiaCldList);
var i:integer;
   procedure SetNextItemList(L:TDiaCldListList);
   var i:integer;
   begin
      for I := 0 to L.Count-1 do
      SetNextItem(L[i]);
   end;
begin


   if LCld.Count=1 then
   begin
    LCld[0].YNext:= nil;
    LCld[0].YIsFerst:= true;
    SetNextItemList(LCld[0].Cld);
   end
   else
   begin
      for I := 0 to LCld.Count-2 do
      begin
      LCld[i].YNext:= LCld[i+1];
      LCld[i].YIsFerst:= i = 0;
      end;
     LCld[LCld.Count-1].YNext:=nil;

      for I := 0 to LCld.Count-1 do
      SetNextItemList(LCld[i].Cld);
   end;

end;
Procedure TDiaMain.SetNeedInc(LCld:TDiaCldList);
begin

end;



constructor TDiaCld.Create;

begin
     inherited create;

    FValue:=0;
    FValuePointer:=0;
    FName:='';
    FNameArrPointer:=nil;
    FNameArr.Clear();
    variantIndexNow:=-1;
    variant.Clear;
    FillChar(Param,sizeof(Param),0);
    Cld:=nil;
    Parent:=nil;
    YIsLast:=false;
    YIsFerst:=false;
    YLast:=nil;
    YNext:=nil;
    IsArray:=false;
    IsEndArray:=false;

    Cld:=TDiaCldListList.Create;
    FNameArrPointer:=@FNameArr;
    FValuePointer:=  @FValue;
   // YNeedInc:=true;
end;
destructor TDiaCld.Destroy;
begin
   Cld.Free;
   FNameArr.Clear();
   variant.Clear;
   FNameArrPointer:=nil;
   FValuePointer:=nil;
   FValue:=0;


   inherited;
end;
function TDiaCld.GetValuePointer :Pdouble;
begin
   Result:=FValuePointer;
end;
procedure TDiaCld.ResetArr;
begin
    self.variantIndexNow:=0;
    self.IsEndArray:=False;
    self.Cld.ResetArr;

end;
procedure TDiaCld.CopyFrom(From:TDiaCld;AParent:TDiaCld);
begin
    self.FValue:=           From.FValue;
    self.FName:=            From.FName;
    self.variantIndexNow:=  From.variantIndexNow;
    self.variant.CopyFrom(From.variant);
    self.Param.AMax:=      From.Param.AMax ;
    self.Param.AMin:=      From.Param.AMin ;
    self.Param.AStep:=     From.Param.AStep;
    self.Cld.CopyFrom(From.Cld,self);
    self.Parent:= AParent;
    self.IsArray:=     From.IsArray;
    self.IsEndArray:=  From.IsEndArray;
    self.FNameArr.CopyFrom(From.FNameArr);


end;

procedure TDiaCld.GetValue(var IsNeedBreak:boolean;Proc:TFunDiapozoneVar);
var
  I,Ind: Integer;
  R:boolean;
  procedure Loc_Out;
  begin
    if YIsLast then IsNeedBreak:=IncIndexNow
  end;
begin

    IsNeedBreak:=false;
    FValue:=variant[variantIndexNow];
    Proc(Self);


    if Assigned(Cld)
    and (Cld.Count>0)
    and (variantIndexNow<Cld.Count)
    and (variantIndexNow>=0) and  IsArray then
    begin

            R:=false;
            for I := 0 to Cld[variantIndexNow].Count-1 do
            Cld[variantIndexNow][i].GetValue(R,Proc);

            if R then
            begin
                 IsEndArray:=true;
                 Loc_Out
            end;
    end
    else Loc_Out;

end;
function TDiaCld.GetIsArrayNextParent:boolean;
begin
    if  Assigned(Parent)
    and Assigned(Parent.YNext) then Result:= Parent.YNext.GetIsArrayNext
    else                            Result:=False;
end;
function TDiaCld.GetIsArrayNext:boolean;
var J:TDiaCld;
begin
    Result:=GetIsArrayNextParent;
    if not Result then
    begin
      if IsArray then
      J:= Cld[variantIndexNow][Cld[variantIndexNow].Count-1]
      else J:=nil;

      if IsArray and (J.variantIndexNow< J.variant.count-1) then  Result:=true
      else if Assigned(YNext) then        Result:=YNext.GetIsArrayNext()
      else Result:=False
    end;


end;
function TDiaCld.GetIsEndArray:boolean;
begin
    Result:= not GetIsArrayNextParent;
   if  Result then
   begin
     if IsArray then Result:= IsEndArray
     else Result:=true;
     if Result and Assigned(YLast) then
     Result:= YLast.GetIsEndArray;
   end;



end;
procedure TDiaCld.SetIsEndArray(V:boolean);
begin
   if IsArray then IsEndArray:= V;
   if  Assigned(YLast) then
   YLast.SetIsEndArray(V);
end;
function TDiaCld.IncIndexNow :boolean;
begin
   Result:=false;




    if GetIsEndArray then
    begin
     if variantIndexNow+1>=variant.Count then
     begin
        if Assigned(YLast) then
             Result:=YLast.IncIndexNow
        else Result:=true;
        variantIndexNow:=0;
     end
     else Inc(variantIndexNow);

     SetIsEndArray(False);
    end;
end;
function TDiaCld.GetCountIteration:int64;
var R:int64;
begin
   Result:=variant.Count;
   if Cld.Count>0 then
   Result:=Cld.GetCountIteration;
end;
procedure TDiaCld.VariantExp();
var
  i,x:integer;
  C:int64;
  R:Real;
begin
      if Param.AStep=0 then Param.AStep:=10;
      R:=  (Param.AMax - Param.AMin) / Param.AStep;
      C:=  Trunc(R);
      if R <> C then inc(C);
      inc(C);
      variant.Count:= C;

      x:=0;
      for I := 0 to variant.Count-1 do
      begin
          inc(x);
          variant[i]:=  Param.AMin + (Param.AStep*I);
          if variant.Arr[i]>Param.AMax then
          begin
             variant[i]:= Param.AMax;
             break;
          end;

      end;
      variant.Count:=X;
      variantIndexNow:=0;
end;
procedure TDiaCld.SetVar(AMax,AMin,AStep:real);
begin
   Param.AMax:= AMax;
   Param.AMin:= AMin;
   Param.AStep:= AStep;
   VariantExp();
end;

 (*
constructor TFunDiapozoneVarChilds.Create;
begin
   inherited;
   ListName.Clear;
   Items:= TAmList<TAmList<TDiapozoneItem>>.create;
end;
procedure TFunDiapozoneVarChilds.Clear;
var i,b:integer;
begin
      for I := 0 to Items.Count-1 do
      begin
          for B := 0 to Items[i].Count-1 do
          Items[i][b].Free;
          Items[i].Clear;
          Items[i].Free;
      end;

      Items.Clear;
      ListName.Clear;

end;
destructor TFunDiapozoneVarChilds.Destroy;
begin
      Clear;
      Items.Free;
    inherited;
end;
function TFunDiapozoneVarChilds.AddNewItem:TDiapozoneArr;
begin
    Result:=TDiapozoneArr.Create;
    Items.Add(Result);
end;



procedure TDiapozoneList.CopyToSelf(From:TDiapozoneList);
var
ItemNew,ItemFrom:TDiapozoneItem;
I,B:integer;
begin
   Clear;

   for I := 0 to From.Count-1 do
   begin
   {
       From.Items(i);
       CreateNewItemAdd;
       ItemAdd.Name:=From.ItemLast.Name;
       ItemAdd.ValueMin:=From.ItemLast.ValueMin;
       ItemAdd.ValueMax:=From.ItemLast.ValueMax;
       ItemAdd.Step:=From.ItemLast.Step;
       Add;
       ItemAdd.ArrI:=From.ItemLast.ArrI;
        }



       {
       ItemNew.ArrI:= From.ItemLast.ArrI;
       ItemNew.ArrCount:= From.ItemLast.ArrCount;

       SetLength(ItemNew.Arr,ItemNew.ArrCount);
       for B := 0 to From.ItemLast.ArrCount-1 do
       ItemNew.Arr[B]:= From.ItemLast.Arr[B];

       ItemNew.Name:= From.ItemLast.Name;
       ItemNew.ValueMin:= From.ItemLast.ValueMin;
       ItemNew.ValueMax:= From.ItemLast.ValueMax;
       ItemNew.Step:= From.ItemLast.Step;
       ItemNew.Value := From.ItemLast.Value;
     //  ItemNew. }
   end;
   FinishAdd;

end;

function TDiapozoneList.ToSplit(ACount:integer):TDiapozoneSplit;
var I,IterForOne,Counter,X: Int64;
IsNeedBreak:boolean;
CountListResult:integer;
ItemSplit:TDiapozoneList;
begin
   Reset;
   Result:= TDiapozoneSplit.create;

      Counter:=0;
      X:=0;
      CountListResult:=0;
      IsNeedBreak:= Count<=0;
      IterForOne:=round(CountIteration / ACount);
      if (IterForOne<=0) and  (CountIteration>0) then  IterForOne:=CountIteration;

      Items(Count-1);
      while not ISNeedBreak do
      begin
          if (X>=Counter) then
          begin
             if CountListResult<ACount then
             begin
              inc(CountListResult);

              ItemSplit:= TDiapozoneList.Create;
              Result.add(ItemSplit);
              ItemSplit.CopyToSelf(self);
              Counter:=Counter+IterForOne;

              if CountListResult<ACount then
              ItemSplit.CountIteration:= IterForOne
              else
              begin
              ItemSplit.CountIteration:=  CountIteration -  X;
              break;
              end;


             end;
          end;


          ///ItemLast.GetValue(ISNeedBreak);
           {
          AListValue.Clear;
          AListValue.SetLineCount(Count);

          for I := 0 to Count-1 do
          begin
             Items(I);
             AListValue.SetItem(i,ItemLast.Name,ItemLast.GetValue(ISNeedBreak));
          end;
          AList.Add(AListValue);
          }
          inc(X);
      end;



end;
procedure TDiapozoneList.ListSplitFreeC;
begin
  ListSplit_ClearFree(ListSplit);
  ListSplit:=nil;
end;
class procedure TDiapozoneList.ListSplit_ClearFree(AListSplit:TDiapozoneSplit);
var
  I: Integer;
begin
  if Assigned(AListSplit) then
  begin
   for I := 0 to AListSplit.Count-1 do
   AListSplit[i].Free;
   AListSplit.Clear;
   FreeAndNil(AListSplit);
  end;
end;


constructor TDiapozoneList.Create;
begin
    inherited create;
    Childs:=TFunDiapozoneVarChilds.create;
    Childs.AddNewItem;
    Childs.Parent:=nil;
    Clear;
end;
destructor TDiapozoneList.Destroy;
begin
    Clear;
    FreeAndNil(Childs);
    inherited;
end;
procedure TDiapozoneList.Clear;
begin

     CountIteration:=0;
     ItemLast:=nil;
     Childs.Clear;
end;
procedure TDiapozoneList.Reset;
var i:integer;
begin
     for I := 0 to Childs.Items.Count-1 do
     begin

     end;
    // FList[i].ArrI:=0;
end;
Procedure TDiapozoneList.SetLastItem(L:TDiapozoneArr);
var i:integer;
begin
   if L.Count=1 then
   begin
    L[0].LastItem:= nil;
    L[0].IsLastItem:= true;
    SetLastItem(L[0].Childs.Items);
   end
   else
   begin
      for I := 1 to L.Count-1 do
      begin
      L[i].LastItem:= L[i-1];
      L[i].IsLastItem:= i = L.Count-1;
      SetLastItem(L[i].Childs.Items);
      end;
   end;
end;
procedure TDiapozoneList.FinishAdd;
begin
     GetCountIteration;
     SetLastItem(Childs.Items);
end;
Procedure TDiapozoneList.GetCountIteration;
var
  I: integer;
  It:TDiapozoneItem;
begin
   CountIteration:=0;



    {
   for I := 0 to FList.Count-1 do
   begin
      It:= FList[i];
     if It.ArrCount>0 then
     begin
      if CountIteration=0 then CountIteration:= It.ArrCount
      else  CountIteration:= CountIteration* It.ArrCount;
     end;
   end;
     }

end; {
procedure TDiapozoneList.SerchEx(Name:string; out Index:integer;out IsSerch:boolean );
begin
           IsSerch:=AmSerch.BinaryIndex3(Index,0,FList.Count-1,
            function(ind:integer):real
            begin
              Result:=AnsiCompareStr(  FList[ind].Name , Name );
            end);
end;
}
function TDiapozoneList.SerchExParent(NameParent:string):TDiapozoneArr;
var i,b:integer;
begin

     Result:=nil;
     for I := 0 to Childs.ListName.Count-1 do
     begin
       if NameParent = Childs.ListName[i] then
       begin
           Result:= Childs.Items[i];
           exit;
       end;
       
     end;

     for I := 0 to Childs.Items.Count-1 do
     begin
        for b := 0 to Childs.Items[i].Count-1 do
        begin
         Result:= SerchExParentChild(NameParent,Childs.Items[i]);
         if Assigned(Result) then  exit;
        end;
     end;

       
end;
function TDiapozoneList.SerchExParentChild(NameParent:string; ItemInput:TDiapozoneArr):TDiapozoneArr;
var i:integer;
begin
        Result:=nil;
        //.if ItemInput.Name=NameParent  then
        begin
            Result:=  ItemInput;
            exit;
        end;
        
       // for i := 0 to ItemInput.Childs.Count-1 do
        begin
        // Result:= SerchExParentChild(NameParent,ItemInput.Childs[i]);
         if Assigned(Result) then  exit;
        end;
end;
function TDiapozoneList.AddNewVar(ANameParent,AName:string;IndexParent:integer;AMin,AMax,AStep:real):integer;
var ItemChild:TDiapozoneItem;
ItemArr:TDiapozoneArr;
begin
   if ANameParent='' then
   begin
          ItemChild:=  TDiapozoneItem.Create;
          ItemChild.Name:=AName;
          ItemChild.ValueMin:=AMin;
          ItemChild.ValueMax:=AMax;
          ItemChild.Step:=AStep;
          ItemChild.GetArr;
          Childs.ListName.Add(AName);
          Childs.Items[0].Add(ItemChild);

   end
   else
   begin
        ItemArr:=SerchExParent(ANameParent);
        if Assigned(ItemArr) then
        begin
          ItemChild:=  TDiapozoneItem.Create;
          ItemChild.Name:=AName;
          ItemChild.ValueMin:=AMin;
          ItemChild.ValueMax:=AMax;
          ItemChild.Step:=AStep;
          ItemChild.GetArr;
          ItemArr.Add(ItemChild);

        //  if Assigned(Item.Parent) then
          
        end
        else
        begin
          raise Exception.Create('Error Message not Item TDiapozoneList');
        end;
        
   end;
   

end;

{
function TDiapozoneList.Add:integer;
var Bol:boolean;
begin
  Result:=-1;
  if  not Assigned(ItemAdd) then  exit;
  SerchEx(ItemAdd.Name,Result,Bol);
  //добавление с сортировкой
  if Bol then Result:=-1
  else
  begin
      ItemAdd.GetArr;
      if (Result<0) or (Result> FList.Count-1) then
      Result:=FList.Add(ItemAdd)
      else
      FList.Insert(Result,ItemAdd);
  end;

end;
}
function TDiapozoneList.Count:integer;
begin
//  Result:=FList.count;


end;
procedure TDiapozoneList.GetValue(var IsNeedBreak:boolean;Proc:TFunDiapozoneVar);
var i:integer;
Item:TDiapozoneItem;
begin
   for I := 0 to count-1 do
   begin
    // .Items(I);
    //Item:=FList[I];
     Item.GetValue(IsNeedBreak,Proc);
   end;
end;
function TDiapozoneList.Items(Index:integer):boolean;
begin
 //Result:= (Index>=0) And (Index<FList.count);
// if Result then
 // ItemLast:= FList[Index]
 //else ItemLast:=nil;
end; {
function TDiapozoneList.Items(Name:string):boolean;
var Index:integer;
begin
   SerchEx(Name,Index,Result);
   Result:= Result And (Index>=0);
   if Result then  Result:=Items(Index)
   else ItemLast:=nil;
end;
}
{
function TDiapozoneList.Serch(Name:string):integer;
var Bool:boolean;
begin
   SerchEx(Name,Result,Bool);
   if not Bool then Result:= -1;
end;

}


                   {Item}
constructor TDiapozoneItem.Create;
begin
   inherited create;
   Childs:=TFunDiapozoneVarChilds.create;
   Clear;
end;
destructor TDiapozoneItem.Destroy;
begin
   Clear;
   Childs.Free;
   inherited;
end;
procedure TDiapozoneItem.Clear;
begin
      LastItem:=nil;
      Name:='';
      ValueMin:=0;
      ValueMax:=0;
      Step:=10;

      ArrI:=0;
      ArrCount:=0;
      SetLength(Arr,0);


      Value:=0;
      Childs.Clear;

end;
procedure TDiapozoneItem.GetArr;
var
  i,x:integer;
  C:int64;
  R:Real;
begin
      if Step=0 then Step:=10;
      R:=  (ValueMax - ValueMin) / Step;
      C:=  Trunc(R);
      if R <> C then inc(C);
      inc(C);
      ArrCount:= C;
      SetLength(Arr,ArrCount);
      x:=0;
      for I := 0 to ArrCount-1 do
      begin
          inc(x);
          Arr[i]:=  ValueMin + (Step*I);
          if Arr[i]>ValueMax then
          begin
             Arr[i]:= ValueMax;
             break;
          end;

      end;
      SetLength(Arr,x);
      ArrI:=0;
end;
function TDiapozoneItem.GetValue(var IsNeedBreak:boolean;Proc:TFunDiapozoneVar):real;
var
  I,Ind: Integer;
  R:boolean;
  procedure Loc_Out;
  begin
    if self.IsLastItem then  IsNeedBreak:=IncI;
  end;
begin
{
        Item:=SerchExParent(ANameParent);
        if Assigned(Item) then
        begin
          ItemChild:=  TDiapozoneItem.Create;
          ItemChild.Parent:=  Item;
          ItemChild.Name:=AName;
          ItemChild.ValueMin:=AMin;
          ItemChild.ValueMax:=AMax;
          ItemChild.Step:=AStep;
          ItemChild.GetArr;
          ItemChild.IndexParent:=Item.Childs.Add(ItemChild);

        //  if Assigned(Item.Parent) then

        end
        else
        begin
          raise Exception.Create('Error Message not Item TDiapozoneList');
        end;

}
    IsNeedBreak:=false;

    Value:= Arr[ArrI];
    Result:=  Value;

    Proc(Name,Value);

    if Assigned(Childs) and (Childs.Items.Count>0) then
    begin
            Ind:= round(Value);
            R:=false;
            for I := 0 to Childs.Items[Ind].Count-1 do
            Childs.Items[Ind][i].GetValue(R,Proc);
            if R then Loc_Out;
    end
    else Loc_Out;

end;
function TDiapozoneItem.IncI :boolean;

begin

   Result:=false;
   if ArrI+1>=ArrCount then
   begin
      if Assigned(self.LastItem) then
      begin
         Result:=LastItem.IncI;
         ArrI:=0;
      end
      else Result:=true;

   end
   else Inc(ArrI);


end;

 {
Procedure TDiapozoneSplit_ListValue.SetLineCount(ACount:integer);
begin
   if ACount<0 then ACount:=0;
   SetLength(Name,ACount);
   SetLength(Value,ACount);
   Count:=ACount;
end;
Procedure TDiapozoneSplit_ListValue.SetItem(i:integer;AName:string;AValue:real);
begin
    Name[i]:=AName;
    Value[i]:=AValue;
end;
Procedure TDiapozoneSplit_ListValue.Clear;
begin
   SetLength(Name,0);
   SetLength(Value,0);
   Count:=0;
end;
}
  *)

end.

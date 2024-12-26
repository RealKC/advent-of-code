unit Day7;

{$mode ObjFPC}{$H+}

interface

type
  TDay7 = class
    function SolveA(const input: string): uint64;
    function SolveB(const input: string): uint64;
  end;

implementation

uses SysUtils, fgl, Classes, Math;

type
  TOperand = uint64;
  OperandsList = specialize TFPGList<TOperand>;
  DataDict = specialize TFPGMap<TOperand, OperandsList>;

  ResultNode = record
    Left: ^ResultNode;
    Middle: ^ResultNode;
    Right: ^ResultNode;
    Value: TOperand;
  end;
  EquationTree = ^ResultNode;
  NodeKind = (Left, Root, Right, Middle);

function Parse(const input: string): DataDict;
var
  Split: TStringList;
  Total: TOperand;
  RawOperand: string;
  Operands: OperandsList;
  Line: string;
  SplitLine: TStringArray;
  Data: DataDict;
  newkey: integer;
begin
  Data := DataDict.Create;
  Split := TStringList.Create;
  Split.Text := input;

  for Line in Split do
  begin
    SplitLine := Line.Split([': ']);
    Operands := OperandsList.Create;
    for RawOperand in SplitLine[1].Split([' ']) do
    begin
      Operands.Add(StrToUInt64(RawOperand));
    end;
    Data.Add(StrToUInt64(SplitLine[0]), Operands);
  end;

  exit(Data);
end;

function ConcatUInt64(const a: uint64; const b: uint64): uint64;
var
  DigitCount: uint64;
begin
  DigitCount := b.ToString.Length;
  Result := a * (10 ** DigitCount) + b;
end;

function BuildEquationTree(const parentValue: TOperand; const operands: OperandsList;
  const kind: NodeKind): EquationTree;
var
  Popped: OperandsList;
  i: integer;
begin
  if operands.Count = 0 then
    exit(nil);
  Popped := OperandsList.Create;
  for i := 1 to operands.Count - 1 do
  begin
    Popped.Add(operands[i]);
  end;
  New(Result);
  if kind = Root then
  begin
    Result^.Value := operands[0];
    Result^.Left := BuildEquationTree(Result^.Value, Popped, Left);
    Result^.Middle := BuildEquationTree(Result^.Value, Popped, Middle);
    Result^.Right := BuildEquationTree(Result^.Value, Popped, Right);
  end
  else
  begin
    if kind = Left then
      Result^.Value := operands[0] + parentValue
    else if kind = Middle then
      Result^.Value := ConcatUInt64(parentValue, operands[0])
    else if kind = Right then
      Result^.Value := operands[0] * parentValue;
    Result^.Left := BuildEquationTree(Result^.Value, Popped, Left);
    Result^.Middle := BuildEquationTree(Result^.Value, Popped, Middle);
    Result^.Right := BuildEquationTree(Result^.Value, Popped, Right);
  end;
end;


function IsValidEquationA(const tree: EquationTree; const total: TOperand): boolean;
begin
  if tree^.Left = nil then
    exit(tree^.Value = total)
  else
    exit(IsValidEquationA(tree^.Left, total) or IsValidEquationA(tree^.Right, total));
end;

function IsValidEquationB(const tree: EquationTree; const total: TOperand): boolean;
begin
  if tree^.Left = nil then
    exit(tree^.Value = total)
  else
    exit(IsValidEquationB(tree^.Left, total) or IsValidEquationB(tree^.Middle, total) or
      IsValidEquationB(tree^.Right, total));
end;

function TDay7.SolveA(const input: string): uint64;
var
  InputData: DataDict;
  i: integer;
  Tree: EquationTree;
  IsValid: boolean;
begin
  InputData := Parse(input);
  Result := 0;
  for i := 0 to InputData.Count - 1 do
  begin
    Tree := BuildEquationTree(0, InputData.Data[i], Root);
    IsValid := IsValidEquationA(Tree, InputData.Keys[i]);
    if isValid then Result := Result + InputData.Keys[i];
  end;
end;

function TDay7.SolveB(const input: string): uint64;
var
  InputData: DataDict;
  i: integer;
  Tree: EquationTree;
  IsValid: boolean;
begin
  InputData := Parse(input);
  Result := 0;
  for i := 0 to InputData.Count - 1 do
  begin
    Tree := BuildEquationTree(0, InputData.Data[i], Root);
    IsValid := IsValidEquationB(Tree, InputData.Keys[i]);
    if isValid then Result := Result + InputData.Keys[i];
  end;
end;

end.

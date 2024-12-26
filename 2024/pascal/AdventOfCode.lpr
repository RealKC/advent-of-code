program Project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes,
  SysUtils,
  CustApp,
  Day7;

type

  { AdventOfCode }

  AdventOfCode = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

  { AdventOfCode }

  procedure AdventOfCode.DoRun;
  var
    Day: string;
    Part: string;
    Solution: Day7.TDay7;
    InputStream: TStringStream;
  begin
    Day := GetOptionValue('d', 'day');
    Part := GetOptionValue('p', 'part');
    InputStream := TStringStream.Create;

    // parse parameters
    if HasOption('h', 'help') or Day.IsEmpty or Part.IsEmpty then
    begin
      WriteHelp;
      Terminate;
      Exit;
    end;

    { add your program here }


    InputStream.LoadFromFile(Format('inputs/%s', [Day]));

    if Day = '7' then
    begin
      Solution := Day7.TDay7.Create();
      if Part = 'a' then
      begin
        WriteLn(IntToStr(Solution.SolveA(InputStream.DataString)));
      end
      else
      begin
        WriteLn(IntToStr(Solution.SolveB(InputStream.DataString)));
      end;
    end;

    // stop program loop
    Terminate;
  end;

  constructor AdventOfCode.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  destructor AdventOfCode.Destroy;
  begin
    inherited Destroy;
  end;

  procedure AdventOfCode.WriteHelp;
  begin
    { add your help code here }
    writeln('Usage: ', ExeName, ' -h');
  end;

var
  Application: AdventOfCode;
begin
  Application := AdventOfCode.Create(nil);
  Application.Title := 'My Application';
  Application.Run;
  Application.Free;
end.

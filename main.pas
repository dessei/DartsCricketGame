unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TCricket_Game }

  TCricket_Game = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    AllTimeHighScore_Label: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AllTimeHighScore_LabelClick(Sender: TObject);
  private

  public

  end;

var
  Cricket_Game: TCricket_Game;
  Labels: array[1..20] of TLabel;
  Last_pressed_button: Integer;
  next_number: Integer;
  highest_unlocked: Integer;
  current_dart: Integer;
  score: Integer;
  dart_thrown: Integer;
  three_misses: Integer;
  HighScore: Integer;
  AllTimeHigh: Integer;
implementation

{$R *.lfm}

{ TCricket_Game }
procedure GetAllTimeHighScoreFromFile();
var ReadFile: TStringList;
begin
     ReadFile := TStringList.Create();
     ReadFile.LoadFromFile('./Data/highscore.txt');
     AllTimeHigh := StrToInt(Readfile.Strings[0]);
     Cricket_Game.AllTimeHighScore_Label.Caption:='All time high score: '+Readfile.Strings[0];
     Cricket_Game.AllTimeHighScore_Label.Visible := true;
     ReadFile.Free;
end;

procedure TCricket_Game.FormCreate(Sender: TObject);
var i: Integer;
begin
  Labels[1] := Label1;
  Labels[2] := Label2;
  Labels[3] := Label3;
  Labels[4] := Label4;
  Labels[5] := Label5;
  Labels[6] := Label6;
  Labels[7] := Label7;
  Labels[8] := Label8;
  Labels[9] := Label9;
  Labels[10] := Label10;
  Labels[11] := Label11;
  Labels[12] := Label12;
  Labels[13] := Label13;
  Labels[14] := Label14;
  Labels[15] := Label15;
  Labels[16] := Label16;
  Labels[17] := Label17;
  Labels[18] := Label18;
  Labels[19] := Label19;
  Labels[20] := Label20;
  for i := 1 to 20 do begin
      Labels[i].ParentColor := False;
      Labels[i].Transparent := False;
  end;
  for i := 7 to 20 do begin
      Labels[i].Color := clBlack;
  end;
  Last_pressed_button := 0;
  next_number := 1;
  highest_unlocked := 6;
  score := 0;
  three_misses := 0;
  dart_thrown := 1;
  HighScore := 0;
  GetAllTimeHighScoreFromFile();
end;

procedure TCricket_Game.AllTimeHighScore_LabelClick(Sender: TObject);
begin

end;

procedure UpdateScore();
var WriteFile: TStringList;
begin
  Cricket_Game.Label23.Caption := 'Current Score: ' + IntToStr(Score);
  if Score > HighScore then HighScore := Score;
  if Score > AllTimeHigh then
  begin
    AllTimeHigh := Score;
    WriteFile := TStringList.Create();
    WriteFile.LoadFromFile('./data/highscore.txt');
    WriteFile.Strings[0] := IntToStr(AllTimeHigh);
    WriteFile.SaveToFile('./data/highscore.txt');
    WriteFile.free();
  end;
  Cricket_Game.Label24.Caption := 'Session High Score: ' + IntToStr(HighScore);
  Cricket_Game.AllTimeHighScore_Label.Caption := 'All time high score: ' + IntToStr(AllTimeHigh);

end;

procedure HandleButtons(pressed_button: Integer);
begin
  //Count Three misses
  if pressed_button = 5 then three_misses += 1;
  //Handle Darts thrown
  if dart_thrown = 1 then begin
     Cricket_Game.Label21.Caption := 'Throw Dart number two of three';
     dart_thrown += 1;
  end
  else if dart_thrown = 2 then begin
    Cricket_Game.Label21.Caption := 'Throw Dart number three of three';
    dart_thrown += 1;
  end
  else if dart_thrown = 3 then begin
    Cricket_Game.Label21.Caption := 'Throw Dart number one of three';
    dart_thrown := 1;
    if three_misses = 3 then begin
       Labels[next_number].Color := clBlack;
       Labels[next_number].Transparent := False;
       next_number += 1;
       if Labels[next_number].Transparent = False then begin
          Cricket_Game.Label22.Caption := 'Game Over!';
          Cricket_Game.Button2.Visible := False;
          Cricket_Game.Button3.Visible := False;
          Cricket_Game.Button4.Visible := False;
          Cricket_Game.Button5.Visible := False;
          Cricket_Game.AllTimeHighScore_Label.Visible := True;
          Exit;
       end;
    end;
    three_misses := 0;
  end;
  if (Last_pressed_button = 0) or (Last_pressed_button = 5) then begin
     if pressed_button = 0 then begin
       Cricket_Game.Button3.Caption := 'Single Bull';
       Cricket_Game.Button3.Visible := true;
       Cricket_Game.Button4.Caption := 'Double Bull';
       Cricket_Game.Button4.Visible := true;
       Cricket_Game.Button5.Caption := 'Miss';
       Cricket_Game.Button5.Visible := true;
     end;
     if pressed_button = 3 then begin
       Last_pressed_button := 3;
       Cricket_Game.Label22.Caption := 'Current Target: ' + Labels[next_number].Caption;
       Cricket_Game.Button2.Caption := 'Single';
       Cricket_Game.Button2.Visible := true;
       Cricket_Game.Button3.Caption := 'Double';
       Cricket_Game.Button4.Caption := 'Triple';
     end;
     if pressed_button = 4 then begin
       Last_pressed_button := 4;
       Cricket_Game.Label22.Caption := 'Current Target: ' + Labels[next_number].Caption;
       Cricket_Game.Button2.Caption := 'Single';
       Cricket_Game.Button2.Visible := true;
       Cricket_Game.Button3.Caption := 'Double';
       Cricket_Game.Button4.Caption := 'Triple';
       highest_unlocked += 1;
       Labels[highest_unlocked].Transparent := True;
     end;
     if pressed_button = 5 then begin
       Last_pressed_button := 5;
       Cricket_Game.Label22.Caption := 'Current Target: Bull';
       Cricket_Game.Button2.Visible := false;
       Cricket_Game.Button3.Caption := 'Single Bull';
       Cricket_Game.Button4.Caption := 'Double Bull';
     end;
     Exit;
  end;
  if (last_pressed_button = 2) or (last_pressed_button = 3) or (last_pressed_button = 4) then begin
     if pressed_button = 2 then begin
       score += StrToInt(Labels[next_number].Caption);
     end;
     if pressed_button = 3 then begin
       last_pressed_button := 3;
       score += 2 * StrToInt(Labels[next_number].Caption);
     end;
     if pressed_button = 4 then begin
       last_pressed_button := 4;
       score += 3 * StrToInt(Labels[next_number].Caption);
     end;
     if pressed_button = 5 then begin
       Cricket_Game.Label22.Caption := 'Current Target: Bull';
       last_pressed_button := 5;
       Cricket_Game.Button2.Visible := false;
       Cricket_Game.Button3.Caption := 'Single Bull';
       Cricket_Game.Button4.Caption := 'Double Bull';
     end;
  end;
  UpdateScore();
end;

procedure TCricket_Game.Button1Click(Sender: TObject);
var i: Integer;
begin
     dart_thrown := 3;
     three_misses := 0;
     score := 0;
     next_number := 1;
     highest_unlocked := 6;
     for i := 1 to highest_unlocked do begin
         Labels[i].Transparent := True;
     end;
     for i := (highest_unlocked+1) to 20 do begin
         Labels[i].Transparent := False;
     end;
     Label23.Caption := 'Current Score: 0';
     Label23.Visible := true;
     Label22.Caption := 'Current Target: Bull';
     Label22.Visible := true;
     current_dart := 1;
     Button2.Visible := False;
     Label21.Caption := 'Throw Dart one of three';
     Label21.Visible := true;
     Last_pressed_button := 0;
     HandleButtons(0);
     AllTimeHighScore_Label.Visible := false;
end;

procedure TCricket_Game.Button2Click(Sender: TObject);
begin
     HandleButtons(2);
end;

procedure TCricket_Game.Button3Click(Sender: TObject);
begin
     HandleButtons(3);
end;

procedure TCricket_Game.Button4Click(Sender: TObject);
begin
     HandleButtons(4);
end;

procedure TCricket_Game.Button5Click(Sender: TObject);
begin
     HandleButtons(5);
end;

end.


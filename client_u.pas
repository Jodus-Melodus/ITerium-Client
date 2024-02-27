unit client_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, math, Vcl.Imaging.pngimage, ShellAPI,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  TfrmMain = class(TForm)
    pnlProfile: TPanel;
    pnlMarket: TPanel;
    pnlTrans: TPanel;
    imgProfile: TImage;
    lblBalance: TLabel;
    pctrlMain: TPageControl;
    tshtLogin: TTabSheet;
    tshtProfile: TTabSheet;
    rgrpLogin: TRadioGroup;
    ledtName: TDBLabeledEdit;
    ledtPassword: TLabeledEdit;
    btnLogin: TButton;
    procedure FormResize(Sender: TObject);
    procedure rgrpLoginClick(Sender: TObject);
  private
    sClientScriptPath : string;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure CallScript(const scriptPath : string; const parameters : string);
begin
  ShellExecute(0, 'open', PChar(scriptPath), PChar(parameters), nil, SW_HIDE);
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin

  sClientScriptPath := 'clientScript\bin\Debug\net8.0\clientScript.exe';

  frmMain.Height := frmMain.Width * 9 div 16;     //16:9 Aspect Ratio when adjusting width - E
  //frmMain.Width := frmMain.Height * 16 div 9;

  pnlProfile.Width := round(frmMain.Width / 3);   //Width of each panel - E
  pnlMarket.Width := round(frmMain.Width / 3);
  pnlTrans.Width := round(frmMain.Width / 3);

  pnlProfile.Left := 0;                           //Position of each panel - E
  pnlMarket.Left := pnlMarket.Width;
  pnlTrans.Left := pnlTrans.Width * 2;

  pnlProfile.Height := frmMain.Height;            //Height of each panel - E
  pnlMarket.Height := frmMain.Height;
  pnlTrans.Height := frmMain.Height;

  imgProfile.Width := round(pnlProfile.Width / 3);//Image position and size - E
  imgProfile.Height := imgProfile.Width;
  imgProfile.Left := round(pnlProfile.Width / 2) - round(imgProfile.Width / 2);
  imgProfile.Top := round(frmMain.Height / 12);

  lblBalance.AutoSize := true;                    //Label position and size - E
  lblBalance.Height := lblBalance.Width;
  lblBalance.Left := round(pnlProfile.Width / 2) - round(lblBalance.Width / 2);
  lblBalance.Top := round(frmMain.Height / 3);
  lblBalance.Font.Size := Round(6 * (Width / 400));

  pctrlMain.Left := 0;                            //PageControl position and size - E
  pctrlMain.Top := 0;
  pctrlMain.Width := frmMain.Width;
  pctrlMain.Height := frmMain.Height;

  rgrpLogin.Left := round(frmMain.Width/2) - Round(rgrpLogin.Width/2);  //Radio Group position and size
  rgrpLogin.Width := round(frmMain.Width/5);
  rgrpLogin.Height := Round(frmMain.Height/5);
  rgrpLogin.Top := round(frmMain.Height/12);

  ledtName.Left := round(frmMain.Width/2) - Round(ledtName.Width/2);    //Labeled Edits + Button positions and size
  ledtPassword.Left := Round(frmMain.Width/2) - Round(ledtPassword.Width/2);
  btnLogin.Left := Round(frmMain.Width/2) - Round(btnLogin.Width/2);
  ledtName.Top := Round(frmMain.Height/2.5);
  ledtPassword.Top := Round(frmMain.Height/2);
  btnLogin.Top := Round(frmMain.Height/1.5);

  CallScript(sClientScriptPath, 'marketplace'); //Delete? hehe
end;
procedure TfrmMain.rgrpLoginClick(Sender: TObject);
begin
  if (rgrpLogin.ItemIndex = 0) then
  begin
    tshtLogin.Caption := 'Sign up';
    btnLogin.Caption := 'Sign up';
  end;
  if (rgrpLogin.ItemIndex = 1) then
  begin
    tshtLogin.Caption := 'Login';
    btnLogin.Caption := 'Login';
  end;
end;

end.

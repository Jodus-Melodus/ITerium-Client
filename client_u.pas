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
    grpbHistory: TGroupBox;
    grpbMarket: TGroupBox;
    grpbTrans: TGroupBox;
    procedure rgrpLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  CallScript(sClientScriptPath, 'marketplace');

  tshtLogin.Width := frmMain.Width;
  tshtLogin.Height := frmMain.Height;
  tshtProfile.Width := frmMain.Width;
  tshtProfile.Height := frmMain.Height;

  pnlProfile.Width := round(tshtProfile.Width/3);
  pnlMarket.Width := round(tshtProfile.Width/3);
  pnlTrans.Width := round(tshtProfile.Width/3);

  pnlProfile.Left := 0;
  pnlMarket.Left := pnlMarket.Width;
  pnlTrans.Left := pnlMarket.Width*2;

  imgProfile.Left := Round(pnlProfile.Width/2) - Round(imgProfile.Width/2);
  lblBalance.Left := Round(pnlProfile.Width/2) - Round(lblBalance.Width/2);
  grpbHistory.Left := Round(pnlProfile.Width/2) - Round(grpbHistory.Width/2);

  rgrpLogin.Left := Round(tshtLogin.Width/2) - Round(rgrpLogin.Width/2);
  ledtName.Left := Round(tshtLogin.Width/2) - Round(ledtName.Width/2);
  ledtPassword.Left := Round(tshtLogin.Width/2) - Round(ledtPassword.Width/2);
  btnLogin.Left := Round(tshtLogin.Width/2) - Round(btnLogin.Width/2);

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

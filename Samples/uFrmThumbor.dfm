object frmThumbor: TfrmThumbor
  Left = 0
  Top = 0
  Caption = 'Thumbor'
  ClientHeight = 438
  ClientWidth = 1199
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    1199
    438)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 21
    Top = 23
    Width = 52
    Height = 13
    Caption = 'Secret Key'
  end
  object lbl2: TLabel
    Left = 21
    Top = 78
    Width = 93
    Height = 13
    Caption = 'Url Server Thumbor'
  end
  object lbl3: TLabel
    Left = 21
    Top = 186
    Width = 52
    Height = 13
    Caption = 'Image Size'
  end
  object lbl4: TLabel
    Left = 21
    Top = 132
    Width = 71
    Height = 13
    Caption = 'Url Path Image'
  end
  object imgThumbor: TImage
    Left = 702
    Top = 23
    Width = 475
    Height = 388
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = True
    ExplicitHeight = 481
  end
  object lbl5: TLabel
    Left = 79
    Top = 208
    Width = 6
    Height = 13
    Caption = 'X'
  end
  object edtSecretKey: TEdit
    Left = 21
    Top = 42
    Width = 268
    Height = 21
    TabOrder = 0
    TextHint = 'Secret Key'
  end
  object memUrl: TMemo
    Left = 21
    Top = 296
    Width = 660
    Height = 115
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 1
  end
  object edtUrlServerThumbor: TEdit
    Left = 21
    Top = 96
    Width = 268
    Height = 21
    TabOrder = 2
    TextHint = 'Url Server Thumbor'
  end
  object edtPathImage: TEdit
    Left = 21
    Top = 150
    Width = 660
    Height = 21
    TabOrder = 3
    TextHint = 'Url Path Image'
  end
  object chkUseSmart: TCheckBox
    Left = 168
    Top = 206
    Width = 97
    Height = 17
    Caption = 'Use Smart'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object btnGenerateByClass: TBitBtn
    Left = 21
    Top = 248
    Width = 217
    Height = 25
    Caption = 'Get Url Thumbor'
    TabOrder = 5
    OnClick = btnGenerateByClassClick
  end
  object edtWitdh: TSpinEdit
    Left = 21
    Top = 204
    Width = 52
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 300
  end
  object edtHeigth: TSpinEdit
    Left = 91
    Top = 204
    Width = 52
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 7
    Value = 0
  end
end

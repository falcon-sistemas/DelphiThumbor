object frmThumbor: TfrmThumbor
  Left = 0
  Top = 0
  Caption = 'Thumbor'
  ClientHeight = 481
  ClientWidth = 1095
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    1095
    481)
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
    Width = 371
    Height = 431
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = True
    ExplicitWidth = 475
    ExplicitHeight = 481
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
    Top = 352
    Width = 660
    Height = 102
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
  object btnGenerateByClass: TBitBtn
    Left = 21
    Top = 321
    Width = 217
    Height = 25
    Caption = 'Get Url Thumbor'
    TabOrder = 4
    OnClick = btnGenerateByClassClick
  end
  object grpParams: TGroupBox
    Left = 21
    Top = 187
    Width = 660
    Height = 126
    Caption = 'Parameters'
    TabOrder = 5
    object lbl3: TLabel
      Left = 13
      Top = 21
      Width = 52
      Height = 13
      Caption = 'Image Size'
    end
    object lbl5: TLabel
      Left = 71
      Top = 44
      Width = 6
      Height = 13
      Caption = 'X'
    end
    object lbl6: TLabel
      Left = 157
      Top = 21
      Width = 34
      Height = 13
      Caption = 'Quality'
    end
    object lbl7: TLabel
      Left = 13
      Top = 73
      Width = 36
      Height = 13
      Caption = 'Custom'
    end
    object chkUseSmart: TCheckBox
      Left = 250
      Top = 45
      Width = 80
      Height = 17
      Caption = 'Use Smart'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object edtWitdh: TSpinEdit
      Left = 13
      Top = 40
      Width = 52
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 300
    end
    object edtHeigth: TSpinEdit
      Left = 83
      Top = 40
      Width = 52
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object edtQuality: TSpinEdit
      Left = 157
      Top = 40
      Width = 73
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 90
    end
    object edtCustom: TEdit
      Left = 13
      Top = 92
      Width = 636
      Height = 21
      TabOrder = 4
      TextHint = 
        'Ex: 0x250/filters:quality(80):grayscale():round_corner(30,255,25' +
        '5,255)'
    end
  end
end

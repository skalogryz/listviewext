{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit listviewext;

{$warn 5023 off : no warning about unused units}
interface

uses
  ListViewAdd, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('listviewext', @Register);
end.

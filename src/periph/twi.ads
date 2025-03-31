with neorv32; use neorv32;

package Twi is
   procedure Init (Prsc : UInt3; Cdiv : UInt4; Clkstr : Bit);
   procedure Disable;
   procedure Enable;
   function Sense_SCL return Bit;
   function Sense_SDA return Bit;
   function Busy return Bit;
   function Get (Data : out Byte) return Bit;
end Twi;
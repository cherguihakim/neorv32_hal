with neorv32.Twi; use neorv32.Twi;
with neorv32; use neorv32;

package body Twi is 
   procedure Init(Prsc : UInt3; Cdiv : UInt4; Clkstr : Bit) is 
   begin
      -- Reset the TWI peripheral -- 
      TWI_Periph.CTRL.TWI_CTRL_EN := 0;
      TWI_Periph.CTRL.TWI_CTRL_PRSC := 0;
      TWI_Periph.CTRL.TWI_CTRL_CDIV := 0;
      TWI_Periph.CTRL.TWI_CTRL_CLKSTR := 0;
      TWI_Periph.CTRL.TWI_CTRL_FIFO := 0;
      TWI_Periph.CTRL.TWI_CTRL_SENSE_SCL := 0;
      TWI_Periph.CTRL.TWI_CTRL_SENSE_SDA := 0;
      TWI_Periph.CTRL.TWI_CTRL_TX_FULL := 0;
      TWI_Periph.CTRL.TWI_CTRL_RX_AVAIL := 0;
      TWI_Periph.CTRL.TWI_CTRL_BUSY := 0;

      -- Enable the TWI peripheral --
      TWI_Periph.CTRL.TWI_CTRL_EN := 1;
      TWI_Periph.CTRL.TWI_CTRL_PRSC := Prsc;
      TWI_Periph.CTRL.TWI_CTRL_CDIV := Cdiv;
      TWI_Periph.CTRL.TWI_CTRL_CLKSTR := Clkstr;
   end Init;

   procedure Disable is 
   begin
      TWI_Periph.CTRL.TWI_CTRL_EN := 0;
   end Disable;

   procedure Enable is 
   begin
      TWI_Periph.CTRL.TWI_CTRL_EN := 1;
   end Enable;

   function Sense_SCL return Bit is 
   begin
      return TWI_Periph.CTRL.TWI_CTRL_SENSE_SCL;
   end Sense_SCL;

   function Sense_SDA return Bit is
   begin
      return TWI_Periph.CTRL.TWI_CTRL_SENSE_SDA;
   end Sense_SDA;

   function Busy return Bit is
   begin
      return TWI_Periph.CTRL.TWI_CTRL_BUSY;
   end Busy;



end Twi;
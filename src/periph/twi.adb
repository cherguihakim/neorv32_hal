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

   function Get (Data : out Byte) return Bit is
   begin
      if TWI_Periph.CTRL.TWI_CTRL_RX_AVAIL = 0 then -- no data available
         return -1;
      end if;
      Data := TWI_Periph.DCMD.TWI_DCMD;
      return TWI_Periph.DCMD.TWI_DCMD_ACK;

   end Get;

   function Transfer (Data : in out Byte; MACK : Bit) return Bit is
      Rx_Data : Byte := 0;
      Device_Ack : Bit := 0;
   begin 
      while TWI_Periph.CTRL.TWI_CTRL_TX_FULL /= 0 loop -- wait for free TX entry
         null;
      end loop;
      Send_Nonblocking(Data, MACK); -- send adress + R/W + host/ACK
      loop
         Device_Ack := Get(Rx_Data);
         exit when Device_Ack /= -1; -- wait until data is available
      end loop;
      Data := Rx_Data;
      return Device_Ack;
   end Transfer;

   procedure Send_Nonblocking (Data : Byte; MACK : Bit) is
   begin
   end;

   --   --  Get received data and ACK status
   --  function Get (Data : out Unsigned_8) return Integer is
   --  begin
   --     if TWI_Periph.CTRL.TWI_CTRL_RX_AVAIL = 0 then
   --        return -1;  --  No data available
   --     end if;

   --     declare
   --        Dcmd : constant DCMD_Register := TWI_Periph.DCMD;
   --     begin
   --        Data := Dcmd.TWI_DCMD;
   --        return Integer(Dcmd.TWI_DCMD_ACK);
   --     end;
   --  end Get;

   --  --  Blocking transfer with data exchange
   --  function Transfer (Data : in out Unsigned_8; MACK : Boolean) return Integer is
   --     Rx_Data    : Unsigned_8;
   --     Device_Ack : Integer;
   --  begin
   --     --  Wait for TX FIFO space
   --     while TWI_Periph.CTRL.TWI_CTRL_TX_FULL = 1 loop
   --        null;
   --     end loop;

   --     --  Initiate transfer
   --     Send_Nonblocking (Data, MACK);

   --     --  Wait for response
   --     loop
   --        Device_Ack := Get (Rx_Data);
   --        exit when Device_Ack /= -1;
   --     end loop;

   --     --  Update data with received value
   --     Data := Rx_Data;
   --     return Device_Ack;
   --  end Transfer;




end Twi;
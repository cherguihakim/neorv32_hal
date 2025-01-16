with System.Machine_Code; use System.Machine_Code;
with System.Storage_Elements; use System.Storage_Elements;

with Interfaces.C; use Interfaces.C;

with Neorv32; use Neorv32;
with Neorv32.Uart0; use Neorv32.Uart0;

with Sysinfo; use Sysinfo;

with RISCV.Types; use RISCV.Types;
with RISCV.CSR; use RISCV.CSR;
with System.Storage_Elements; use System.Storage_Elements;

with Ada.Text_IO; use Ada.Text_IO;

package body Uart0 is

   procedure Init (Baud_Rate : Natural) is
      Reset : UInt32 with Volatile, Address => UART0_Periph.CTRL'Address;
      Baud_Div : Natural := Clk / (2 * Baud_Rate);
      Prsc_Sel : Natural := 0;
   begin
      Reset := 0;
      while Baud_Div >= 2#11_1111_1111# loop
         if Prsc_Sel = 2 or Prsc_Sel = 4 then
            Baud_Div := Baud_Div / 8;
         else
            Baud_Div := Baud_Div / 2;
         end if;
         Prsc_Sel := @ + 1;
      end loop;
      UART0_Periph.CTRL.UART_CTRL_PRSC := UInt3 (Prsc_Sel);
      UART0_Periph.CTRL.UART_CTRL_BAUD := UInt10 (Baud_Div - 1);
      UART0_Periph.CTRL.UART_CTRL_RX_CLR := 1;
      UART0_Periph.CTRL.UART_CTRL_TX_CLR := 1;
      UART0_Periph.CTRL.UART_CTRL_IRQ_RX_NEMPTY := 1;
      UART0_Periph.CTRL.UART_CTRL_EN := 1;
      MIE.Write (2#100_00000000_00000000#);
   end Init;

   function Read_RX return Character is
      UART_RX_TX : Character with Volatile, Address => UART0_Periph.Data'Address;
   begin
      return UART_RX_TX;
   end Read_RX;
   pragma Inline (Read_RX);

   procedure Write_TX (Value : UInt32) is
      UART_RX_TX : UInt32 with Volatile, Address => UART0_Periph.Data'Address;
   begin
      UART_RX_TX := Value;
   end Write_TX;
   pragma Inline (Write_TX);

   procedure Uart_Write (C : Character) is
   begin
      Write_Tx (Character'Pos (C));
   end Uart_Write;

   procedure Put_Char (C : Interfaces.C.char) with
     Export, Convention => C, External_Name => "putchar";

   procedure Put_Char (C : Interfaces.C.char) is
   begin
      while UART0_Periph.CTRL.UART_CTRL_TX_FULL = 1 loop
         null;
      end loop;
      Uart_Write (Interfaces.C.To_Ada (C));
   end Put_Char;

   procedure Echo_Uart_RX is
      C : Character;
   begin
      loop
         if UART0_Periph.CTRL.UART_CTRL_RX_NEMPTY = 1 then
            C := Read_RX;
            Put_Line (C'Image);
            exit;
         end if; 
      end loop;
   end Echo_Uart_RX;

end Uart0;
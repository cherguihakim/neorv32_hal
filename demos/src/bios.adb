with Ada.Text_IO; use Ada.Text_IO;

with RISCV.CSR; use RISCV.CSR;

with Interrupts;
with Uart0;
with Hooks;

procedure Bios is
begin
   Interrupts.Init;
   Interrupts.Install_Uart0_Rx_Interrupt_Handler (Hooks.Parse_Cmd'Access);

   Uart0.Init (19200);
   Mstatus.Set_Bits (2#1000#);

   Hooks.Show_ReLoad;
   
   loop
      null;
   end loop;
end Bios;

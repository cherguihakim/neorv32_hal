with Interrupts;
with Uart0;
with Hooks; use Hooks;

procedure Bios is
begin
   Interrupts.Init;
   Interrupts.Install_Uart0_Rx_Interrupt_Handler (Parse_Cmd'Access);
   Uart0.Init (19200);
   Interrupts.Global_Machine_Interrupt_Enable;
   Show_ReLoad;
   loop
      null;
   end loop;
end Bios;

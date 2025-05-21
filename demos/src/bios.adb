with Interrupts;
with Random;
with Uart0;
with Hooks; use Hooks;
with GPIO;
with Timer;

procedure Bios is
begin
   Interrupts.Init;
   Random.Init;
   Timer.Init;
   GPIO.Init;
   Interrupts.Install_Uart0_Rx_Interrupt_Handler (0, Parse_Cmd'Access);
   Uart0.Init (2000000);
   Interrupts.Global_Machine_Interrupt_Enable;
   Show_ReLoad;
   loop
      null;
   end loop;
end Bios;

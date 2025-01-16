with Ada.Text_IO; use Ada.Text_IO;

with RISCV.Types; use RISCV.Types;
with RISCV.CSR; use RISCV.CSR;

with System.Storage_Elements; use System.Storage_Elements;

with System.Machine_Code; use System.Machine_Code;
with System; use System;

with Ada.Text_IO; use Ada.Text_IO;

package body Interrupts is

   subtype Harts_T is Natural range 0 .. 0; 
   type Trap_Code_T is (
      Instruction_Misaligned,
      Instruction_Access,
      Instruction_Illegal,
      Breakpoint,
      Load_Misaligned,
      Load_Access,
      Store_Misaligned,
      Store_Access,
      User_Environment_Call,
      Machine_Environment_Call,
      Machine_Software_Interrupt,
      Machine_Timer_Interrupt,
      Machine_External_Interrupt,
      Fast_Interrupt_0,
      Fast_Interrupt_1,
      Fast_Interrupt_2,
      Fast_Interrupt_3,
      Fast_Interrupt_4,
      Fast_Interrupt_5,
      Fast_Interrupt_6,
      Fast_Interrupt_7,
      Fast_Interrupt_8,
      Fast_Interrupt_9,
      Fast_Interrupt_10,
      Fast_Interrupt_11,
      Fast_Interrupt_12,
      Fast_Interrupt_13,
      Fast_Interrupt_14,
      Fast_Interrupt_15,
      Default_Trap
   );
   for Trap_Code_T use (
      Instruction_Misaligned     => 16#00000000#,
      Instruction_Access         => 16#00000001#,
      Instruction_Illegal        => 16#00000002#,
      Breakpoint                 => 16#00000003#,
      Load_Misaligned            => 16#00000004#,
      Load_Access                => 16#00000005#,
      Store_Misaligned           => 16#00000006#,
      Store_Access               => 16#00000007#,
      User_Environment_Call      => 16#00000008#,
      Machine_Environment_Call   => 16#0000000B#,
      Machine_Software_Interrupt => 16#80000003#,
      Machine_Timer_Interrupt    => 16#80000007#,
      Machine_External_Interrupt => 16#8000000B#,
      Fast_Interrupt_0           => 16#80000010#,
      Fast_Interrupt_1           => 16#80000011#,
      Fast_Interrupt_2           => 16#80000012#,
      Fast_Interrupt_3           => 16#80000013#,
      Fast_Interrupt_4           => 16#80000014#,
      Fast_Interrupt_5           => 16#80000015#,
      Fast_Interrupt_6           => 16#80000016#,
      Fast_Interrupt_7           => 16#80000017#,
      Fast_Interrupt_8           => 16#80000018#,
      Fast_Interrupt_9           => 16#80000019#,
      Fast_Interrupt_10          => 16#8000001A#,
      Fast_Interrupt_11          => 16#8000001B#,
      Fast_Interrupt_12          => 16#8000001C#,
      Fast_Interrupt_13          => 16#8000001D#,
      Fast_Interrupt_14          => 16#8000001E#,
      Fast_Interrupt_15          => 16#8000001F#,
      Default_Trap               => 16#FFFFFFFF#
   );

   procedure Default_Handler is
   begin
      Put_Line ("Default handler called");
   end Default_Handler;

   type Handlers_T is array (Harts_T, Trap_Code_T) of Interrupt_Handler;
   Handlers : Handlers_T := (others => (others => Default_Handler'Access));

   procedure Install_Uart0_Rx_Interrupt_Handler (Handler : Interrupt_Handler) is
   begin
      Handlers (0, Fast_Interrupt_2) := Handler;
   end Install_Uart0_Rx_Interrupt_Handler;

   procedure Call_Handler is
      Hart_Id : Harts_T := Harts_T (RISCV.CSR.MHARTID.Read); 
      Trap_Code : Trap_Code_T := Trap_Code_T'Enum_Val (RISCV.CSR.MCAUSE.Read);
   begin
      Handlers (Hart_Id, Trap_Code).all;
   end Call_Handler;

   function Is_Exception return Boolean is
      (Shift_Right(RISCV.CSR.MCAUSE.Read, 31) = 0 and 
       Trap_Code_T'Enum_Val (RISCV.CSR.MCAUSE.Read) /= Instruction_Access);

   procedure Compute_Return_Address is
      Epc : UInt32 := RISCV.CSR.MEPC.Read + 4;
      ISA : UInt32 := RISCV.CSR.MISA.Read;
   begin
      if (ISA and 2#100#) = 1 then
         declare
            TINST : UInt32 := RISCV.CSR.MTINST.Read;
         begin
            if (TINST and 2#11#) /= 3 then
               Epc := @ - 2;
            end if;
         end;
      end if;
      RISCV.CSR.MEPC.Write (Epc);
   end Compute_Return_Address;

   procedure Isr with
     Export, Convention => C, External_Name => "isr";

   procedure Isr is
   begin
      Call_Handler;
      if Is_Exception then
         Compute_Return_Address;
      end if;
   end Isr;

   procedure trap_entry
   with Import, Convention => C, External_Name => "trap_entry";

   procedure Init is
   begin
      -- clear mstatus, set previous privilege level to machine-mode
      RISCV.CSR.Mstatus.Set_Bits (2#11000_00000000#);

      -- configure trap handler base address
      RISCV.CSR.Mtvec.Write (UInt32 (To_Integer (trap_entry'Address)));

      RISCV.CSR.Mie.Write (0);

      asm ("fence");
   end Init;

end Interrupts;
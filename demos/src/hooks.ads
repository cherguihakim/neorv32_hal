with Interrupts; use Interrupts;

Package Hooks is
   procedure Show_ReLoad;
   procedure Parse_Cmd (Hart : Harts_T; Trap_Code : Trap_Code_T);
   procedure Exit_Handler with
     Export, Convention => C, External_Name => "__gnat_exit";
end Hooks;
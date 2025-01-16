Package Hooks is
   procedure Show_ReLoad;
   procedure Parse_Cmd;
   procedure Exit_Handler with
     Export, Convention => C, External_Name => "__gnat_exit";
end Hooks;
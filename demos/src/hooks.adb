with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Handling; use Ada.Characters.Handling;

with Neorv32.Uart0;
with Neorv32;
with Uart0;

with Sysinfo;

package body Hooks is

   type Cmd_T is (Echo, Infos, Reload, Help, Unknown);
   Cmd : Cmd_T := Unknown;

   Yellow  : constant String := ASCII.ESC & "[1;38;2;255;200;0m";
   Magenta : constant String := ASCII.ESC & "[1;38;2;255;0;255m";
   Reset   : constant String := ASCII.ESC & "[0m";

   procedure Show_GAP_Logo is
   begin
      Put_Line (Yellow & "      _____   _____   _____  "        );
      Put_Line (         "     /  ___\ _\__  \ /  _  \ "        );
      Put_Line (         "    /  /_   /  _   //  /   / "        );
      Put_Line (         "   /  /  \ /   /  //  /   /  "        );
      Put_Line (         "  /  /_  //   /  //  ____/   "        );
      Put_Line (         " /      //   /  //  /        "        );
      Put_Line (         " \_____/ \_____/ \_/         "        );
      Put_Line (         "                             " & Reset);
      Put_Line (         "   Solidify your firmware!   ");
   end Show_GAP_Logo;

   procedure Show_Choice_Prompt is
   begin
      Put (Magenta & "Enter your choice >" & Reset);
   end Show_Choice_Prompt;

   procedure Show_Menu is
   begin
      New_Line;
      Put_Line ("========= Available Commands =========");
      Put_Line (" e: Echo your input");
      Put_Line (" i: System Infos.");
      Put_Line (" h: Help on commands.");
      Put_Line (" r: Reload the program.");
      Put_Line ("======================================");
      Show_Choice_Prompt;
   end Show_Menu;

   procedure Show_Input_Prompt is
   begin
      New_Line;
      Put (Magenta & ">" & Reset);
   end Show_Input_Prompt;

   procedure Show_ReLoad is
   begin
      New_Line;
      Show_GAP_Logo;
      Show_Menu;
   end Show_ReLoad;

   procedure Show_Infos is
   begin
      New_Line;
      Put_Line ("Main Clock Frequency: " & Sysinfo.Clk'Image);
      Show_Choice_Prompt;
   end Show_Infos;

   procedure Show_Unknown_Command is
   begin
      New_Line;
      Put_Line ("Unknown command! 'h' for help.");
      Show_Choice_Prompt;
   end Show_Unknown_Command;


   procedure Parse_Cmd is
      use Neorv32;
      Choice : Character;
      Command : Cmd_T := Unknown;
   begin
      loop
         if Neorv32.Uart0.UART0_Periph.CTRL.UART_CTRL_RX_NEMPTY = 1 then
            Choice := Uart0.Read_RX;
            if Cmd = Echo then
               Put_Line (Choice'Image);
               Cmd := Unknown;
               Show_Choice_Prompt;
            else
               Put (Choice);
               for C in Cmd_T'Range loop
                  declare
                     C_Str : constant String := C'Image;
                  begin
                     if Choice = To_Lower (C_Str (1)) then
                        Command := C;
                        exit;
                     end if;
                  end;
               end loop;
               case Command is
                  when Echo =>
                     Show_Input_Prompt;
                     Cmd := Echo;
                  when Infos =>
                     Show_Infos;
                  when Reload =>
                     Show_Reload;
                  when Help =>
                     Show_Menu;
                  when others =>
                     Show_Unknown_Command;
               end case;
            end if;
            exit;
         end if; 
      end loop;
   end Parse_Cmd;

   procedure Exit_Handler is
   begin
      loop
         null;  -- Stay in an infinite loop
      end loop;
   end Exit_Handler;
end Hooks;
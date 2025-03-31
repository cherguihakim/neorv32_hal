with Ada.Text_IO; use Ada.Text_IO;
with neorv32; use neorv32;
with Neorv32.Uart0;
with Uart0;
with Random; -- Pour générer des positions aléatoires
with Timer;
with GPIO; 

package body Shooter_Game is
   Screen_Width     : constant Positive := 20;     -- Largeur du jeu
   Screen_Height    : constant Positive := 10;     -- Hauteur du jeu
   Max_Projectiles  : constant := 5;               -- Nombre maximum de tirs
   Max_Enemies      : constant := 5;               -- Nombre d'ennemis
   Ship_Pos         : Integer := Screen_Width / 2; -- Position du vaisseau
   Running          : Boolean := True;             -- Variable pour contrôler la boucle du jeu
   Score            : Integer := 0;                -- Score du joueur
   Cyan             : constant String := ASCII.ESC & "[38;2;0;255;255m";
   Green            : constant String := ASCII.ESC & "[32m";
   Red              : constant String := ASCII.ESC & "[31m";
   Reset            : constant String := ASCII.ESC & "[0m";

   type Projectile is record
      X : Integer := 0;
      Y : Integer := 0;
      Active : Boolean := False;
   end record;

   type Enemy is record
      X : Integer;
      Y : Integer;
      Active : Boolean;
   end record;

   Projectiles : array (1 .. Max_Projectiles) of Projectile;

   Enemies : array (1 .. Max_Enemies) of Enemy :=
      (others => (X => 0, Y => 0, Active => False));
   
    -- Instancier le package générique pour générer des entiers aléatoires dans l'intervalle 1..100
   -- type randRange is new Integer range 1..Screen_Width;
   -- package Rand_Int is new ada.numerics.discrete_random(randRange);

   function randomN return Integer is
      num : Integer;
   begin
      num := Integer(Random.Random);
      num := num mod Screen_Width;
      return num;
   end randomN;

   procedure Draw_Screen is
   begin
      -- Effacer l'écran
      for I in 1 .. 20 loop
         Put_Line("");
      end loop;

      -- Afficher le score
      -- Set_Cursor(1, 1);
      Put("Score: ");
      Put(Integer'Image(Score));
      New_Line;

      -- Afficher l'écran de jeu
      for Row in reverse 1 .. Screen_Height loop
         for Col in 1 .. Screen_Width loop
            declare
               Drawn : Boolean := False;
            begin
               -- Afficher un projectile si présent
               for P of Projectiles loop
                  if P.Active and then P.X = Col and then P.Y = Row then
                     Put(Green & "|" & Reset);
                     Drawn := True;
                     exit;
                  end if;
               end loop;

               -- Afficher un ennemi si présent
               for E of Enemies loop
                  if E.Active and then E.X = Col and then E.Y = Row then
                     Put(Red & "X" & Reset);
                     Drawn := True;
                     exit;
                  end if;
               end loop;

               -- Afficher le vaisseau
               if not Drawn then
                  if Row = 1 and then Col = Ship_Pos then
                     Put(Cyan & "^" & Reset);
                  else
                     Put(" ");
                  end if;
               end if;
            end;
         end loop;
         New_Line;
      end loop;

      -- Afficher la ligne de sol
      for I in 1 .. Screen_Width loop
         Put("-");
      end loop;
      New_Line;
   end Draw_Screen;

   type Command is (Left, Shoot, Right, Quit, None);
   for Command use (Left => 0, Shoot => 1, Right => 2, Quit => 3, None => 4);

   function Read_Command return Command is
   begin
      if GPIO.Read_Pin (Command'Enum_Rep (Left)) then
         return Left;
      elsif GPIO.Read_Pin (Command'Enum_Rep (Shoot)) then
         return Shoot;
      elsif GPIO.Read_Pin (Command'Enum_Rep (Right)) then
         return Right;
      elsif GPIO.Read_Pin (Command'Enum_Rep (Quit)) then
         return Quit;
      else
         return None;
      end if;
   end;

   procedure Read_Input is
      Droite           : constant Integer := 2; -- Pin pour la direction droite
      Gauche           : constant Integer := 0; -- Pin pour la direction gauche
      Espace           : constant Integer := 1; -- Pin pour le tir
      Quitter          : constant Integer := 3; -- Pin pour quitter le jeu
      State            : Boolean := False;      -- Variable pour stocker l'état du bouton
   begin
      while not State loop
         if GPIO.Read_Pin(Gauche) = True and then Ship_Pos > 1 then
            Ship_Pos := Ship_Pos - 1;
            State := True;
         elsif GPIO.Read_Pin(Droite) = True and then Ship_Pos < Screen_Width then
            Ship_Pos := Ship_Pos + 1;
            State := True;
         elsif GPIO.Read_Pin(ESpace) = True then
            -- Ajouter un tir
            for P of Projectiles loop
               if not P.Active then
                  P.X := Ship_Pos;
                  P.Y := 2; -- Juste au-dessus du vaisseau
                  P.Active := True;
                  exit;
               end if;
            State := True; 
            end loop;
         elsif GPIO.Read_Pin(Quitter) = True then
            Running := False; -- Quitter le jeu
            State := True;
         end if;
      end loop;
   exception
      when others => null;
   end Read_Input;

   procedure Update_Projectiles is
   begin
      for P of Projectiles loop
         if P.Active then
            P.Y := P.Y + 1; -- Déplacer vers le haut
            if P.Y > Screen_Height then
               P.Active := False; -- Désactiver si en dehors de l’écran
            end if;
         end if;
      end loop;
   end Update_Projectiles;

   procedure Update_Enemies is
   begin
      for E of Enemies loop
         if E.Active then
            E.Y := E.Y - 1; -- Déplacer vers le bas
            if E.Y <= 0 then
               E.Active := False; -- Désactiver si en dehors de l’écran
            end if;
         end if;
      end loop;
   end Update_Enemies;

   procedure Spawn_Enemies is
   begin
      for E of Enemies loop
         if not E.Active then
            E.X := randomN;
            E.Y := Screen_Height; -- Pour que les ennemis puissent apparaitre 
            E.Active := True;
            exit;
         end if;
      end loop;
   end Spawn_Enemies;

   -- Logique de collision : si un projectile touche un ennemi
   procedure Check_Collisions is
   begin
      for P of Projectiles loop
         if P.Active then
            for E of Enemies loop
               if E.Active and then P.X = E.X and then P.Y = E.Y then
                  -- Désactiver l'ennemi et le projectile
                  E.Active := False;
                  P.Active := False;
                  -- Augmenter le score
                  Score := Score + 1;
                  --exit;  -- Sortir dès qu'une collision est détectée
               end if;
               if E.Active and then E.X = Ship_Pos and then E.Y = 1 then
                  -- Si un ennemi touche le vaisseau, le jeu est terminé
                  Running := False;
                  exit;
               end if;
            end loop;
         end if;
      end loop;
   end Check_Collisions;

   procedure Game is
      Cmd : Command := None;
   begin
      loop
         exit when not Running; -- Quitter la boucle si Running = False
         Spawn_Enemies;  -- Spawner de nouveaux ennemis
         Draw_Screen;
         Update_Projectiles;
         Update_Enemies;
         Check_Collisions;
         Timer.Init;
         Timer.Wait (10);
         Read_Input;
      end loop;

      Put_Line("Oops, vous avez perdu !!");
      Put(" Votre Score: ");
      Put(Integer'Image(Score));
      New_Line;
      Running := True;
   end Game;

end Shooter_Game;

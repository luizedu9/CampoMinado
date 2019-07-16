Program CampoMinado;

{|--------------------------|
 |       CAMPO MINADO       |
 |   LUIZ EDUARDO PEREIRA   |
 | INTRODU��O A PROGRAMA��O |
 |      1� P�RIODO          |
 |  CI�NCIA DA COMPUTA��O   |
 |--------------------------|}
 
//ESTE JOGO FOI CRIADO E COMPILADO USANDO: PASCALZIM - VERS�O 6.0.1.
//Para uma correta execu��o, favor usar o mesmo.

Uses CRT;

Var
  MatrizC: array[1..9, 1..9] of char; //Matriz que mostra o campo do jogo;
  MatrizB: array[1..9, 1..9] of Boolean; //Matriz Booleana, receber� True para livre e False para Bomba;
  CoordX, CoordY, X, Y, ContBomba, Menu, ContV, Numero, IBomba: integer;
  //CoordX = Coordenada de X / ContBomba = Contador do la�o para quantidade de Bombas / ContV = Contador para Vitoria;
	//Numero = Variavel que armazena quantas bombas est�o em sua volta - USADO NO PROCEDURE / IBomba = Contador de quantas bombas n�o foram encontradas;
  RepeticaoMenu: char;
  CorBloq: Boolean; //Colocar cor no Bloqueio no final do jogo;

//Procedimento para Moldura-----------------------------------------------------------------------------------------------------------------------------------
Procedure Moldura;
  Var
    X, Y: integer;
  Begin
    TextColor (LightGreen);
    For X := 2 To 79 Do
      Begin
        For Y := 2 To 24 Do
          Begin
            GotoXY (X, Y);
            If ((X = 2) or (X = 79) or (Y = 2) or (Y = 24))
              Then
                Writeln (chr(219));
          End;
      End;
  End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
//Procedimento para o Campo Visual----------------------------------------------------------------------------------------------------------------------------
Procedure Campo;
  Begin //Mostra o Campo do Jogo, sempre que uma jogada for feita, o campo ser� atualizado
    GotoXY (33, 4);
    TextColor (Yellow);
    Write ('CAMPO MINADO!');
    GotoXY (34, 7);
    TextColor (Yellow); 
    Write (chr(201), '123456789', chr(187));
    GotoXY (35, 17);
    Write ('123456789');    
    GotoXY (34, 17);
    Write (chr(200));
    GotoXY (44, 17);
    Write (chr(188));
    TextColor (LightGreen);
    For Y := 1 To 9 Do //For para colocar o caractere da matriz 9X9
      Begin
        GotoXY (34, (Y + 7));
        TextColor (Yellow);
        Write (chr((48) + Y)); //N�meros na tabela ASCII
        GotoXY ((34 + 10), (Y + 7));
        TextColor (Yellow);
        Write (chr((48) + Y));
        TextColor (LightGreen);
				GotoXY (35, (Y + 7));
        For X := 1 To 9 Do //For para colocar o caractere da matriz 9X9
          Begin
					  If ((MatrizC[X, Y] = chr(15)) or (MatrizC[X, Y] = chr(245))) //Se igual a Bomba ou Bloqueio, caractere vermelho;         
              Then Begin
                     If ((CorBloq = True) and (MatrizC[X, Y] = chr(245))) //Se Jogada Final for igual Bloqueio, e o mesmo n�o possuir bomba, caractere amarelo
						           Then
						             TextColor (Yellow)
                       Else
											   TextColor (Red);
							       Write (MatrizC[X, Y]);
							     End
						  Else Begin //Se diferente de Bomba ou Bloqueio, caractere verde;
										 TextColor (LightGreen);
							       Write (MatrizC[X, Y]);
							     End;
          End;
      End;
      TextColor (Red);
      GotoXY(4, 23);
      Write ('          ');
      GotoXY(4, 23);
      Write (chr(15), ' = ', IBomba); //Mostra a quantidade de bombas que ainda falta
      TextColor (Yellow);
  End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------  

//Coordenadas X e Y-------------------------------------------------------------------------------------------------------------------------------------------
Procedure CX; //Procedure para usuario digitar a coordenada de X
  Begin
    Repeat //Repeat para Coordenadas de X, repetir� at� X possuir um valor correto
      GotoXY (27, 20);
      Write ('Digite a Coordenada da Coluna: ');
			Read (X);
			GotoXY (58, 20);
			Write ('             ');
			GotoXY (1, 21);
			Write (' ');
	    If ((X < 0) or (X > 10)) //Mensagem quando digitar coordenada errada
	      Then Begin
	             GotoXY (31, 21);
	             TextColor (Red);
	             Write ('POSI��O INCORRETA');
	             TextColor (Yellow);
	             Delay (700);
	             GotoXY (31, 21);
	             Write ('                       ');
	           End;
		Until ((X <= 10) and (X >= 0));
	End;
	
Procedure CY; //Procedure para usuario digitar a coordenada de Y
  Begin
		Repeat //Repeat para Coordenadas de Y, repetir� at� Y possuir um valor correto
      GotoXY (27, 20);
      Write ('Digite a Coordenada da Linha: ');
		  Read (Y);
			GotoXY (57, 20);
			Write ('            ');
			GotoXY (1, 21);
			Write (' ');
			If ((Y < 0) or (Y > 10)) //Mensagem quando digitar coordenada errada
	      Then Begin
	             GotoXY (31, 21);
	             TextColor (Red);
	             Write ('POSI��O INCORRETA');
	             TextColor (Yellow);
	             Delay (700);
	             GotoXY (31, 21);
	             Write ('                       ');
	           End;
		Until ((Y <= 10) and (Y >= 0)); 
  End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------

//Procedimento para Verificar Bomba---------------------------------------------------------------------------------------------------------------------------
Procedure VerificaBomba;	  
  Begin
    CorBloq := FALSE;
    If (MatrizB[X, Y] = False) //Verificador de Bomba
      Then Begin
             TextColor (Red);
             CorBloq := TRUE;
             MatrizC[X, Y] := chr(15); //Se Matriz Booleana � false, entao Matriz Campo recebe o caractere de Bomba;
             For Y := 1 To 9 Do //Revela as outras Bombas presentes no campo;
               For X := 1 To 9 Do
                 Begin
                   If (MatrizB[X, Y] = False)
                     Then
                       MatrizC[X, Y] := chr(15);
                 End;
             GotoXY (23, 22);
             Write ('BOWWW!!! VOC� COMETEU UM ERRO TRIVIAL');
             TextColor (LightGreen);
             RepeticaoMenu := 'N';
           End;
  End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------

//Procedimento para Checar Vitoria----------------------------------------------------------------------------------------------------------------------------
Procedure Vitoria;
  Begin
    ContV := 0;
	  For CoordY := 1 To 9 Do
	    For CoordX := 1 To 9 Do
	      Begin
	        If ((MatrizC[CoordX, CoordY] <> (chr(15))) and (MatrizC[CoordX, CoordY] <> (chr(254))) and (MatrizC[CoordX, CoordY] <> (chr(245)))) 
	          Then                                                                   //Se diferente de Bomba, Bloqueio e caractere Quadrado, ContV := +1
	            ContV := ContV + 1;						           
	      End;
	  If (ContV = 71) //Se ContV n�o ultrapassar ou ser inferior a 71, significa que todos os campos livres foram descobertos, e... Vitoria
		  Then Begin
		         TextColor (Red);
		         GotoXY (34, 22);
		         Write ('VOC� VENCEU');
		         For Y := 1 To 9 Do //Revela as Bombas presentes no campo;
               For X := 1 To 9 Do
                 Begin
                   If (MatrizB[X, Y] = False)
                     Then
                       MatrizC[X, Y] := chr(15);
                 End; 
		       End;
	End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------						   

 
//Procedimentos para fazer a Verifica��o em Volta-------------------------------------------------------------------------------------------------------------
{EXEMPLO DA COMPARA��O
 | 1 | 2 | 3 |
 | 4 |X Y| 6 |
 | 7 | 8 | 9 | 				
 Verifica se existe bomba em volta, se houver, aparecera a quantidade de bombas que h� em volta;}
				
Procedure V1;
  Begin
	  If (MatrizB[(X - 1), (Y - 1)] = FALSE) //1
	    Then
		    Numero := Numero + 1;
	End;
	
Procedure V2;
  Begin	
    If (MatrizB[X, (Y - 1)] = FALSE) //2
		  Then
		    Numero := Numero + 1;
	End;
	
Procedure V3;
  Begin
		If (MatrizB[(X + 1), (Y - 1)] = FALSE) //3
		  Then
		    Numero := Numero + 1;
	End;
	
Procedure V4;
	Begin
	  If (MatrizB[(X - 1), Y] = FALSE) //4
	    Then
	      Numero := Numero + 1;
	End;
	
Procedure V6;
  Begin	
	  If (MatrizB[(X + 1), Y] = FALSE) //6
			Then
			  Numero := Numero + 1;
	End;

Procedure V7;
  Begin
		If (MatrizB[(X - 1), (Y + 1)] = FALSE) //7
		  Then
		    Numero := Numero + 1;
	End;

Procedure V8;
  Begin	
		If (MatrizB[X, (Y + 1)] = FALSE) //8
		  Then
		    Numero := Numero + 1;
  End;
  
Procedure V9;
  Begin
		If (MatrizB[(X + 1), (Y + 1)] = FALSE) //9
		  Then
		    Numero := Numero + 1;
	End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------
          
//Procedimento para Verificar N�mero--------------------------------------------------------------------------------------------------------------------------
Procedure VerificaNumero;
  Begin //A fun��o verifica as posi��es em sua volta, mas � necessario colocar uma condi��o, pois a verifica��o n�o pode passar do limite da matriz;
        //Foi necessaria essa compara��o, pois quando verificar as bordas, a matriz n�o pode atingir posi��o 0 ou 10;
    If ((X <> 1) and (X <> 9) and (Y <> 1) and (Y <> 9)) //Verifica Todos
      Then Begin
             V1;
             V2;
             V3; 
             V4;
             V6;
             V7;
             V8;
             V9;               
           End
      Else If ((X = 1) and (Y = 1)) //Ponta - Deixa de Verificar Pela Esquerda e Superior
             Then Begin
                    V6;
                    V8;
                    V9;
                  End
             Else If ((X = 1) and (Y = 9)) //Ponta - Deixa de Verificar Pela Esqueda e Inferior
                    Then Begin
                           V2;
                           V3;
                           V6;
                         End
                    Else If ((X = 9) and (Y = 1)) //Ponta - Deixa de Verificar Pela Direita e Superior 
                           Then Begin
                                  V4;
                                  V7;
                                  V8;
                                End
                           Else If ((X = 9) and (Y = 9)) //Ponta - Deixa de Verificar Pela Direita e Inferior
                                  Then Begin
                                         V1;
                                         V2;
                                         V4;
                                       End
                                  Else If (X = 1) //Beirada - Deixa de Verificar pela Esquerda
                                         Then Begin
                                                V2;
                                                V3;
                                                V6;
                                                V8;
                                                V9;
                                              End
                                         Else If (X = 9) //Beirada - Deixa de Verificar pela Direita
                                                Then Begin
                                                       V1;
                                                       V2;
                                                       V4;
                                                       V7;
                                                       V8;
                                                     End
                                                Else If (Y = 1) //Beirada - Deixa de Verificar o Superior
                                                       Then Begin
                                                              V4;
                                                              V6;
                                                              V7;
                                                              V8;
                                                              V9;
                                                            End
                                                       Else If (Y = 9) //Beirada - Deixa de Verificar o Inferior
                                                              Then Begin
                                                                     V1;
                                                                     V2;
                                                                     V3;
                                                                     V4;
                                                                     V6;
                                                                   End;                                      
  End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------           

//Procedimento para Colocar N�mero----------------------------------------------------------------------------------------------------------------------------           
Procedure ColocaNumero;
	Begin //Verifica��o para colocar o n�mero de Bombas em volta na tela; 
		If (Numero = 0) 
		  Then          
		    MatrizC[X, Y] := chr(255) //Caractere Nulo;
  	  Else If (Numero = 1) 
        	   Then
		           MatrizC[X, Y] := '1'
             Else If (Numero = 2)
		                Then
		                  MatrizC[X, Y] := '2'
                    Else If (Numero = 3)
		                       Then
		                         MatrizC[X, Y] := '3'
		                       Else If (Numero = 4)
		                              Then
		                                MatrizC[X, Y] := '4'
		                              Else If (Numero = 5)
		                                     Then
        		                               MatrizC[X, Y] := '5' 
														  	         Else If (Numero = 6)
		                                            Then
		                                              MatrizC[X, Y] := '6'	 
																	  		        Else If (Numero = 7)
		                                                   Then
		                                                     MatrizC[X, Y] := '7'    
																				  	           Else If (Numero = 8)
		                                                          Then
		                                                            MatrizC[X, Y] := '8';
		Numero := 0; //Zera o contador de n�mero																			 																				  
  End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------	    

//Bloqueio de Posi��o-----------------------------------------------------------------------------------------------------------------------------------------
Procedure Bloqueio;
  //O Procedimento Bloqueio verifica se o jogador digitou 10, em seguida, o jogador digita a posi��o que quer bloquear ou desbloquear
  Begin
    GotoXY (30, 19);
    TextColor (Red);
    Write ('MODO BLOQUEIO/DESBLOQUEIO');
    TextColor (Yellow);
		CX;
		If (X <> 0) //Se for 0, o programa finaliza a execu��o
		  Then
		    CY
		  Else
		    Y := -1; //Somente para que no proximo comando, Y n�o seja igual a 0
		If ((X = 0) or (Y = 0)) //Sair do Jogo durante a execu��o
		  Then
		    RepeticaoMenu := '0'
		  Else If ((X <> 10) and (Y <> 10)) //Se digitar 10 com o modo bloqueio ativado, nada acontece
		         Then If (MatrizC[X, Y] = chr(245)) //Desbloqueia o campo, s� � possivel desbloquear se posi��o � igual a caractere bloqueio
		                Then Begin
		                       MatrizC[X, Y] := chr(254);
		                       IBomba := IBomba + 1;
		                     End
		                Else If (MatrizC[X, Y] = chr(254)) //Bloqueia o campo, s� � possivel bloquear se posi��o � igual a caractere quadrado
		                       Then Begin
		                              MatrizC[X, Y] := chr(245);
		                              IBomba := IBomba - 1;
		                            End;
		GotoXY (30, 19);
    Write ('                         ');      
  End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------						   


//************************************************************************************************************************************************************
Begin //INICIO DO PROGRAMA

  Randomize; //Para gerar fun��es PSEUDOALEAT�RIAS
  ClrScr;

  Repeat //REPEAT DO MENU
  
    If (RepeticaoMenu = 'N') //Se repeti��o recebe N, ent�o o programa encerra
      Then
        Menu := 4
      Else Begin //Inicio do Menu
             ClrScr;
             Moldura;              
             GotoXY (33, 5);
             TextColor (YELLOW);
             Writeln ('CAMPO MINADO');
             GotoXY (34, 12);
             Writeln ('1 - Jogar');
             GotoXY (34, 13);
             Writeln ('2 - Instru��es');
             GotoXY (34, 14);
             Writeln ('3 - Cr�ditos');
             GotoXY (34, 15);
             Writeln ('4 - Sair');
             GotoXY (39, 11);
             TextColor (LightGreen);
             Readln (Menu);
           End;
      
    Case Menu Of //MENU
    
//JOGAR-------------------------------------------------------------------------------------------------------------------------------------------------------  
      1: Begin 
      
           ClrScr;
           Moldura;
           
           //PRIMEIRA EXECU�AO--------------------------------------------------------------------------------------------------------------------------------
           For CoordY := 1 To 9 Do //ATRIBUI��O DE CAMPO SEM BOMBA
             For CoordX := 1 To 9 Do
               Begin
                 MatrizC[CoordX, CoordY] := chr(254); //Atribui��o do Caractere 'Quadrado'
                 MatrizB[CoordX, CoordY] := True; //Atribui��o de Campo Livre, ou seja, sem Bomba
               End;
      
           ContBomba := 1;
           While (ContBomba <= 10) Do //ATRIBUI��O DE FALSE PARA CAMPO COM BOMBA
             Begin
               CoordX := Random(9) + 1; //Ramdom para colocar a Bomba em uma posi��o PSEUDOALEAT�RIA
               CoordY := Random(9) + 1;
               If (MatrizB[CoordX, CoordY] = True) //If para n�o repetir posi��o
                 Then
                   MatrizB[CoordX, CoordY] := False
                 Else
								   ContBomba := ContBomba - 1;
							 Inc(ContBomba);                         
             End; 
             
           IBomba := 10; //Indice de Bombas, diminuira quando um bloqueio for usado
           
					 CorBloq := FALSE; //Cor inicial do bloqueio, vermelho
           //-------------------------------------------------------------------------------------------------------------------------------------------------
           
           //INICIO DO JOGO-----------------------------------------------------------------------------------------------------------------------------------
           Repeat
             
             TextColor (LightGreen);
             Campo;
             TextColor (Yellow);
             
						 CX; //Mostra para o usuario digitar a Coordenada de X (Coluna)						 
						 If ((X <> 10) and (X <> 0)) //Se X for 10 ou 0, n�o � necessario pegar o valor de Y
						   Then
						     CY //Mostra para o usuario digitar a Coordenada de Y (Linha)
						   Else
						     Y := -1; //Somente para que no proximo comando, Y n�o seja igual a 0
						 
						 If ((X = 0) or (Y = 0)) //Sair do Jogo durante a execu��o
						   Then
						     RepeticaoMenu := '0'
						   Else If (((X = 10) or (Y = 10))) //Iniciar modo Bloqueio
						          Then
						            Bloqueio
										  Else If (MatrizC[X, Y] <> chr(245)) //Se posi��o n�o estiver bloqueada, seleciona-la
											       Then Begin
		                                VerificaBomba; //Verifica se h� bomba na posi��o
		                                VerificaNumero; //Verifica se h� n�mero na posi��o
						                        ColocaNumero; //Coloca o n�mero na posi��o
										              End;
										
						 Campo;
						 
						 Vitoria; //Checa se o jogador venceu, se sim, abondona o la�o
						 If (ContV = 71)
						   Then Begin
						          Campo;
						          Break;
						        End;
						   						       
           Until ((RepeticaoMenu = '0') or (RepeticaoMenu = 'N'));
           //-------------------------------------------------------------------------------------------------------------------------------------------------
           
					 TextColor (Yellow);
					                                  
           Repeat //REPETIR EXECU��O
					   GotoXY (24, 1);
             Write ('Deseja Jogar Novamente? (S / N) ');
             Read (RepeticaoMenu);
             RepeticaoMenu := UpCase(RepeticaoMenu); //Transforma para Letra Mai�scula
             GotoXY (56, 1);
             Write ('    ');
           Until ((RepeticaoMenu = 'S') or (RepeticaoMenu = 'N') or (RepeticaoMenu = '0'));
           
         End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------   
      
//INSTRU��ES--------------------------------------------------------------------------------------------------------------------------------------------------       
      2: Begin
       
           ClrScr;
           Moldura;
           
           //P�gina 1
           GotoXY (35, 4);  
           TextColor (LightGreen);
           Write ('INSTRU��ES');
           TextColor (Yellow);
           GotoXY (5, 6);
           Write (chr(15), ' Campo Minado � um jogo que tem como objectivo revelar um campo de minas');
           GotoXY (5, 7);
					 Write ('sem que nenhuma seja detonada. ');
           GotoXY (5, 9);
           Write (chr(15), ' A �rea de jogo consiste num campo de quadrados 9X9.');
           GotoXY (5, 11);
           Write (chr(15), ' Cada quadrado pode ser revelado digitando sua coordenada equivalente ao');
           GotoXY (5, 12);
           Write ('campo. Primeiro digite a posi��o da coluna (X, Horizontal), depois digite');
           GotoXY (5, 13);
           Write ('a posi��o da linha (Y, Vertical).');
           GotoXY (5, 15);
           Write (chr(15), ' Se o quadrado selecionado contiver uma mina, ent�o o jogo acaba.');
           GotoXY (5, 17);
           Write (chr(15), ' Se o quadrado n�o possuir uma mina, um campo vazio ou um n�mero aparece');
           GotoXY (5, 19);
           Write (chr(15), ' O n�mero indica a quantidade de quadrados adjacentes que cont�m minas.');
           GotoXY (5, 21);
           Write (chr(15), ' O campo vazio indica que nos quadrados adjacentes n�o h� minas.');
					 TextColor (Red);
					 GotoXY (38, 23);
					 Write ('1 / 2');
					 GotoXY (1, 1);
					 ReadKey;
					 
					 ClrScr;
					 Moldura;
					 
					 //P�gina 2
           TextColor (Yellow);
           GotoXY (5, 4);
           Write (chr(15), ' O jogo � ganho quando todos os quadrados sem minas s�o revelados.');
           GotoXY (36, 7);
           TextColor (LightGreen);
					 Write ('COMANDOS:');
					 TextColor (Yellow);
           GotoXY (5, 9);
           Write (chr(15), ' 1 / 9 - Coordenadas da coluna e linha.');
           GotoXY (5, 11);
           Write (chr(15), ' 0 - Parar a execu��o do jogo.');
           GotoXY (5, 13);
           Write (chr(15), ' 10 - Bloqueio/Desbloqueio.');
           GotoXY (5, 15);
           Write (chr(15), ' A op��o de bloqueio � util para travar um determinado campo em que h� a');
           GotoXY (5, 16);
           Write ('suspeita de mina. Um campo bloqueado n�o poder� ser escolhido. Para Blo_');
           GotoXY (5, 17);
           Write ('quear ou desbloquear, digite 10 e em seguida as coordenadas do campo.');
           TextColor (LightGreen);
           GotoXY (36, 20);
           Write ('BOM JOGO!');
					 TextColor (Red);
					 GotoXY (38, 23);
					 Write ('2 / 2');
					 GotoXY (1, 1);
					 ReadKey;

         End; 
//------------------------------------------------------------------------------------------------------------------------------------------------------------ 
      
//CR�DITOS----------------------------------------------------------------------------------------------------------------------------------------------------
      3: Begin
           
           ClrScr;
           Moldura;
           TextColor (Yellow);
           GotoXY (31, 10);
           Write ('LUIZ EDUARDO PEREIRA');
           GotoXY (29, 12);
           Write ('INTRODU��O A PROGRAMA��O');           
           GotoXY (36, 14);
           Write ('1', chr(167), ' PER�ODO');           
           GotoXY (31, 16);
           Write ('CI�NCIA DA COMPUTA��O');
           GotoXY (1, 1);
           ReadKey;
    
         End; 
//------------------------------------------------------------------------------------------------------------------------------------------------------------   
      
//SAIR--------------------------------------------------------------------------------------------------------------------------------------------------------       
      4: Begin
           For CoordX := 1 To 80 Do
             Begin
               Delay (30);
               For CoordY := 1 To 25 Do
                 Begin
                   GotoXY (CoordX, CoordY);
                   TextColor (Random(50));
                   Writeln (chr(219));
                   GotoXY (1, 1);
                 End;
             End;             
           Exit;
         End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------	  

//ELSE--------------------------------------------------------------------------------------------------------------------------------------------------------       
      Else //Se digitar um n�mero para menu errado
			  Begin
          For CoordX := 1 To 80 Do
            Begin
              TextColor (Red);
			  	    GotoXY (20, 8);
              Writeln ('VOC� TEM PROBLEMA MENTAL? ESCOLHA DE 1 A 4');
              GotoXY (1, 1);
              Delay (22);
            End;            
        End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------
    
		End; //End do Case
             
  Until (RepeticaoMenu = '0');

End.
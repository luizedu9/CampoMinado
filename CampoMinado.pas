Program CampoMinado;

{|--------------------------|
 |       CAMPO MINADO       |
 |   LUIZ EDUARDO PEREIRA   |
 | INTRODUÇÃO A PROGRAMAÇÃO |
 |      1º PÉRIODO          |
 |  CIÊNCIA DA COMPUTAÇÃO   |
 |--------------------------|}
 
//ESTE JOGO FOI CRIADO E COMPILADO USANDO: PASCALZIM - VERSÃO 6.0.1.
//Para uma correta execução, favor usar o mesmo.

Uses CRT;

Var
  MatrizC: array[1..9, 1..9] of char; //Matriz que mostra o campo do jogo;
  MatrizB: array[1..9, 1..9] of Boolean; //Matriz Booleana, receberá True para livre e False para Bomba;
  CoordX, CoordY, X, Y, ContBomba, Menu, ContV, Numero, IBomba: integer;
  //CoordX = Coordenada de X / ContBomba = Contador do laço para quantidade de Bombas / ContV = Contador para Vitoria;
	//Numero = Variavel que armazena quantas bombas estão em sua volta - USADO NO PROCEDURE / IBomba = Contador de quantas bombas não foram encontradas;
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
  Begin //Mostra o Campo do Jogo, sempre que uma jogada for feita, o campo será atualizado
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
        Write (chr((48) + Y)); //Números na tabela ASCII
        GotoXY ((34 + 10), (Y + 7));
        TextColor (Yellow);
        Write (chr((48) + Y));
        TextColor (LightGreen);
				GotoXY (35, (Y + 7));
        For X := 1 To 9 Do //For para colocar o caractere da matriz 9X9
          Begin
					  If ((MatrizC[X, Y] = chr(15)) or (MatrizC[X, Y] = chr(245))) //Se igual a Bomba ou Bloqueio, caractere vermelho;         
              Then Begin
                     If ((CorBloq = True) and (MatrizC[X, Y] = chr(245))) //Se Jogada Final for igual Bloqueio, e o mesmo não possuir bomba, caractere amarelo
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
    Repeat //Repeat para Coordenadas de X, repetirá até X possuir um valor correto
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
	             Write ('POSIÇÃO INCORRETA');
	             TextColor (Yellow);
	             Delay (700);
	             GotoXY (31, 21);
	             Write ('                       ');
	           End;
		Until ((X <= 10) and (X >= 0));
	End;
	
Procedure CY; //Procedure para usuario digitar a coordenada de Y
  Begin
		Repeat //Repeat para Coordenadas de Y, repetirá até Y possuir um valor correto
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
	             Write ('POSIÇÃO INCORRETA');
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
             MatrizC[X, Y] := chr(15); //Se Matriz Booleana é false, entao Matriz Campo recebe o caractere de Bomba;
             For Y := 1 To 9 Do //Revela as outras Bombas presentes no campo;
               For X := 1 To 9 Do
                 Begin
                   If (MatrizB[X, Y] = False)
                     Then
                       MatrizC[X, Y] := chr(15);
                 End;
             GotoXY (23, 22);
             Write ('BOWWW!!! VOCÊ COMETEU UM ERRO TRIVIAL');
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
	  If (ContV = 71) //Se ContV não ultrapassar ou ser inferior a 71, significa que todos os campos livres foram descobertos, e... Vitoria
		  Then Begin
		         TextColor (Red);
		         GotoXY (34, 22);
		         Write ('VOCÊ VENCEU');
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

 
//Procedimentos para fazer a Verificação em Volta-------------------------------------------------------------------------------------------------------------
{EXEMPLO DA COMPARAÇÃO
 | 1 | 2 | 3 |
 | 4 |X Y| 6 |
 | 7 | 8 | 9 | 				
 Verifica se existe bomba em volta, se houver, aparecera a quantidade de bombas que há em volta;}
				
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
          
//Procedimento para Verificar Número--------------------------------------------------------------------------------------------------------------------------
Procedure VerificaNumero;
  Begin //A função verifica as posições em sua volta, mas é necessario colocar uma condição, pois a verificação não pode passar do limite da matriz;
        //Foi necessaria essa comparação, pois quando verificar as bordas, a matriz não pode atingir posição 0 ou 10;
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

//Procedimento para Colocar Número----------------------------------------------------------------------------------------------------------------------------           
Procedure ColocaNumero;
	Begin //Verificação para colocar o número de Bombas em volta na tela; 
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
		Numero := 0; //Zera o contador de número																			 																				  
  End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------	    

//Bloqueio de Posição-----------------------------------------------------------------------------------------------------------------------------------------
Procedure Bloqueio;
  //O Procedimento Bloqueio verifica se o jogador digitou 10, em seguida, o jogador digita a posição que quer bloquear ou desbloquear
  Begin
    GotoXY (30, 19);
    TextColor (Red);
    Write ('MODO BLOQUEIO/DESBLOQUEIO');
    TextColor (Yellow);
		CX;
		If (X <> 0) //Se for 0, o programa finaliza a execução
		  Then
		    CY
		  Else
		    Y := -1; //Somente para que no proximo comando, Y não seja igual a 0
		If ((X = 0) or (Y = 0)) //Sair do Jogo durante a execução
		  Then
		    RepeticaoMenu := '0'
		  Else If ((X <> 10) and (Y <> 10)) //Se digitar 10 com o modo bloqueio ativado, nada acontece
		         Then If (MatrizC[X, Y] = chr(245)) //Desbloqueia o campo, só é possivel desbloquear se posição é igual a caractere bloqueio
		                Then Begin
		                       MatrizC[X, Y] := chr(254);
		                       IBomba := IBomba + 1;
		                     End
		                Else If (MatrizC[X, Y] = chr(254)) //Bloqueia o campo, só é possivel bloquear se posição é igual a caractere quadrado
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

  Randomize; //Para gerar funções PSEUDOALEATÓRIAS
  ClrScr;

  Repeat //REPEAT DO MENU
  
    If (RepeticaoMenu = 'N') //Se repetição recebe N, então o programa encerra
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
             Writeln ('2 - Instruções');
             GotoXY (34, 14);
             Writeln ('3 - Créditos');
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
           
           //PRIMEIRA EXECUÇAO--------------------------------------------------------------------------------------------------------------------------------
           For CoordY := 1 To 9 Do //ATRIBUIÇÃO DE CAMPO SEM BOMBA
             For CoordX := 1 To 9 Do
               Begin
                 MatrizC[CoordX, CoordY] := chr(254); //Atribuição do Caractere 'Quadrado'
                 MatrizB[CoordX, CoordY] := True; //Atribuição de Campo Livre, ou seja, sem Bomba
               End;
      
           ContBomba := 1;
           While (ContBomba <= 10) Do //ATRIBUIÇÃO DE FALSE PARA CAMPO COM BOMBA
             Begin
               CoordX := Random(9) + 1; //Ramdom para colocar a Bomba em uma posição PSEUDOALEATÓRIA
               CoordY := Random(9) + 1;
               If (MatrizB[CoordX, CoordY] = True) //If para não repetir posição
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
						 If ((X <> 10) and (X <> 0)) //Se X for 10 ou 0, não é necessario pegar o valor de Y
						   Then
						     CY //Mostra para o usuario digitar a Coordenada de Y (Linha)
						   Else
						     Y := -1; //Somente para que no proximo comando, Y não seja igual a 0
						 
						 If ((X = 0) or (Y = 0)) //Sair do Jogo durante a execução
						   Then
						     RepeticaoMenu := '0'
						   Else If (((X = 10) or (Y = 10))) //Iniciar modo Bloqueio
						          Then
						            Bloqueio
										  Else If (MatrizC[X, Y] <> chr(245)) //Se posição não estiver bloqueada, seleciona-la
											       Then Begin
		                                VerificaBomba; //Verifica se há bomba na posição
		                                VerificaNumero; //Verifica se há número na posição
						                        ColocaNumero; //Coloca o número na posição
										              End;
										
						 Campo;
						 
						 Vitoria; //Checa se o jogador venceu, se sim, abondona o laço
						 If (ContV = 71)
						   Then Begin
						          Campo;
						          Break;
						        End;
						   						       
           Until ((RepeticaoMenu = '0') or (RepeticaoMenu = 'N'));
           //-------------------------------------------------------------------------------------------------------------------------------------------------
           
					 TextColor (Yellow);
					                                  
           Repeat //REPETIR EXECUÇÃO
					   GotoXY (24, 1);
             Write ('Deseja Jogar Novamente? (S / N) ');
             Read (RepeticaoMenu);
             RepeticaoMenu := UpCase(RepeticaoMenu); //Transforma para Letra Maiúscula
             GotoXY (56, 1);
             Write ('    ');
           Until ((RepeticaoMenu = 'S') or (RepeticaoMenu = 'N') or (RepeticaoMenu = '0'));
           
         End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------   
      
//INSTRUÇÕES--------------------------------------------------------------------------------------------------------------------------------------------------       
      2: Begin
       
           ClrScr;
           Moldura;
           
           //Página 1
           GotoXY (35, 4);  
           TextColor (LightGreen);
           Write ('INSTRUÇÕES');
           TextColor (Yellow);
           GotoXY (5, 6);
           Write (chr(15), ' Campo Minado é um jogo que tem como objectivo revelar um campo de minas');
           GotoXY (5, 7);
					 Write ('sem que nenhuma seja detonada. ');
           GotoXY (5, 9);
           Write (chr(15), ' A área de jogo consiste num campo de quadrados 9X9.');
           GotoXY (5, 11);
           Write (chr(15), ' Cada quadrado pode ser revelado digitando sua coordenada equivalente ao');
           GotoXY (5, 12);
           Write ('campo. Primeiro digite a posição da coluna (X, Horizontal), depois digite');
           GotoXY (5, 13);
           Write ('a posição da linha (Y, Vertical).');
           GotoXY (5, 15);
           Write (chr(15), ' Se o quadrado selecionado contiver uma mina, então o jogo acaba.');
           GotoXY (5, 17);
           Write (chr(15), ' Se o quadrado não possuir uma mina, um campo vazio ou um número aparece');
           GotoXY (5, 19);
           Write (chr(15), ' O número indica a quantidade de quadrados adjacentes que contêm minas.');
           GotoXY (5, 21);
           Write (chr(15), ' O campo vazio indica que nos quadrados adjacentes não há minas.');
					 TextColor (Red);
					 GotoXY (38, 23);
					 Write ('1 / 2');
					 GotoXY (1, 1);
					 ReadKey;
					 
					 ClrScr;
					 Moldura;
					 
					 //Página 2
           TextColor (Yellow);
           GotoXY (5, 4);
           Write (chr(15), ' O jogo é ganho quando todos os quadrados sem minas são revelados.');
           GotoXY (36, 7);
           TextColor (LightGreen);
					 Write ('COMANDOS:');
					 TextColor (Yellow);
           GotoXY (5, 9);
           Write (chr(15), ' 1 / 9 - Coordenadas da coluna e linha.');
           GotoXY (5, 11);
           Write (chr(15), ' 0 - Parar a execução do jogo.');
           GotoXY (5, 13);
           Write (chr(15), ' 10 - Bloqueio/Desbloqueio.');
           GotoXY (5, 15);
           Write (chr(15), ' A opção de bloqueio é util para travar um determinado campo em que há a');
           GotoXY (5, 16);
           Write ('suspeita de mina. Um campo bloqueado não poderá ser escolhido. Para Blo_');
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
      
//CRÉDITOS----------------------------------------------------------------------------------------------------------------------------------------------------
      3: Begin
           
           ClrScr;
           Moldura;
           TextColor (Yellow);
           GotoXY (31, 10);
           Write ('LUIZ EDUARDO PEREIRA');
           GotoXY (29, 12);
           Write ('INTRODUÇÃO A PROGRAMAÇÃO');           
           GotoXY (36, 14);
           Write ('1', chr(167), ' PERÍODO');           
           GotoXY (31, 16);
           Write ('CIÊNCIA DA COMPUTAÇÃO');
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
      Else //Se digitar um número para menu errado
			  Begin
          For CoordX := 1 To 80 Do
            Begin
              TextColor (Red);
			  	    GotoXY (20, 8);
              Writeln ('VOCÊ TEM PROBLEMA MENTAL? ESCOLHA DE 1 A 4');
              GotoXY (1, 1);
              Delay (22);
            End;            
        End;
//------------------------------------------------------------------------------------------------------------------------------------------------------------
    
		End; //End do Case
             
  Until (RepeticaoMenu = '0');

End.
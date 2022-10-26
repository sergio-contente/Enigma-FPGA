# Projeto de Laboratório Digital 2: Enigma-FPGA

## Funcionalidades:

  O projeto consiste em realizar uma adaptação moderna da máquina Enigma utilizada pelos alemães para codificar mensagens durante a WW II. Para tal feito, é necessário compreender como que ela funciona a priori:
  - Keyboard: Recebe o sinal de entrada vindo do usuário, manda o sinal elétrico da letra teclada para o resto do circuito.
   
  - Plugboard: Serve para trocar pares de letras de maneira direta (X -> Y) ou manter a letra recebida em sua saída (X -> X).

  - 3 Rotores: Servem para modificar os contatos entre si de tal forma que a letra de entrada e saída variam de acordo rotação dos eixos

  - Refletor: Serve para refletir o sinal recebido do último rotor e enviar novamente para os mesmos até atingir o Plugboard (no total são 7 permutações que ocorrem).

  - Lightboard: É o teclado que recebe o sinal de saída do circuito, acendendo a letra correspondente ao valor cifrado do inicial. A letra varia em um total de 7 a 9 vezes durante o circuito.
 
 Além disso, o valor a ser codficado consiste no dado serial obtido através do sonar desenvolvido pelo grupo durante as experiências de Laboratório Digital II em 2022. Isso se dá utilizando um sensor de distância ultrassônico HSC-R04, um servo motor de posição, comunicação serial com 11500 bauds transmtida por cabos VGA.
 
### Principais componentes:
  - Keyboard: utilizando a transmissão serial do teclado do computador para a FPGA.
  - Plugboard: Deve receber serialmente um vetor de tamanho fixo (13x2) com a configuração pré-definida pelo usuário
  - Rotores: Vamos ter 8 componentes de rotores, sendo que será necessário utilizar 3 DEMUXs de 8 para 1 sendo que cada um diz respeito a posição do rotor na Enigma (esquerda, meio ou direita). Cada rotor gira de um modo diferente, o qual garante diferentes modos de combinar (diferente do anel, esse daqui muda o contato e não a ligação).
  - Anel: Subcomponente do rotor; ele deve ser capaz de mapear os sinais internos realizando as combinações de letras através dos ligamentos internos.
  - Refletor: Recebe 26 inputs, e faz correspondência com 26 outputs, no caminho inverso;
  - Lightboard: responsável por enviar serialmente uma letra criptografada, a qual- através do protocolo MQTT - será mostrada em uma plataforma web;
 
## Não-funcionalidades:
  - Máquina facilmente reconfigurável
  - Levar em consideração o delay proveniente da comunicação através do protocolo MQTT, ao se confecionar os estados da máquina.

## Pseudocódigo:
### Keyboard
### Plugboard
### Rotores
### Anel
### Refletor
### Lightboard
  Será implementado numa plataforma web, com a framework React.js

* No Splash Screen antes da fase começar:
- Aumentar o tempo de exposição do splash screen para que tenha a mesma duração do arquivo de audio

* Em A1
- Os dois últimos profs. Candango estão muito próximos e com as falas bugadas. Pode retirar um deles. Ou ambos, caso não der certo de arrumar a fala deles.

* Em A4
- O belingerante que surge do lado esquerdo está ficando preso do lado esquerdo da tela. Podemos retirar da esquerda da tela e deixa-lo no buraco onde estão as moedas.

* Em A5
- O posicionamento que você mudou para as contas ficou bom, porque daí a mensagem do chefe pode aparecer com mais clareza. Mas dificulta para derrotar os inimigos. Eu havia projetado essa parte contando que os inimigos seriam mortos quando se tocasse nos blocos, sem isso o jogador fica sobrecarregado tentando matar os inimigos e fazendo as contas ao mesmo tempo.
- Podemos diminuir a frequência de spawn dos inimigos. Após um tempo eles se tornam overwhelming para o jogador, atrapalhando demais as contas. Será que podemos colocar uma limitação, tipo, Máximo de 4 inimigos na tela? Enquanto tiver 4 inimigos não vai ter mais spawn deles.
	>>> Implementado, mas nao resolve o problema... vou aumentar o timer

* Questões mais gerais:
- Quando caio pula em blocos muito próximos da cabeça dele, o som de pular não é ativado.
- A música das fases está com uma pausa entre os loops. Mas acho que eu editei mal o audio. Vou verificar
- Preciso verificar uma alternativa para dar loop no background. Quando pulamos muito alto ou caímos no buraco dá pra ver o "fim" do mundo, sabe? Quebra a imersão. Vou pensar em uma alternativa.
- O volume padrão dos efeitos sonoros está muito alto em comparação com a música.
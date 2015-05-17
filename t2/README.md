# T2

Um dos grandes desafios do desenvolvimento de software é a possibilidade de
entregar software de forma contínua para os interessados. É bem melhor poder
entregar pedaços funcionais do que está sendo desenvolvido para que os
usuários já possam testar tais funcionalidades do que entregar todas as
funcionalidades somente no final.

Porém, após estar com o software em produção, como podemos gerenciar esse
tipo de entrega? Além disso, como podemos prever como nossa entrega contínua
irá se comportar?

Para isso, podemos representar os componentes da entrega contínua através de
modelos SAN.

## Feature

Uma `feature` é um pedaço do software que está sendo desenvolvido. À partir de uma `feature`
que surgirá uma possível nova versão de produção. Porém, uma
`feature` só pode ser uma candidata à versão de produção se passar em todos
os testes de desenvolvimento (que podem ser testes automatizados, por exemplo).

Inicialmente, toda a feature está em estado Alpha, que significa que a mesma
ainda não entrou em produção.
Quando uma feature recebe algum commit, esse commit passa por uma bateria
de testes que, se aprovados, fazem com que a feature em questão gere uma
possível versão de produção (entrando então em estado Beta).
A partir de um estado Beta, uma feature pode ser rejeitada ou falhada,
gerando os estados "Beta Falha" e "Beta Aceita", respectivamente.

|Tipo    |Evento            |Taxa|
|--------|------------------|----|
|**loc** |`commit          `|1   |
|**loc** |`teste fail      `|1   |
|*SYN*   |`pronto para RC  `|1   |
|*SYN*   |`RC rejeitada    `|1   |
|*SYN*   |`Versão promovida`|1   |

## Produção

Consideramos como produção uma versão estável do nosso software, por
estável entendemos que é uma versão que passou nos testes de feature e que
que passou nos testes de produção (testes de integração e de aceitação
por usuário, por exemplo) para ser uma versão de produção.
Sempre que uma feature entre em estado Beta, são feitos os testes
de produção, caso esses testes passem, uma nova versão de produção é
gerada, caso contrário, essa versão é rejeitada, e a versão de produção
não é promovida.

|Tipo  |Evento            |Taxa|
|------|------------------|----|
|*SYN* |`pronto para RC  `|1   |
|*SYN* |`RC rejeitada    `|1   |
|*SYN* |`Versão promovida`|1   |

--------------

# Opção 2

## Developer

Durante o desenvolvimento de um feature (`Dev`), o desenvolvedor realiza diversos `commit`s. Ao finalizar, é feito o `pull request`. Esta ação irá disparar a execução de testes automatizados em um servidor de integração contínua (`CI running`). O servidor, por sua vez, poderá retornar falha (`CI fails`), obrigando o desenvolvedor à realizar novos `commit`s corretivos; ou então pode retornar sucesso (`CI passes`), indicando que aquele `pull request` está pronto (`Ready`) para ser mesclado com o código de produção. Neste momento, o desenvolvedor ainda tem o poder de rejeitar (`reject`) o `pull request` ou de enviá-lo para produção (`merge`). Quando aquele código já foi mesclado à produção (`Merged`), o desenvolvedor pode realizar novos `commit`s, o que iniciará um novo ciclo no estado inicial (`Dev`).

|Tipo    |Evento            |Taxa|
|--------|------------------|----|
|**loc** |`commit          `|1   |
|**loc** |`pull request    `|1   |
|**loc** |`CI fails        `|1   |
|**loc** |`CI passes       `|1   |
|**loc** |`reject          `|1   |
|*SYN*   |`merge           `|1   |

## Main Repository

Ao realizar o `merge` (evento sincronizante), o código que está no repositório principal precisa ser testado por um tester (`Testing`). Após realizar os testes de aceitação, o tester pode rejeitá-las (`rollback`), fazendo com que o estado do repositório volte ao último de produção estável. O tester também pode aceitar as alterações (`success`), levando o repositório ao estado de homologação (`staging`). Após os requisitos de homologação serem todos cumpridos, é realizado o `deploy` para produção.

|Tipo    |Evento            |Taxa|
|--------|------------------|----|
|**loc** |`deploy          `|1   |
|**loc** |`success         `|1   |
|**loc** |`rollback        `|1   |
|*SYN*   |`merge           `|1   |

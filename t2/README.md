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

## Produção

Consideramos como produção uma versão estável do nosso software, por
estável entendemos que é uma versão que passou nos testes de feature e que
que passou nos testes de produção (testes de integração e de aceitação
por usuário, por exemplo) para ser uma versão de produção.
Sempre que uma feature entre em estado Beta, são feitos os testes
de produção, caso esses testes passem, uma nova versão de produção é
gerada, caso contrário, essa versão é rejeitada, e a versão de produção
não é promovida.

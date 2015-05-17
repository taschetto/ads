Um dos grandes desafios do desenvolvimento de software é a gerência do workflow do processo de desenvolvimento. O uso de técnicas como sistemas de versionamento, servidores de integração contínua, equipes ágeis, entre outras, buscam garantir a qualidade do software entregue às partes interessadas.

Porém, com o advento das equipes distribuídas trabalhando em um mesmo projeto, ocorre um aumento da complexidade na gerência e controle do processo. Para validar o processo e estimar o impacto que o mesmo terá no andamento do projeto. é possível representar os componentes através de
modelos SAN.

## Modelagem SAN

### Developer

Durante o desenvolvimento (`Dev`) de uma feature, o desenvolvedor realiza diversos `commit`'s. Após, é feito o `pull request`. Esta ação irá disparar a execução de testes automatizados em um servidor de integração contínua (`CI running`). O servidor, por sua vez, poderá retornar falha (`CI fails`), levando aquele código ao estado de falha (`Failed`), obrigando o desenvolvedor à realizar novos `commit`'s corretivos; ou então pode retornar sucesso (`CI passes`), indicando que aquele `pull request` está pronto (`Ready`) para ser mesclado com o código de produção. Neste momento, o desenvolvedor ainda tem o poder de rejeitar (`reject`) o `pull request`, levando ao estado de rejeitado (`Rejected`) e tendo que realizar novos `commit`'s para prosseguir; ou de enviá-lo para produção (`merge`). Quando aquele código já foi mesclado à produção (`Merged`), o desenvolvedor pode realizar novos `commit`'s, o que iniciará um novo ciclo de desenvolvimento (`Dev`).

|Tipo    |Evento            |Taxa|
|--------|------------------|----|
|**loc** |`commit          `|1   |
|**loc** |`pull request    `|1   |
|**loc** |`CI fails        `|1   |
|**loc** |`CI passes       `|1   |
|**loc** |`reject          `|1   |
|*SYN*   |`merge           `|1   |

### Main Repository

Ao realizar o `merge` (evento sincronizante), o código que está no repositório principal precisa ser testado por um tester (`Testing`). Após realizar os testes de aceitação, o tester pode rejeitá-las (`rollback`), fazendo com que o estado do repositório volte ao último de produção estável. O tester também pode aceitar as alterações (`success`), levando o repositório ao estado de homologação (`staging`). Após os requisitos de homologação serem todos cumpridos, é realizado o `deploy` para produção.

|Tipo    |Evento            |Taxa|
|--------|------------------|----|
|**loc** |`deploy          `|1   |
|**loc** |`success         `|1   |
|**loc** |`rollback        `|1   |
|*SYN*   |`merge           `|1   |

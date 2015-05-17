Pontifícia Universidade Católica do Rio Grande do Sul
Faculdade de Informática
Curso de Ciência da Computação
Discilina de Análise de Desempenho de Sistemas

**Guilherme Taschetto e William Martins**
Porto Alegre, 18 de maio de 2015

### SAN - Stochastic Automata Network

Um dos grandes desafios do desenvolvimento de software é a gerência do workflow do processo de desenvolvimento. O uso de técnicas como sistemas de versionamento, servidores de integração contínua, equipes ágeis, entre outras, buscam garantir a qualidade do software entregue às partes interessadas.

Porém, com o advento das equipes distribuídas trabalhando em um mesmo projeto, ocorre um aumento da complexidade na gerência e controle do processo. Para validar o processo e estimar o impacto que o mesmo terá no andamento do projeto. é possível representar os componentes através de modelos SAN.

### Modelagem SAN

#### Developer

Durante o desenvolvimento (`Dev`) de uma feature, o desenvolvedor realiza diversos `commit`'s. Após, é feito o `pull request`. Esta ação irá disparar a execução de testes automatizados em um servidor de integração contínua (`CI running`). O servidor, por sua vez, poderá retornar falha (`CI fails`), levando aquele código ao estado de falha (`Failed`), obrigando o desenvolvedor à realizar novos `commit`'s corretivos; ou então pode retornar sucesso (`CI passes`), indicando que aquele `pull request` está pronto (`Ready`) para ser mesclado com o código de produção. Neste momento, o desenvolvedor ainda tem o poder de rejeitar (`reject`) o `pull request`, levando ao estado de rejeitado (`Rejected`) e tendo que realizar novos `commit`'s para prosseguir; ou de enviá-lo para produção (`merge`). Quando aquele código já foi mesclado à produção (`Merged`), o desenvolvedor pode realizar novos `commit`'s, o que iniciará um novo ciclo de desenvolvimento (`Dev`).

|Tipo    |Evento            |Taxa|
|--------|------------------|----|
|**loc** |`commit          `|1   |
|**loc** |`pull request    `|1   |
|**loc** |`CI fails        `|1   |
|**loc** |`CI passes       `|1   |
|**loc** |`reject          `|1   |
|*SYN*   |`merge           `|1   |

#### Main Repository

Ao realizar o `merge` (evento sincronizante), o código que está no repositório principal precisa ser testado por um tester (`Testing`). Após realizar os testes de aceitação, o tester pode rejeitá-las (`rollback`), fazendo com que o estado do repositório volte ao último de produção estável. O tester também pode aceitar as alterações (`success`), levando o repositório ao estado de homologação (`staging`). Após os requisitos de homologação serem todos cumpridos, é realizado o `deploy` para produção.

|Tipo    |Evento            |Taxa|
|--------|------------------|----|
|**loc** |`deploy          `|1   |
|**loc** |`success         `|1   |
|**loc** |`rollback        `|1   |
|*SYN*   |`merge           `|1   |

### Representação Gráfica dos Autômatos

![enter image description here](https://www.dropbox.com/s/rf8t2z12392ffnm/drawing.svg?dl=1)

### Arquivo de Modelagem SAN com 3 Desenvolvedores

```
identifiers
  TAXA = 1

events
  loc commit1 (TAXA);
  loc pull_request1 (TAXA);
  loc ci_fails1 (TAXA);
  loc ci_passes1 (TAXA);
  loc reject1 (TAXA);

  loc commit2 (TAXA);
  loc pull_request2 (TAXA);
  loc ci_fails2 (TAXA);
  loc ci_passes2 (TAXA);
  loc reject2 (TAXA);

  loc commit3 (TAXA);
  loc pull_request3 (TAXA);
  loc ci_fails3 (TAXA);
  loc ci_passes3 (TAXA);
  loc reject3 (TAXA);

  loc deploy (TAXA);
  loc success (TAXA);
  loc rollback (TAXA);
  syn merge (TAXA);

partial reachability = ((st D1 == DEV) && (st D2 == DEV) && (st D3 == DEV) && (st M == PRODUCTION));

network DEVS (continuous)
  aut D1
    stt DEV to (DEV) commit1
    stt DEV to (CI_RUNNING) pull_request1
    stt CI_RUNNING to (FAILED) ci_fails1
    stt CI_RUNNING to (READY) ci_passes1
    stt FAILED to (DEV) commit
    stt READY to (REJECTED) reject1
    stt REJECTED to (DEV) commit
    stt READY to (MERGED) merge
    stt MERGED to (DEV) commit1

  aut D2
    stt DEV to (DEV) commit2
    stt DEV to (CI_RUNNING) pull_request2
    stt CI_RUNNING to (FAILED) ci_fails2
    stt CI_RUNNING to (READY) ci_passes2
    stt FAILED to (DEV) commit
    stt READY to (REJECTED) reject2
    stt REJECTED to (DEV) commit
    stt READY to (MERGED) merge
    stt MERGED to (DEV) commit2

  aut D3
    stt DEV to (DEV) commit3
    stt DEV to (CI_RUNNING) pull_request3
    stt CI_RUNNING to (FAILED) ci_fails3
    stt CI_RUNNING to (READY) ci_passes3
    stt FAILED to (DEV) commit
    stt READY to (REJECTED) reject3
    stt REJECTED to (DEV) commit
    stt READY to (MERGED) merge
    stt MERGED to (DEV) commit3

  aut M
    stt PRODUCTION to (TESTING) merge
    stt TESTING to (PRODUCTION) rollback
    stt TESTING to (STAGING) success
    stt STAGING to (PRODUCTION) deploy

results

D1_DEV = (st D1 == DEV);
D1_CI_RUNNING = (st D1 == CI_RUNNING);
D1_FAILED = (st D1 == FAILED);
D1_READY = (st D1 == READY);
D1_REJECTED = (st D1 == REJECTED);
D1_MERGED = (st D1 == MERGED);

D2_DEV = (st D2 == DEV);
D2_CI_RUNNING = (st D2 == CI_RUNNING);
D2_FAILED = (st D2 == FAILED);
D2_READY = (st D2 == READY);
D2_REJECTED = (st D2 == REJECTED);
D2_MERGED = (st D2 == MERGED);

D3_DEV = (st D3 == DEV);
D3_CI_RUNNING = (st D3 == CI_RUNNING);
D3_FAILED = (st D3 == FAILED);
D3_READY = (st D3 == READY);
D3_REJECTED = (st D3 == REJECTED);
D3_MERGED = (st D3 == MERGED);

M_PRODUCTION = (st M == PRODUCTION);
M_TESTING = (st M == TESTING);
M_STAGING = (st M == STAGING);

DEV_DEV_DEV = ((st D1 == DEV) && (st D2 == DEV) && (st D3 == DEV));
MERGED_MERGED_MERGED = ((st D1 == MERGED) && (st D2 == MERGED) && (st D3 == MERGED));
```

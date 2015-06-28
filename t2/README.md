Pontifícia Universidade Católica do Rio Grande do Sul
Faculdade de Informática
Curso de Ciência da Computação
Discilina de Análise de Desempenho de Sistemas

**Guilherme Taschetto e William Martins**
Porto Alegre, 15 de junho de 2015

## SAN - Stochastic Automata Network

Um dos grandes desafios do desenvolvimento de software é a gerência do workflow do processo de desenvolvimento. O uso de técnicas como sistemas de versionamento, servidores de integração contínua, equipes ágeis, entre outras, buscam garantir a qualidade do software entregue às partes interessadas.

Porém, com o advento das equipes distribuídas trabalhando em um mesmo projeto, ocorre um aumento da complexidade na gerência e controle do processo. Para validar o processo e estimar o impacto que o mesmo terá no andamento do projeto. é possível representar os componentes através de modelos SAN.

## Modelagem SAN

### Developer

Durante o desenvolvimento (`Dev`) de uma feature, o desenvolvedor dispara a execução de testes (`r1`). Esta ação irá disparar a execução de testes automatizados em um servidor de integração contínua (`Running`). O servidor, por sua vez, poderá retornar falha (`f1`), levando aquele código ao estado de falha (`Failed`), obrigando o desenvolvedor à realizar novos commits (`c1`) corretivos; ou então pode retornar sucesso (`p1`), indicando que aquele código está pronto (`Ready`) para ser mesclado com o código de produção. Neste momento, o desenvolvedor ainda tem o poder de realizar novos commits (`c1`); ou de enviá-lo para produção (`mer`). Quando aquele código já foi mesclado à produção (`Merged`), o desenvolvedor pode realizar novos commits (`c1`), o que iniciará um novo ciclo de desenvolvimento (`Dev`).

Como cada desenvolvedor possui indicadores de qualidade de seu software e desempenho distintos, as taxas de cada um são distintas. Aqui simularemos 3 desenvolvedores.

#### Developer #01

|Tipo    |Evento            |Taxa  |Descrição              |
|--------|------------------|-----:|-----------------------|
|**loc** |`c1              `|8     | commits               |
|*SYN*   |`f1              `|1     | CI retorna falha      |
|*SYN*   |`p1              `|0.5   | CI retorna sucesso    |
|*SYN*   |`r1              `|4     | Dispara testes        |
|*SYN*   |`merge           `|16    |                       |

#### Developer #02

|Tipo    |Evento            |Taxa  |Descrição              |
|--------|------------------|-----:|-----------------------|
|**loc** |`c2              `|2     | commits               |
|*SYN*   |`f2              `|0.3333| CI retorna falha      |
|*SYN*   |`p2              `|0.25  | CI retorna sucesso    |
|*SYN*   |`r2              `|2.6667| Dispara testes        |
|*SYN*   |`merge           `|16    |                       |

#### Developer #03

|Tipo    |Evento            |Taxa  |Descrição              |
|--------|------------------|-----:|-----------------------|
|**loc** |`c3              `|4     | commits               |
|*SYN*   |`f3              `|0.6667| CI retorna falha      |
|*SYN*   |`p3              `|0.3333| CI retorna sucesso    |
|*SYN*   |`r3              `|16    | Dispara testes        |
|*SYN*   |`merge           `|16    |                       |

### Main Repository

Ao realizar o `merge` (evento sincronizante), o código que está no repositório principal precisa ser testado por um tester (`Testing`). Após realizar os testes de aceitação, o tester pode rejeitá-las (`rollback`), fazendo com que o estado do repositório volte ao último de produção estável. O tester também pode aceitar as alterações (`success`), levando o repositório ao estado de homologação (`staging`). Após os requisitos de homologação serem todos cumpridos, é realizado o `deploy` para produção.

|Tipo    |Evento            |Taxa  |Descrição              |
|--------|------------------|-----:|-----------------------|
|**loc** |`dep             `|0.0667| deploy                |
|**loc** |`suc             `|1     | testes dão sucesso    |
|**loc** |`rol             `|0.3337| testes falham         |
|*SYN*   |`mer             `|16    | mescla código devs    |


### Continuous Integration Server

Quando um desenvolvedor inicia a execução dos testes automáticos (`r1`, `r2`, `r3`), o servidor de integração contínua sai do estado ocioso (`Idle`) e passa a execução dos testes (`Running`). No fim, quando o teste finaliza, ele retorna sucesso (`p1`, `p2`, `p3`) ou falha (`f1`, `f2`, `f3`) e retorna ao estado de ocioso (`Idle`), ficando disponível para a execução novamente.

Um detalhe interessante é que todos os desenvolvedores compartilham e concorrem pela execução do servidor de integração contínua.

|Tipo    |Evento            |Taxa  |Descrição              |
|--------|------------------|-----:|-----------------------|
|*SYN*   |`f1              `|1     | falha Dev #01         |
|*SYN*   |`p1              `|0.5   | sucesso Dev #01       |
|*SYN*   |`r1              `|4     | executa Dev #01       |
|*SYN*   |`f2              `|0.3333| falha Dev #02         |
|*SYN*   |`p2              `|0.25  | sucesso Dev #02       |
|*SYN*   |`r2              `|2.6667| executa Dev #02       |
|*SYN*   |`f3              `|0.6667| falha Dev #03         |
|*SYN*   |`p3              `|0.3333| sucesso Dev #03       |
|*SYN*   |`r3              `|16    | executa Dev #03       |


## Representação Gráfica dos Autômatos

![Modelagem](https://www.dropbox.com/s/rf8t2z12392ffnm/drawing.svg?dl=1)

## Arquivo de Modelagem SAN com 3 Desenvolvedores

```
identifiers
  UN = 480; // minutos de trabalhos por dia

  TAXA_COMMIT1    = (UN/60);    // a cada 60 minutos
  TAXA_CI_FAILS1  = (UN/480);   // a cada 480 minutos
  TAXA_CI_PASSES1 = (UN/480/2); // a cada 840 minutos
  TAXA_RUN_TESTS1 = (UN/120);   // a cada 120 minutos (e por aí vai)

  TAXA_COMMIT2    = (UN/240);
  TAXA_CI_FAILS2  = (UN/480/3);
  TAXA_CI_PASSES2 = (UN/480/4);
  TAXA_RUN_TESTS2 = (UN/180);

  TAXA_COMMIT3    = (UN/120);
  TAXA_CI_FAILS3  = (UN/240/3);
  TAXA_CI_PASSES3 = (UN/360/4);
  TAXA_RUN_TESTS3 = (UN/30);

  TAXA_DEPLOY     = (UN/480/15);
  TAXA_SUCCESS    = (UN/480);
  TAXA_ROLLBACK   = (UN/480/3);
  TAXA_MERGE      = (UN/30);

events
  loc c1 (TAXA_COMMIT1);
  syn r1 (TAXA_RUN_TESTS1);
  syn f1 (TAXA_CI_FAILS1);
  syn p1 (TAXA_CI_PASSES1);

  loc c2 (TAXA_COMMIT2);
  syn r2 (TAXA_RUN_TESTS2);
  syn f2 (TAXA_CI_FAILS2);
  syn p2 (TAXA_CI_PASSES2);

  loc c3 (TAXA_COMMIT2);
  syn r3 (TAXA_RUN_TESTS3);
  syn f3 (TAXA_CI_FAILS2);
  syn p3 (TAXA_CI_PASSES2);

  loc dep (TAXA_DEPLOY);
  loc suc (TAXA_SUCCESS);
  loc rol (TAXA_ROLLBACK);
  syn mer (TAXA_MERGE);

partial reachability = (
    (st D1   == DEV)        &&
    (st D2   == DEV)        &&
    (st D3   == DEV)        &&
    (st MAIN == PRODUCTION) &&
    (st CI  == IDLE)
);

network DEVS (continuous)
  aut D1
    stt DEV        to (RUNNING) r1
    stt RUNNING    to (FAILED)  f1
                   to (READY)   p1
    stt FAILED     to (DEV)     c1
    stt READY      to (MERGED)  mer
    stt MERGED     to (DEV)     c1

  aut D2
    stt DEV        to (RUNNING) r2
    stt RUNNING    to (FAILED)  f2
                   to (READY)   p2
    stt FAILED     to (DEV)     c2
    stt READY      to (MERGED)  mer
    stt MERGED     to (DEV)     c2

  aut D3
    stt DEV        to (RUNNING) r3
    stt RUNNING    to (FAILED)  f3
                   to (READY)   p3
    stt FAILED     to (DEV)     c3
    stt READY      to (MERGED)  mer
    stt MERGED     to (DEV)     c3

  aut CI
    stt IDLE       to (RUNNING) r1 r2 r3
    stt RUNNING    to (IDLE)    p1 f1 p2 f2 p3 f3

  aut MAIN
    stt PRODUCTION to (TESTING)    mer
    stt TESTING    to (PRODUCTION) rol
                   to (STAGING)    suc
    stt STAGING    to (PRODUCTION) dep

results
  D1_DEV      = (st D1 == DEV);
  D1_CI       = (st D1 == RUNNING);
  D1_READY    = (st D1 == READY);
  D1_FAILED   = (st D1 == FAILED);
  D1_MERGED   = (st D1 == MERGED);
  D2_DEV      = (st D2 == DEV);
  D2_CI       = (st D2 == RUNNING);
  D2_READY    = (st D2 == READY);
  D2_FAILED   = (st D2 == FAILED);
  D2_MERGED   = (st D2 == MERGED);
  D3_DEV      = (st D3 == DEV);
  D3_CI       = (st D3 == RUNNING);
  D3_READY    = (st D3 == READY);
  D3_FAILED   = (st D3 == FAILED);
  D3_MERGED   = (st D3 == MERGED);

  MAIN_PRODUCTION = (st MAIN == PRODUCTION);
  MAIN_TESTING    = (st MAIN == TESTING);
  MAIN_STAGING    = (st MAIN == STAGING);

  CI_RUNNING = (st CI != IDLE);
```

## Resultados da Simulação

```
Starting model compilation...
First Passage
 Compiling block 'identifiers'...
 Compiling block 'events'...
 Compiling the reachability function...
 Compiling block 'network'...
 Compiling block 'results'...
Creating structures for automata and states...
Second Passage
 Compiling block 'identifiers'...
 Compiling block 'events'...
 Compiling the reachability function...
 Writing information about events...
 Compiling block 'network'...
 Compiling block 'results'...
 Checking integrity of events...
Model compiled!

Translation performed:  SAN model compilation
 - user time spent:     0.0000000000000000e+00 seconds
 - system time spent:   3.4260000000000002e-03 seconds
 - real time spent:     3.4329891204833984e-03 seconds

Creating temporary directories...
Creating description files...
 :-) file 'des/model.des' saved
 :-) file 'des/model.dic' saved
 :-) file 'des/model.fct' saved
 :-) file 'des/model.tft' saved
 :-) file 'des/model.res' saved

Loading SAN model (Internal Descriptor Generation)
Compile Network
Compile Function Table
 :-) file 'des/model.tft' read
 :-) file 'dsc/model.ftb' saved
Compile Descriptor
 :-) file 'des/model.des' read
 :-) file 'dsc/model.dsc' saved
Compile Dictionary
 :-) file 'dsc/model.dct' saved
 :-) file 'des/model.dic' read
Compile Integration Functions
 :-) file 'des/model.res' read
 :-) file 'dsc/model.inf' saved

Translation performed:  loading SAN model
 - user time spent:     6.5919999999999998e-03 seconds
 - system time spent:   0.0000000000000000e+00 seconds
 - real time spent:     4.6951770782470703e-03 seconds

Reading automata's domains...

Computing an initial state...

Initial state: (0, 0, 0, 0, 0)

Translation performed:  initial state computation
 - user time spent:     0.0000000000000000e+00 seconds
 - system time spent:   0.0000000000000000e+00 seconds
 - real time spent:     2.7179718017578125e-05 seconds

 :-) file 'des/model.fct' read

Generating the Reachability Descriptor...

Translation performed:  reachability descriptor generation
 - user time spent:     0.0000000000000000e+00 seconds
 - system time spent:   0.0000000000000000e+00 seconds
 - real time spent:     1.9788742065429688e-04 seconds

Computing the reachable state space...

Translation performed:  reachable state space generation
 - user time spent:     0.0000000000000000e+00 seconds
 - system time spent:   0.0000000000000000e+00 seconds
 - real time spent:     7.8797340393066406e-04 seconds

Memory used:
MDD structure = 23788 bytes
Reachability Descriptor = 6414 bytes

State spaces:
PSS = 750
RSS = 336

Generating the underlying Markov chain...

Integration of function D1_DEV = 2.5669983578322819e-01
Integration of function D1_CI = 1.1135810503029921e-01
Integration of function D1_READY = 6.1106241462900723e-01
Integration of function D1_FAILED = 1.3919763134728981e-02
Integration of function D1_MERGED = 6.9598814226769813e-03
Integration of function D2_DEV = 2.3939030580321383e-01
Integration of function D2_CI = 2.2271621355389903e-01
Integration of function D2_READY = 4.7293458591541621e-01
Integration of function D2_FAILED = 3.7119369021767476e-02
Integration of function D2_MERGED = 2.7839525705643998e-02
Integration of function D3_DEV = 9.6464836384554789e-02
Integration of function D3_CI = 2.2271621030544031e-01
Integration of function D3_READY = 6.1586005915209174e-01
Integration of function D3_FAILED = 3.7119368452209818e-02
Integration of function D3_MERGED = 2.7839525705643995e-02
Integration of function MAIN_PRODUCTION = 3.3185141105286292e-01
Integration of function MAIN_TESTING = 4.1759288574398652e-02
Integration of function MAIN_STAGING = 6.2638930037267870e-01
Integration of function CI_RUNNING = 5.5679052888963831e-01

Translation performed:  results of the integration functions
 - user time spent:     8.6000000000000312e-04 seconds
 - system time spent:   6.1399999999999996e-04 seconds
 - real time spent:     1.4719963073730469e-03 seconds

Deleting temporary directories

Translation performed:  total elapsed time
 - user time spent:     3.1999000000000000e-02 seconds
 - system time spent:   2.0652000000000000e-02 seconds
 - real time spent:     6.7047834396362305e-02 seconds
```

## Análise dos Resultados

Através das simulações, podemos perceber que os desenvolvedores ficam boa parte
do tempo esperando que os outros desenvolvedores estejam no estado de "pronto"
para realização de merge. Podemos ver que o desenvolvedor 1 ficou 61% do tempo
aguardando os outros desenvolvedores entrarem no estado "READY", da mesma forma,
os desenvolvedores 2 e 3 ficaram, respectivamente, 47% e 65% do tempo esperando
os outros desenvolvedores.

Este é um cenário simples, com apenas 3 desenvolvedores, porém, quanto mais
desenvolvedores tivermos no processo, mais tem os outros desenvolvedores
passariam esperando os outros, além disso, cada um dos desenvolvedores possui
seu próprio tempo de commit, o que pode dificultar com que a sincronia seja
feita.

### Proposta de Melhorias

Podemos ver que vamos ter problemas quando tivermos mais desenvolvedores,
dessa forma, uma forma possível de se garantir que tenhamos mais merges
(estado "MERGE"), é fazer com que os merges não dependam que todos os
desenvolvedores estejam prontos, bastando que só um dos desenvolvedores esteja.
Isso resolveria o problema de termos poucos merges, porém,
seria necessário adicionar mais alguns estados para poder ter mais controles
nos outros SAN's.

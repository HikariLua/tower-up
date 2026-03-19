# Finite State System (Sistema de Estados Finitos)

### Descrição geral
O sistema de estados finitos é composto pelas classes:

- State
- StateMachine
- FunctionStateTransition
- FunctionStateTransitionMap
- SignalStateTransition
- SignalStateTransitionMap

e depende da classe **DecisionResult**.

O intuito do sistema é o gerenciamento de estados finitos durante o jogo.
Um conjunto de estados finitos serão gerenciados por uma **StateMachine**, que vai
executar as lógicas de transição e execução do loop principal (_process e _physics_process)
das classes de State.


### Classes
#### State
State é uma classe virtual abstrata, serve apenas como classes pai para ser herdada por classes
de State especializadas. Ela possúi uma lista de transições (por sinais e funções) e
funções virtuais que devem ser sobreescritas pelos filhos
quando relevante. É através dela que a **StateMachine** consegue gerenciar a execução dos estados
de uma entidadede.

A classe State possúi equivalentes das funções base de execução automática do Godot, sendo elas:

- _state_input, equivalente a _input
- _state_shortcut_input, equivalente a _shortcut_inputinput
- _state_unhandled_input, equivalente a _unhandled_input
- _state_unhandled_key_input, equivalente a _unhandled_key_input
- _state_process, equivalente a _process
- _state_physics_process, equivalente a _physics_process

essas funções executadas pela **StateMachine**, tornando o tempo de execução delas finito e
sujeito ao gerenciamento da **StateMachine**.

Todo state DEVE ter uma **StateMachine** como ancestral.


#### StateMachine
A StateMachine é a classe responsável por gerenciar os states, ela executa as lógicas finitas,
checa as transições automáticamente e realiza as transições entre os states.

Ela possúi também transições globais, que indepedem do estado ativo e sempre tem prioridade em
cima das transições locais dos states.

Ela pode ser desativada se nescessário usando a função **toggle_disable**.

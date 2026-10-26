# Programação

O código da Chloe será revisado linha a linha pelo usuário, não haverá nada próximo de vibecoding, a atividade de escrever software em si é vista como uma arte que deve ser respeitada. O usuário gosta de conversar sobre o "design space", ou seja a arquitetura de software para resolver um problema,
não ignore essas discussões para pular direto para a solução.

- Prefira mudanças pequenas, localizadas e conceitualmente coesas.
- Nunca faça otimizações sem antes realizar benchmarks concretos
- Todo comportamento importante do programa deve ter um teste correspondente na teste suite
- Utilize ao máximo o sistema de tipos para estados incorretos serem irrepresentáveis.
- Comptime deve ser privilegiado sobre runtime
- Uma árvore de dependências pequenas é importante, mas também não reinvente a roda.
- O maior grau de sofisticação é a simplicidade.
- Funções devem ser maximalmente reutilizaveis, usando dependency injection para que o caller
  possa tomar decisões (siga um dependency injection parecido com o Zig, expondo RNGs, readers,
  writers, visitors,uso de lambda functions etc)

Como o código será revisado, é importante que haja bastante comentários para explicar as mudanças não triviais, o código deve ser escrito orientado a ser fácil de ser revisado. 

---
name: watchtower-review-overlay-correctness
description: Overlay metodológico de corretude da Watchtower Review. Use para investigar invariantes, comportamento, erros e regressões com testes unitários, de integração, por propriedades e análise de cobertura.
---

# Watchtower Review — Overlay de Corretude

Aplique esta metodologia quando a **Watchtower Review** identificar riscos de corretude, mesmo em mudanças cujo objetivo declarado seja outro. Este overlay **não é uma revisão independente**: a skill principal define o escopo, controla as correções e produz o único `review-report.md`.

## Metodologia

1. **Entenda o contrato.** Leia o diff, o código relacionado, os testes existentes e a Informal Spec, quando houver. Identifique comportamentos esperados, invariantes, pré-condições, pós-condições e casos extremos. Distinga requisitos confirmados de suposições.
2. **Prefira testes triviais de verificar.** Monte exemplos pequenos, com entradas e saídas explícitas, cujo resultado esperado seja evidente ao leitor. Dê nomes descritivos aos casos e use muitos asserts sobre propriedades relevantes. Evite reproduzir o próprio algoritmo testado para calcular a resposta esperada.
3. **Priorize legibilidade e manutenção.** Extraia fixtures, construtores de exemplo, mocks e funções auxiliares quando tornarem os testes mais claros. Use mocks apenas para isolar dependências; não esconda o comportamento que se pretende verificar atrás de abstrações excessivas.
4. **Teste contratos e falhas.** Verifique propriedades das entradas (pré-condições), dos resultados e do estado final (pós-condições). Em casos que devem falhar, confira **o tipo concreto da exceção e sua mensagem esperada**, não apenas que houve algum erro. Em Julia, por exemplo, não se limite a `@test_throws` com o tipo: verifique também o texto da exceção. Se a mensagem for instável ou não fizer parte do contrato, registre essa limitação em vez de inventar estabilidade.
5. **Combine estratégias.** Cubra unidades isoladas e integrações entre componentes. Quando pertinente, acrescente testes baseados em propriedades, invariantes, casos-limite e comparações com uma implementação de referência independente. Use sementes reproduzíveis em testes aleatórios e preserve exemplos mínimos de falha.
6. **Investigue a cobertura.** Meça cobertura de linhas e, quando disponível e útil, de ramos. Inspecione o código não exercitado, especialmente trechos alterados, caminhos de erro e condições de contorno. Busque cobertura ampla e significativa, **não uma porcentagem alta à custa de asserts vazios**.
7. **Confirme as regressões.** Execute os testes pertinentes no código sob revisão. Quando houver correção localizada, procure demonstrar a falha antes e a correção depois, e repita os testes afetados. Separe defeitos do código de problemas no teste ou no ambiente; não declare sucesso sem executar as verificações.
8. **Fundamente trechos complexos.** Para algoritmos, estruturas de dados e raciocínios não óbvios, consulte fontes confiáveis (artigos, livros, documentação ou implementações de referência) quando necessário. Registre no relatório as fontes realmente usadas e acrescente comentários curtos e referências próximas ao código complexo quando isso ajudar sua manutenção. **Não invente referências nem atribua à fonte conclusões que ela não sustenta.**
9. **Use implementações de referência (oráculos)** é recomendado que a suite de teste tenha bastante dependências para somente teste (as dev dependencies de Python ou test de Rust) ou seja, só são instaladas para teste mas não estão presentes no código final. Use bibliotecas conhecidas como oráculo e compare com as implementações feitas, caso encontre uma biblioteca que seja muito parecida com o código revisado escreva no relatório sobre isso e notifique que talvez seja melhor não reinventar a roda (ao menos que esse seja o objetivo)
## Ferramentas

Prefira o framework de testes e as ferramentas de cobertura **já adotados pelo projeto**. Exemplos, quando apropriados:

- **Rust:** `cargo test`, [proptest](https://github.com/proptest-rs/proptest) e [cargo-llvm-cov](https://github.com/taiki-e/cargo-llvm-cov).
- **Python:** [pytest](https://docs.pytest.org/), [Hypothesis](https://hypothesis.readthedocs.io/) e [pytest-cov](https://pypi.org/project/pytest-cov/)
- **Julia:** [`Test`](https://docs.julialang.org/en/v1/stdlib/Test/) e ferramentas de cobertura compatíveis com o projeto.
- **C++:** [GoogleTest](https://google.github.io/googletest/) e `llvm-cov`/`gcov`, conforme o toolchain.

## Evidências e integração

- Testes destinados a permanecer no projeto devem seguir suas convenções e integrar as alterações locais da Review; scripts exploratórios, entradas temporárias, logs e relatórios de cobertura ficam em **`.watchtower/artifacts/` da worktree de revisão**.
- Entregue à skill principal os cenários verificados, comandos executados, resultados, falhas reproduzíveis, cobertura e lacunas, referências consultadas e limites da investigação. Ela consolida tudo no **único `.watchtower/review-report.md`**; não produza outro relatório.
- Respeite o isolamento e as regras de patches da Watchtower Review. Não modifique a worktree principal, não faça staging, commits ou push e não execute tarefas do checklist da Chloe.

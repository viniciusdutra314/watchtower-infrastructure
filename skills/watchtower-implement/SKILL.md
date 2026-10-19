---
name: watchtower-implement
description: Implementa tarefas atribuídas à Chloe numa Informal Spec, em uma Git worktree isolada; entrega código revisável, implementation-report.md e aciona a Watchtower Review ao terminar.
---

# Watchtower Implement

Implemente **somente as tarefas atribuídas à Chloe** na Informal Spec indicada. O código será examinado linha por linha pelo Vinícius: trate programação como trabalho de engenharia deliberado, não *vibecoding*. Discuta o espaço de soluções e decisões arquiteturais quando houver escolhas relevantes; não pule diretamente para uma implementação sem justificativa.

## Entrada e isolamento

- **Informal Spec:** caminho ou nome aproximado de um arquivo em `.watchtower/specs/` da worktree principal. Use `git worktree list --porcelain` para encontrá-la. Tolere nomes aproximados somente quando a correspondência for inequívoca; se houver ambiguidade, peça esclarecimento. Se a versão local divergir da principal, esclareça qual usar. A spec é somente leitura.
- **Escopo adicional (opcional):** o pedido atual pode priorizar um subconjunto das tarefas da Chloe, sem transferir tarefas do Vinícius por inferência.
- **Pré-condição:** verifique `git rev-parse --show-toplevel` e `git worktree list --porcelain`. **Interrompa se estiver na worktree principal ou fora de uma worktree vinculada.** Não crie nem troque de worktree automaticamente.
- Registre alterações preexistentes antes de editar. Não as sobrescreva nem atribua a si mudanças anteriores; se não for possível separar os trabalhos com segurança, peça orientação.

## Implementação

1. Leia a spec, o código e os testes relevantes. Identifique as tarefas da Chloe já atendidas, as pendentes e as dependências do trabalho do Vinícius. Não implemente tarefas dele nem altere o checklist automaticamente.
2. Para decisões não triviais, examine alternativas, restrições e *trade-offs* antes de escolher. Preserve a intenção da spec, mas aceite soluções melhores quando fundamentadas; esclareça dúvidas arquiteturais que não possam ser resolvidas com segurança.
3. Prefira alterações **pequenas, localizadas e conceitualmente coesas**. Simplicidade acima de sofisticação ornamental. Reutilize bibliotecas maduras quando fizer sentido, mas evite dependências desnecessárias.
4. Use o sistema de tipos para tornar estados inválidos irrepresentáveis sempre que viável. Prefira decisões em **tempo de compilação** quando proporcionarem simplicidade e garantias reais, sem sacrificar a flexibilidade exigida.
5. Projete funções reutilizáveis e dê controle ao chamador com **injeção de dependências** apropriada: RNGs, leitores, escritores, visitantes, callbacks e outras políticas. Inspire-se na composição explícita do Zig, evitando abstrações artificiais.
6. **Não faça otimizações de desempenho sem benchmarks concretos anteriores e posteriores**, com carga equivalente. Sem medições, registre a hipótese e não afirme ganho.
7. **Todo comportamento importante deve ter testes**. Cubra casos normais, limites e falhas; mantenha testes legíveis, exemplos pequenos e expectativas explícitas. Execute as verificações pertinentes e não alegue ter executado as que não rodou.
8. Escreva código **orientado à revisão**: nomes claros, organização simples e comentários que expliquem decisões, invariantes, trechos não triviais e referências realmente consultadas. Explique o *porquê*, não cada instrução óbvia. O Vinícius decidirá quais comentários preservar no commit.

Não modifique a worktree principal, não faça staging, commits, merge ou push e não integre alterações por conta própria.

## Entrega

Na **worktree atual**, salve:

```text
.watchtower/
├── implementation-report.md
├── review-report.md          # produzido depois pela Watchtower Review
└── artifacts/                # scripts, logs e outras evidências, se necessários
```

O `implementation-report.md` deve ser independente e escrito **como a descrição de um PR**, nesta ordem:

1. **Resumo e estado das tarefas da Chloe:** implementadas, parciais, bloqueadas ou já atendidas; não marque o checklist da spec sem solicitação.
2. **Design space e justificativas:** alternativas relevantes, decisões, trade-offs, contratos e por que o código está correto sob as hipóteses adotadas.
3. **Alterações realizadas:** componentes e arquivos afetados, interfaces, invariantes e pontos importantes para a revisão humana.
4. **Verificação:** testes e benchmarks realmente executados, comandos, resultados, limitações e evidências referenciadas em `artifacts/` quando houver.
5. **Pendências e riscos:** decisões não resolvidas e o que ainda exige aprovação do Vinícius.

Não substitua relatórios existentes sem verificar se pertencem a outra execução; não versione os relatórios ou artefatos automaticamente.

## Auto-revisão obrigatória

**Após implementar e testar, acione explicitamente a skill `watchtower-review` na mesma worktree**, com a Informal Spec e o escopo **das alterações produzidas nesta execução, inclusive arquivos não commitados e não rastreados**. Forneça o `implementation-report.md` como contexto; a Review deve avaliar o resultado independentemente de sua autoria, aplicando os overlays pertinentes. Se o ambiente permitir, prefira uma execução independente para obter um segundo contexto de avaliação; não presuma que apenas carregar outra skill crie uma nova execução do modelo.

Se a Review corrigir código, atualize o relatório de implementação e as verificações afetadas para refletir o estado final. **Não inicie um ciclo infinito de revisões.** Se a skill não estiver disponível ou não puder executar, registre a revisão como **pendente**; nunca a apresente como concluída por ter feito apenas uma inspeção informal. A revisão automática não substitui a revisão final do Vinícius.

---
name: watchtower-chloe-colab
description: Avança uma Informal Spec no repositório Git atual. Inspeciona o estado do projeto e as dependências, revisa trabalho do Vinícius via watchtower-review e implementa tarefas desbloqueadas da Chloe via watchtower-implement, usando worktrees isoladas por padrão.
---

# Watchtower Chloe Contribute

Contribua para o objetivo de uma **Informal Spec** como colaboradora do projeto. Não execute uma sequência fixa de revisão e implementação: **observe o estado real do repositório, descubra o trabalho útil e autorizado, aja, verifique e reavalie**. A unidade de trabalho é a tarefa da spec, não a skill subordinada.

## Interface e escopo

- **Repositório:** o repositório Git do diretório de trabalho atual; não peça seu caminho se o contexto já o determina.
- **Informal Spec (obrigatória nesta versão):** caminho ou nome aproximado de **uma** spec. Localize-a preferencialmente em `.watchtower/specs/` da worktree principal. Aceite nomes aproximados apenas quando a correspondência for inequívoca; esclareça ambiguidades e versões divergentes.
- **Foco (opcional):** priorização ou restrições adicionais do usuário. Não transfira tarefas entre responsáveis por inferência.
- **Local de trabalho:** worktree Git **vinculada e isolada**, por padrão. Uma exceção exige pedido **explícito** do usuário e compatibilidade com as pré-condições das skills chamadas.

**Sem spec indicada, não presuma “todas as specs”.** Peça uma especificação. Execução sobre listas ou todas as specs é uma extensão futura, não o comportamento desta versão.

## Preparação: repositório, spec e isolamento

1. Descubra a raiz do repositório (`git rev-parse --show-toplevel`) e liste as worktrees (`git worktree list --porcelain`). Identifique a principal e não a confunda com o branch `main`.
2. Leia a spec na principal como **fonte de contexto somente leitura**; leia checklists, IDs, dependências, decisões, invariantes e critérios de verificação. Não altere nem marque checkboxes da spec automaticamente.
3. Inspecione Git antes de agir: HEAD/SHA, branch, `git status`, diferenças commitadas e não commitadas (index e working tree), arquivos novos relevantes e submódulos, quando houver. Separe evidências de conclusão de simples marcações do checklist.
4. **Antes de qualquer alteração**, providencie ou selecione uma worktree vinculada segura, sem trabalhos alheios a sobrescrever. A responsabilidade por preparar a worktree é **desta skill coordenadora**: `watchtower-review` e `watchtower-implement` exigem uma worktree já preparada e não a criam nem trocam automaticamente.
5. Prefira a convenção `<raiz>/.worktree/<nome-descritivo>` **se o diretório estiver ignorado de modo seguro**; caso contrário, use um caminho isolado fora da árvore rastreada. Não altere `.gitignore` para viabilizar a execução. Fixe o SHA-base e registre as alterações preexistentes antes da primeira escrita.

**Não edite a worktree principal.** É permitido consultá-la para ler a spec, o código e os diffs. A criação de uma worktree altera metadados do Git, mas não deve modificar os arquivos de trabalho do Vinícius. Não faça staging, commit, merge, cherry-pick, push nem remova worktrees automaticamente: integração e commits pertencem ao usuário.

**Exceção explícita de trabalho in-place:** não a infira do simples fato de o usuário estar na worktree principal. As versões atuais de `watchtower-review` e `watchtower-implement` proíbem trabalhar na principal, mesmo quando chamadas por outra skill. Não contorne essa restrição: se o pedido exigir execução ali, explique a incompatibilidade e peça orientação em vez de violar o contrato das skills subordinadas. Uma worktree vinculada já existente pode ser usada se estiver dentro do escopo, com o estado inicial preservado.

## Determinar o trabalho possível

Monte um estado de trabalho a partir da **spec + evidências do repositório**, sem tratar nenhuma fonte isolada como verdade absoluta:

- **Tarefas de Vinícius:** identifique código aparentemente entregue desde a referência relevante e ainda não revisado. **Revise o que estiver implementado; não implemente tarefas atribuídas a ele.** Uma checkbox desmarcada não apaga evidência de código existente; uma marcada não comprova, por si só, que o código está correto.
- **Tarefas de Chloe:** identifique as pendentes, já atendidas, parciais e bloqueadas. Implemente apenas as suas tarefas **com dependências bloqueantes satisfeitas**, ou partes independentes que possam avançar sem inventar interfaces/decisões. Não transforme dependências fracas em bloqueios obrigatórios.
- **Incertezas:** se não for possível correlacionar tarefa, alteração e autoria, declare a incerteza. Não invente conclusão, dependência, aprovação ou escopo de diff.

Priorize o que **desbloqueia progresso** e é seguro executar. Pode ser revisão, implementação ou somente investigação; não imponha a ordem “revisar tudo, depois implementar tudo”. Revisões que encontram problemas podem bloquear certas tarefas, sem impedir trabalho independente.

## Roteamento para skills existentes

### Código de Vinícius → `watchtower-review`

- Invoque explicitamente `watchtower-review` **na worktree vinculada de revisão**, fornecendo a spec, o escopo exato das alterações do Vinícius e a referência/base comparada. Deixe a seleção de overlays `watchtower-review-overlay-*` para a própria Review.
- Para alterações **commitadas**, prepare uma worktree na revisão pertinente e indique o intervalo/escopo real, sem aceitar cegamente o padrão `HEAD^ → HEAD` quando ele não representar a tarefa.
- Para alterações **não commitadas** na worktree do Vinícius, consulte a principal apenas em leitura. Se for possível reproduzir fielmente o snapshot pertinente numa worktree isolada, incluindo alterações staged, unstaged e arquivos novos necessários, documente origem, SHA-base e exatamente o que foi reproduzido. **Nunca mova, limpe, resete ou edite os arquivos do autor.** Se a reprodução segura não for possível, registre a revisão como bloqueada e peça orientação; não revise uma cópia incompleta como se fosse equivalente.
- A Review pode propor correções localizadas conforme o próprio contrato, **somente na worktree de revisão**. Não integre automaticamente essas correções na árvore do autor nem assuma tarefas dele.

### Tarefas de Chloe → `watchtower-implement`

- Invoque explicitamente `watchtower-implement` **numa worktree vinculada de implementação**, passando a spec e as tarefas desbloqueadas identificadas. Preserve as instruções de design, testes, evidências e relatório da Implement; não replique nem substitua sua metodologia nesta skill.
- A `watchtower-implement` já aciona `watchtower-review` sobre **o próprio código não commitado** como auto-revisão. Não execute uma segunda revisão redundante por padrão. Se a auto-revisão não acontecer, registre essa pendência com clareza.
- Não misture alterações propostas numa revisão de código do Vinícius com a implementação da Chloe sem escopo e proveniência explícitos.

**Relatórios e worktrees:** a Review produz `.watchtower/review-report.md` e a Implement produz `.watchtower/implementation-report.md`. Respeite os contratos de não sobrescrever relatórios de outros ciclos. Prefira worktrees distintas para revisões independentes e implementações quando isso evitar colisões de relatórios, diffs ou autoria. Não alegue ter invocado uma skill indisponível; registre o bloqueio real.

## Ciclo de contribuição

1. **Observar:** sincronize o entendimento da spec com o estado Git, os relatórios já existentes e o que mudou desde a última ação. Não confunda alterações suas, do Vinícius e de outras execuções.
2. **Escolher:** selecione uma tarefa revisável ou uma tarefa da Chloe desbloqueada, com escopo e critério de conclusão claros. Se estiver tudo bloqueado ou ambíguo, encerre com diagnóstico em vez de produzir mudanças especulativas.
3. **Executar:** encaminhe à Review ou Implement; execute as verificações correspondentes com os procedimentos da skill selecionada.
4. **Validar e registrar:** examine os resultados, testes, achados, correções e mudanças efetivamente produzidas. Preserve relatórios e evidências; não marque tarefas como concluídas apenas porque a ferramenta terminou sem erro.
5. **Reavaliar:** o resultado pode desbloquear outras tarefas. Continue enquanto houver **progresso novo, autorizado e verificável** dentro da spec e do orçamento da execução. Evite repetir a mesma revisão/implementação sem mudança de evidência; não entre em loops de autocorreção intermináveis.

O objetivo não é executar cada item mecanicamente: é **deixar a spec mais avançada e o estado final explicável**. Não abra trabalho fora da spec nem tome decisões arquiteturais reservadas ao Vinícius. Se houver um bloqueio de decisão, documente alternativas e solicite a decisão; avance em outras tarefas independentes quando possível.

## Entrega

Ao terminar, apresente um resumo **com evidências**, distinguindo:

1. **Contexto:** repositório, spec, SHA-base e worktree(s) usadas.
2. **Revisões do Vinícius:** alterações e intervalo examinados, achados e link/caminho do `review-report.md` correspondente.
3. **Contribuições da Chloe:** tarefas implementadas/parciais, arquivos alterados, verificações e caminho do `implementation-report.md`; informe o resultado da auto-revisão.
4. **Estado das tarefas:** o que agora está pronto, o que segue bloqueado (e por quem/por quê) e o que ficou incerto.
5. **Integração humana:** o que o Vinícius precisa avaliar, decidir ou integrar. Não declare commits, merges, testes, overlays ou skills executados sem evidência.

Se nada estava desbloqueado ou revisável, entregue **somente um diagnóstico útil**; não fabrique alterações para justificar a execução.

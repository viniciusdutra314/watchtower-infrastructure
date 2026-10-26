---
name: watchtower-review
description: Revisa código de qualquer autoria numa Git worktree isolada, inclusive alterações não commitadas da Watchtower Implement. Seleciona overlays metodológicos e entrega review-report.md com evidências e correções localizadas.
---

# Watchtower Review

Revise alterações **independentemente de quem escreveu o código**, investigando problemas e propondo correções verificáveis. O autor decide quais mudanças integrar. **Não execute tarefas pendentes do checklist da Chloe**: implementá-las é responsabilidade da Watchtower Implement.

## Entradas

- **Informal Spec (opcional):** caminho ou nome aproximado da especificação que orienta a mudança.
- **Escopo de comparação:** se receber commits, compare alvo `A` (padrão `HEAD`) com base `B` (padrão `A^`). Sem indicação, mantenha `HEAD^ → HEAD` como padrão para revisão de commits. **Quando invocada pela Watchtower Implement, revise as alterações produzidas por ela ainda não commitadas**, incluindo arquivos novos; não exija commit intermediário.
- **Foco (opcional):** dúvidas ou riscos prioritários; não restringe a revisão a eles.

Considere apenas o código, o contexto e as evidências disponíveis. Para mudanças não commitadas, inspecione `git status`, diferenças no index e na worktree e arquivos novos; use o estado inicial registrado pela Implement para separar alterações preexistentes. Não inclua trabalho anterior no escopo sem autorização nem confunda artefatos ignorados com código alterado.

## Pré-condição: worktree isolada

**Antes de qualquer escrita**, identifique a raiz atual com `git rev-parse --show-toplevel` e as worktrees com `git worktree list --porcelain`. A primeira entrada é a worktree principal. **Só prossiga se estiver numa worktree vinculada, diferente da principal**; caso contrário, interrompa e informe o motivo. Não crie nem troque de worktree automaticamente.

Trabalhe apenas na worktree atual. A principal pode ser consultada para ler especificações, nunca modificada. Não faça staging, commits, merge, cherry-pick, push nem remova worktrees.

## Localização da especificação

Procure em `.watchtower/specs/` da worktree principal; especifique o caminho ou resolva o nome informado de forma flexível (grafia, capitalização ou ordem das palavras). Use uma correspondência apenas se for inequívoca; em caso de ambiguidade ou falta de acesso, peça esclarecimento. Uma spec versionada também pode estar na worktree atual: se as versões divergirem, não escolha silenciosamente.

A Informal Spec é **contexto técnico**, não uma receita: compare objetivos, restrições, invariantes e justificativas. Reconheça melhorias fundamentadas mesmo quando a arquitetura implementada diferir da planejada. A spec é opcional para revisões sem documento correspondente.

## Revisão e overlays

1. Examine o diff do escopo escolhido (commits **ou** alterações não commitadas), o código relacionado, os testes e as convenções do projeto. Identifique os riscos relevantes.
2. Selecione **zero ou vários** overlays `watchtower-review-overlay-*` pela natureza da mudança, não apenas pelo foco declarado. Exemplos: `performance` (benchmarks e custo) e `correctness` (invariantes e testes). Leia as instruções dos overlays disponíveis e aplique as metodologias pertinentes.
3. Sem overlay apropriado ou disponível, faça a revisão generalista e registre as limitações. Não alegue ter executado métodos que não aplicou.
4. Integre os achados numa **única revisão**. Overlays complementam a metodologia, mas não alteram o isolamento, os caminhos ou o formato da entrega. Refaça verificações afetadas por qualquer correção.

Sustente conclusões com evidências proporcionais ao risco. Diferencie fatos verificados, hipóteses e incertezas. Não invente resultados de testes ou benchmarks.

## Correções e arquivos de saída

Faça correções **localizadas, bem justificadas e verificáveis** diretamente na worktree de revisão. Devolva mudanças amplas, decisões arquiteturais ou soluções incertas ao autor com explicação técnica. Não sobrescreva trabalho preexistente.

A saída pertence ao ciclo de vida **desta worktree**:

```text
.watchtower/
├── review-report.md
└── artifacts/          # patches, scripts, logs, dados, gráficos...
```

- Escreva **um** `.watchtower/review-report.md` por revisão/worktree; não crie subpastas `reviews/` nem relatórios separados por overlay. Se já existir um relatório de outra revisão, peça orientação antes de substituí-lo.
- Guarde ferramentas auxiliares e evidências em `.watchtower/artifacts/`, com organização interna livre. Referencie o material relevante no relatório por caminhos relativos.
- Se modificar código, gere `artifacts/proposed.patch` com **somente suas correções em relação ao estado encontrado no início da Review** (incluindo arquivos novos, quando aplicável). Não confunda o patch da revisora com as alterações sob revisão. Preserve as modificações na worktree para inspeção.
- Não versione relatórios ou artefatos automaticamente, nem altere o `.gitignore` do projeto. Avise se a configuração de ignore puder expor esses arquivos ao Git.

## Relatório

Produza `review-report.md` legível por si só, nesta ordem:

1. **Conclusão:** aprovável, aprovável com correções propostas, requer alterações do autor ou inconclusivo.
2. **Escopo e metodologia:** commits ou alterações não commitadas, Informal Spec (se houver), overlays realmente aplicados, verificações e limitações.
3. **Achados e ações:** problemas por impacto, evidências, consequências e situação (corrigido, pendente ou incerto).
4. **Resultados:** testes, benchmarks e comparações relevantes, distinguindo a implementação original da versão corrigida; links para gráficos e registros.
5. **Correções e próximos passos:** mudanças propostas, validação, link para `artifacts/proposed.patch` quando houver, e tarefas restantes para o autor.

Antes de concluir, confirme que o relatório descreve o código deixado na worktree e que os arquivos e links citados existem. Informe o caminho do relatório, o patch (se houver) e as pendências. **A integração e a remoção da worktree pertencem ao autor.**

---
name: watchtower-informal-spec
description: Cria ou atualiza especificações informais a partir de conversas técnicas. Use quando o usuário pedir para registrar decisões e tarefas numa Informal Spec ou atualizar uma existente.
---

# Watchtower Informal Spec

Consolide o contexto de uma unidade de trabalho em uma **Informal Spec**: objetivos, motivações, decisões técnicas e tarefas. Ela é um documento vivo, não uma ata, transcrição ou histórico cronológico.

## Entrada e operação

- **Com uma Informal Spec existente:** atualize o documento recebido (arquivo anexado, conteúdo colado ou caminho acessível), usando a conversa e as instruções atuais.
- **Sem uma Informal Spec existente:** crie uma nova especificação a partir do contexto disponível.
- Execute somente quando solicitado. Considere apenas informações efetivamente disponíveis; não invente decisões, atribuições ou evidências.
- Se o documento existente não puder ser lido ou a identificação for ambígua, peça esclarecimento antes de substituí-lo.

## Conteúdo

1. Comece com **checklists Markdown** separados para **Vinícius** e **Chloe**; inclua **A definir** quando necessário. Use tarefas curtas e verificáveis, respeitando responsáveis e dependências combinados. Não marque tarefas como concluídas sem evidência ou confirmação.
2. Explique o **problema, objetivo e motivação**, incluindo restrições importantes.
3. Preserve **decisões vigentes e seu porquê**: alternativas, fundamentos, trade-offs e consequências relevantes. Diferencie decisões de hipóteses e questões abertas.
4. Registre uma **especificação informal** do comportamento esperado: invariantes, interfaces, entradas/saídas e relações entre componentes, apenas quando discutidos.
5. Inclua **verificação**: critérios de aceitação, testes, benchmarks e fontes realmente consultadas, quando houver.

Se estiver atualizando, integre novidades às seções existentes, elimine repetições e substitua decisões superadas sem apagar contexto ainda útil. Preserve tarefas pendentes e estados confirmados. Prefira o estado atual do trabalho a uma cronologia de conversas.

## Organização e entrega

- No repositório, mantenha múltiplos arquivos com nomes curtos e descritivos em **`.watchtower/specs/` da worktree principal** (por exemplo, `parser-refactoring.md`). Para localizar a worktree principal a partir de outra, use `git worktree list --porcelain` quando disponível.
- Se uma spec for indicada por nome aproximado, aceite variações inequívocas de grafia, capitalização ou ordem das palavras; se houver mais de uma candidata plausível, pergunte.
- Quando houver acesso de escrita, crie ou atualize o arquivo correspondente. **Sem acesso ao sistema de arquivos, como numa conversa comum do ChatGPT, entregue o Markdown completo na resposta** para que o usuário possa salvá-lo; não alegue ter editado arquivos.
- O usuário decide se quer versionar a spec. Ela pode permanecer ignorada pelo Git ou ser adicionada explicitamente (`git add -f` se necessário). Não faça staging, commits ou mudanças nas regras de ignore sem solicitação.

## Estrutura de referência

Adapte ou preserve a estrutura do documento existente conforme necessário.

```markdown
# <tema>

## Checklist — Vinícius
- [ ] ...

## Checklist — Chloe
- [ ] ...

## Objetivo e motivação
...

## Decisões e justificativas
...

## Comportamento esperado e verificação
...

## Questões abertas
...
```

A spec fornece contexto à **Watchtower Implement** e à **Watchtower Review**, mas esta skill **não implementa nem revisa código** e não aciona outras skills automaticamente.

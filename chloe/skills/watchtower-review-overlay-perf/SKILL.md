---
name: watchtower-review-overlay-perf
description: Overlay metodológico de performance da Watchtower Review. Use quando uma mudança puder afetar desempenho; compare versões com benchmarks reproduzíveis e forneça evidências para o relatório único.
---

# Watchtower Review — Overlay de Performance

Aplique esta metodologia quando a **Watchtower Review** identificar questões de desempenho, mesmo que a otimização não seja o objetivo declarado do commit. Este overlay **não executa uma revisão independente**: a skill principal controla o escopo, a worktree, as correções e o `review-report.md`.

## Investigação

1. Examine o escopo definido pela Review: diff entre commits **B → A** ou alterações **não commitadas**, inclusive as produzidas pela Watchtower Implement. Identifique a hipótese de otimização e as métricas que poderiam confirmá-la. Para alterações locais, compare o estado anterior documentado com o estado atual; não suponha que `HEAD` represente esse estado se já havia mudanças pendentes.
2. Compare builds isolados e equivalentes das duas versões, preferencialmente de produção, com as mesmas flags, dependências e condições. Preserve a worktree principal e o trabalho preexistente. **Não crie ou troque worktrees sem autorização**; use cópias isoladas do código/build quando possível.
3. Reutilize benchmarks do projeto quando adequados; caso contrário, crie benchmarks temporários com entradas representativas. Verifique a corretude dos resultados e se as versões realizam trabalho equivalente antes de comparar tempos.
4. Prepare builds e ferramentas antes de medir; não inclua instalação via Nix, compilação ou preparação no tempo medido, salvo quando forem o objeto da investigação. Faça warm-up quando necessário, repita medições e **alterne as versões** para reduzir efeitos de ordem. **Nunca meça simultaneamente**: a Watchtower compartilha recursos.
5. Compare valores absolutos, diferenças relativas e dispersão; considere ruído, variação do ambiente e tamanho da amostra. Gere gráficos comparativos quando úteis e conclua: **melhoria**, **regressão**, **resultado misto** ou **inconclusivo**.
6. Quando ajudar a explicar os resultados, inspecione LLVM IR, outra representação intermediária ou assembly (por exemplo, inlining e vetorização). Prefira IR para entender transformações independentes de detalhes da ISA, mas **não suponha** que o comportamento ou o desempenho seja igual em todos os targets. Código gerado não substitui medições.
7. Se uma correção localizada for proposta pela Review, meça também a versão corrigida quando pertinente, distinguindo-a claramente do alvo original. Repita verificações afetadas pela correção.

## Ferramentas

Prefira ferramentas e benchmarks já utilizados no projeto. Escolha apenas os que contribuírem para a hipótese investigada:

- **Executáveis:** [Hyperfine](https://github.com/sharkdp/hyperfine) — warm-up, repetições e exportação JSON.
- **Rust:** [Criterion.rs](https://github.com/criterion-rs/criterion.rs) — benchmarks de funções; [cargo-show-asm](https://github.com/pacak/cargo-show-asm) — assembly e LLVM IR.
- **Python:** [pyperf](https://pyperf.readthedocs.io/) — medições repetidas; [cProfile](https://docs.python.org/3/library/profile.html) — investigação de gargalos.
- **Julia:** [BenchmarkTools.jl](https://juliaci.github.io/BenchmarkTools.jl/stable/) — interpolação de variáveis e cuidado com compilação JIT.
- **C++:** [Google Benchmark](https://google.github.io/benchmark/user_guide.html) — microbenchmarks, evitando eliminação indevida do trabalho.

Prefira CLIs via **Nix**, usando a revisão de Nixpkgs fixada pelo projeto quando disponível; instale bibliotecas de benchmark pelo ambiente da linguagem.

## Evidências e integração

- Guarde scripts auxiliares, dados brutos, logs, gráficos e resultados em **`.watchtower/artifacts/` da worktree de revisão**. Organize livremente, sem criar `watchtower-benchmarks/` ou outro relatório independente.
- Forneça à Review conclusões, metodologia, métricas, gráficos e limitações para incorporar ao **único `.watchtower/review-report.md`**, com referências relativas aos artefatos relevantes.
- Registre comandos, entradas, versões das ferramentas, flags, configuração do ambiente, quantidade de medições e limitações que afetem a interpretação. Não invente medições nem declare ganhos quando os resultados forem inconclusivos.
- Respeite as regras da Watchtower Review: nenhuma alteração na worktree principal, staging, commits ou push; correções localizadas e patches pertencem ao fluxo principal.

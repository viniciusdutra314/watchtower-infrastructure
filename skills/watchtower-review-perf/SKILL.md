---
name: watchtower-review-perf
description: Revisar commits de performance, comparando benchmarks antes e depois da mudança.
---

# Entrada e saída

Comparar o commit A (padrão: `HEAD`) com o baseline B (padrão: `HEAD^`). Usar os commits explicitamente informados quando disponíveis.

Produzir um relatório com os benchmarks, gráficos, resultados e conclusão sobre a otimização. Guarde esses dados na sua worktree em watchtower-benchmarks/

# Revisão de performance

- Ler o diff e identificar o que a otimização pretende melhorar.
- Usar worktrees isoladas e builds equivalentes de produção. Não modificar a árvore do autor, criar commits ou dar push.
- Reutilizar benchmarks existentes quando adequados ou criar benchmarks temporários com cargas representativas.
- Verificar se ambas as versões produzem resultados corretos e realizam trabalho equivalente.
- Repetir as medições, alternando entre versões e fazendo warm-up quando necessário. Nunca medir simultaneamente, pois a Watchtower compartilha recursos.
- Comparar tempos absolutos, diferenças relativas e dispersão. Não confundir ruído com melhoria.
- Gerar gráficos comparativos e concluir se houve **melhoria, regressão, resultado misto ou resultado inconclusivo**.
- Inspecionar assembly / linguagem-intermediária quando necessário para investigar a otimização, código gerado ajuda a explicar resultados, mas não substitui benchmarks.
- Preferir analisar LLVM-IR ou IRs em geral sobre um assembly real, certas otimizações na linguagem intermediária são garantidas a existir em qualquer target

# Ferramentas recomendadas

Preferir benchmarks e ferramentas já utilizados pelo projeto. Selecionar apenas as ferramentas relevantes para a otimização investigada.

## Executáveis (qualquer linguagem)

- [Hyperfine](https://github.com/sharkdp/hyperfine): comparar execuções completas com warm-up, repetições e exportação JSON.

## Rust

- [Criterion.rs](https://github.com/criterion-rs/criterion.rs): benchmarks de funções e algoritmos.
- [cargo-show-asm](https://github.com/pacak/cargo-show-asm): inspecionar assembly e LLVM IR, investigando inlining, vetorização e otimizações do compilador.

## Python

- [pyperf](https://pyperf.readthedocs.io/): benchmarks repetidos e comparações estatísticas.
- [cProfile](https://docs.python.org/3/library/profile.html): identificar gargalos antes de otimizar.

## Julia

- [BenchmarkTools.jl](https://juliaci.github.io/BenchmarkTools.jl/stable/): benchmarks com `@benchmark`, interpolação de variáveis e separação do tempo de compilação JIT.

## C++

- [Google Benchmark](https://google.github.io/benchmark/user_guide.html): microbenchmarks de funções e algoritmos, evitando eliminação indevida do trabalho medido.

# Ambiente

- Preferir ferramentas CLI via Nix, usando a revisão de Nixpkgs fixada pelo projeto quando disponível.
- Usar o ambiente de dependências da linguagem para bibliotecas de benchmark.
- Preparar builds e ferramentas antes das medições. Não incluir chamadas ao Nix no tempo medido.
- Registrar versões, flags de compilação, configurações e limitações do ambiente.

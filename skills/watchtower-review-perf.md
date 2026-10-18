---
name: watchtower-review-perf
description: Revisar commits perf comparando desempenho antes e depois, com benchmark e gráfico dos resultados.
---

# Revisão de performance

Verificar se a otimização alegada pelo commit realmente melhora o desempenho.

- Usar worktrees isoladas e builds equivalentes de produção. Não alterar a árvore do autor, criar commits ou dar push.
- Ler o diff e escolher um benchmark que exercite a mudança em cargas representativas. Reutilizar um existente quando adequado; caso contrário, criar um temporário e usar o mesmo protocolo e entradas nas duas versões.
- Verificar que ambas continuam produzindo resultados corretos e fazendo trabalho equivalente. Menos trabalho ou menor precisão não devem passar silenciosamente por otimização.
- Repetir e intercalar as medições, com warm-up quando necessário. Não medir as versões simultaneamente: a Watchtower compartilha recursos entre VMs e containers. Registrar limitações de carga e ruído.
- Mostrar valores absolutos, diferença relativa e dispersão. Não declarar melhora quando o efeito não se distinguir do ruído; destacar regressões e ganhos restritos a certos cenários.
- Gerar e mostrar um gráfico comparando as versões, acompanhado de uma conclusão curta: melhorou, regrediu, resultado misto ou inconclusivo. Limitar a conclusão aos cenários medidos.
- Salvar fora da árvore do autor o relatório, gráfico, dados brutos e o necessário para reproduzir o benchmark, incluindo hashes, comandos e ambiente. Se não for possível medir, explicar o bloqueio sem inventar resultados.

## Ferramentas recomendadas / preferidas

Reutilizar o harness do projeto quando adequado. Escolher conforme a hipótese, sem executar todas as ferramentas por obrigação.

| Contexto                                   | Ferramenta e uso                                                                                                                                                                                                                   |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Comandos e executáveis, qualquer linguagem | [Hyperfine](https://github.com/sharkdp/hyperfine): comparar execuções completas, com warm-up e exportação JSON. Evitar que startup e I/O escondam uma otimização interna.                                                          |
| Rust: funções                              | [Criterion.rs](https://github.com/criterion-rs/criterion.rs): microbenchmarks e comparação entre implementações/entradas.                                                                                                          |
| Rust: código gerado                        | [cargo-show-asm](https://github.com/pacak/cargo-show-asm), comando `cargo asm`: investigar inlining, eliminação de trabalho e vetorização no assembly/LLVM IR; usar disassembly quando a hipótese exigir conferir o binário final. |
| Python: funções                            | [pyperf](https://pyperf.readthedocs.io/): benchmarks repetidos e comparação de resultados com `compare_to`. Usar [cProfile](https://docs.python.org/3/library/profile.html) para localizar custos, não para certificar speedup.    |
| Julia: funções                             | [BenchmarkTools.jl](https://juliaci.github.io/BenchmarkTools.jl/stable/): usar `@benchmark`, interpolar entradas e separar compilação JIT da execução, salvo quando medir startup.                                                 |
| C++: funções                               | [Google Benchmark](https://google.github.io/benchmark/user_guide.html): microbenchmarks com entradas controladas e proteção contra eliminação do trabalho medido.                                                                  |

Inspecionar assembly apenas quando ajudar a testar a hipótese, usando perfil, features, target e flags correspondentes ao benchmark. Símbolo ausente não prova inlining; investigar os chamadores e a instanciação. Evidência de código gerado explica o mecanismo, mas não substitui a medição do ganho.

Obter ferramentas CLI por Nix, sem instalação global, por exemplo:

```sh
nix shell nixpkgs#hyperfine --command hyperfine ...
nix shell nixpkgs#cargo-show-asm --command cargo asm ...
```

Preferir o ambiente/revisão de Nixpkgs já fixado pelo projeto ou infraestrutura, registrar versões e conferir as opções disponíveis. Bibliotecas de benchmark devem usar o ambiente de dependências da linguagem, em área temporária se necessário. Preparar ferramentas e builds antes de medir; não incluir chamadas ao Nix no comando cronometrado.

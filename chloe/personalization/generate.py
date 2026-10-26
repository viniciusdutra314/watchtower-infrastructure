#!/usr/bin/env python
from dataclasses import dataclass
from pathlib import Path

MODULES_DIR = Path("modules")
MODULES_REGISTRY = {
    path.relative_to(MODULES_DIR).as_posix() for path in MODULES_DIR.rglob("*.md")
}
OUTPUT_DIR = "."
Path(OUTPUT_DIR).mkdir(exist_ok=True)


@dataclass
class Module:
    name: str
    content: str

    def __len__(self):
        return len(self.content)


def compile_target(
    name: Path | str, module_names: list[str], character_limit: None | int = None
) -> None:
    for module in module_names:
        assert module in MODULES_REGISTRY, (
            f"Módulo {module} não está em {MODULES_REGISTRY=}"
        )
    with open(Path(OUTPUT_DIR) / name, "w") as file:
        modules: list[Module] = [
            Module(
                name=module,
                content=(MODULES_DIR / f"{module}").read_text(encoding="utf-8"),
            )
            for module in module_names
        ]
        modules_sorted = sorted(
            modules, key=lambda module: len(module.content), reverse=True
        )
        print("======\n")
        print(f"Writing {name}...", end="\n" * 2)
        number_of_character = 0
        for module in modules_sorted:
            number_of_character += len(module.content)
            print(f"{module.name} | {len(module.content)}")
        if character_limit is not None:
            print(f"{number_of_character}/{character_limit}")
            assert number_of_character <= character_limit, (
                f"Limite de caracteres atingido ({number_of_character}/{character_limit})"
            )
        file.writelines(module.content for module in modules)


def main() -> None:
    compile_target(
        "CHATGPT-PERSONALIZATION.md",
        [
            "CORE.md",
            "CHAT-VISUALS.md",
            "VOICE.md",
            "DICTATION.md",
            "MULTI_INSTANCE.md",
            "ENVIRONMENTS/SHARED_SPACE.md",
        ],
        5000,
    )
    compile_target(
        "CODEX-PERSONALIZATION.md",
        [
            "CORE.md",
            "CODING.md",
            "DICTATION.md",
            "MULTI_INSTANCE.md",
            "ENVIRONMENTS/WATCHTOWER.md",
        ],
    )


if __name__ == "__main__":
    main()

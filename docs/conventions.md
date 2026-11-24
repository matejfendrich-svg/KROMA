# Konvence pro CLI agenta

1. **Nový efekt**: nový soubor v `Sources/KromaFX/Effects/`, kernel v `Sources/KromaEngine/Kernels/`, test v `Tests/`. Žádné změny jinde – registrace proběhne přes `KromaFX.registerDefaultEffects`.
2. **Nová stránka**: zkopírovat adresář v `Sources/KromaPages/`, přidat target do `Package.swift`, implementovat `PageModule`, zaregistrovat v `AppModel.init`.
3. **Schéma parametrů** (`ParameterSchema` v KromaRegistry) je jediný zdroj inspektoru UI i serializace grafu. Žádné duplicitní definice v UI.
4. **Závislosti vrstev jen jedním směrem**: UI závisí na Core a Registry, nikdy na Engine. Nikdo nezávisí na UI.
5. **Commity**: Conventional Commits (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `ci:`, `build:`), krátké větve `vibe/<slug>-<id>`.
6. **Architektonická rozhodnutí** zapisovat jako ADR do `docs/adr/NNNN-titulek.md` (viz šablona níže).
7. **Release** výhradně přes `scripts/release.sh`, žádné ruční kroky, žádný `.xcodeproj`/`.xcworkspace` v repozitáři.
8. **Nejednoznačnost**: rozhodnout ve prospěch jednoduššího řešení v rámci aktuálního milníku a zapsat ADR.
9. Žádné komentáře v kódu nad rámec dokumentačních `///` u veřejných API; žádné natvrdo zapsané barvy mimo `DesignTokens`.
10. Testy píšeme přes Swift Testing (`import Testing`, `@Test`, `#expect`). Každý kernel později dostane golden render test.

## Šablona ADR

```markdown
# NNNN – Titulek rozhodnutí

- Stav: přijato
- Datum: YYYY-MM-DD

## Kontext
...

## Rozhodnutí
...

## Důsledky
...
```

# 0002 – Jediný node engine pro stránky Obraz, Color i FX

- Stav: přijato
- Datum: 2026-02-14

## Kontext
Původní plán předpokládal tři samostatné render pipeline. To by vedlo k trojitému duplicitnímu kódu a těžké údržbě efektů.

## Rozhodnutí
Existuje jeden render DAG (`KromaEngine.RenderDAG`) nad jedním node grafem (`KromaCore.NodeGraph`). Stránky Obraz, Color a FX jsou jen pohledy/přednastavené sady uzlů na tentýž graf. Každý efekt implementuje `EffectDefinition` v KromaRegistry a má jeden Metal kernel.

## Důsledky
- Změna parametru na libovolné stránce mění tentýž graf – cache klíč (hash grafu) a undo fungují globálně.
- Režim Resolve sdílí stejný engine; adjustment clip je další vrstva v DAG.
- UI nikdy nezávisí na Engine přímo, jen přes Core a Registry.

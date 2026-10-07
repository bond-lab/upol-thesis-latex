# upol-thesis-latex

*[English version](README.md)*

Třída pro LaTeX určená pro bakalářské, diplomové a disertační práce na
Filozofické fakultě Univerzity Palackého v Olomouci (FF UP). Vysází titulní
stranu, prohlášení, český a anglický abstrakt a obsah. Pro stranu
s abstraktem také spočítá strany, znaky a přílohy. Zatím podporuje dvě
katedry: Katedru obecné lingvistiky (KOL) a Katedru asijských studií (KAS).

| Ukázka | Zdroj | PDF |
|---|---|---|
| Bakalářská práce v češtině: obrázky, tabulky, glosy, dvě přílohy | [`example-kol.tex`](example-kol.tex) | [`example-kol.pdf`](example-kol.pdf) |
| Disertační práce v angličtině | [`example-kol-phd.tex`](example-kol-phd.tex) | [`example-kol-phd.pdf`](example-kol-phd.pdf) |
| Její autoreferát | [`example-kol-phd-autoreferat.tex`](example-kol-phd-autoreferat.tex) | [`example-kol-phd-autoreferat.pdf`](example-kol-phd-autoreferat.pdf) |
| Bakalářská práce KAS v češtině s čínštinou a japonštinou | [`example-kas.tex`](example-kas.tex) | [`example-kas.pdf`](example-kas.pdf) |

## Soubory

| Soubor | Obsah |
|---|---|
| `upolthesis.cls` | třída: části společné celé fakultě a texty v češtině, slovenštině a angličtině |
| `upolthesis-kol.def` | nastavení KOL: názvy, označení typu práce, titulní strana, minimální rozsah |
| `upolthesis-kas.def` | nastavení KAS: sazba, pořadí stran, anotace, resumé |
| `UP_logo_FF_stred_cerna_*.pdf` | oficiální loga FF z <https://vizual.upol.cz/> |
| `acl_natbib.bst` | citační styl ACL pro `bib=acl` |
| `upol-count.sh` | spočítá znaky textu |
| `Makefile` | sestaví práci včetně počtu znaků |
| `docs/` | poznámky k pravidlům fakulty a kateder s odkazy na zdroje (anglicky) |

Třída je tenká vrstva nad standardní třídou `report`, nikoli balík
nahraný nad `article` nebo `book`. Práce má pevné pořadí stran, takže třída
musí řídit sazební obrazec, úvodní strany i číslování stran. Katedry se pak
liší jen malým souborem `.def`. Podle české praxe je titulní strana stranou 1
a čísla se tisknou až od obsahu. To `report` umožňuje, kdežto `book`
čísluje úvodní strany římsky.

## Začínáme

**Na vlastním počítači.** Potřebujete:

- TeX Live 2022 nebo novější s LuaLaTeXem, biberem a bibtexem;
- `pdftotext` (z balíku poppler) pro počet znaků;
- české a slovenské dělení slov (`texlive-lang-czechslovak` v Debianu
  a Ubuntu);
- pro čínštinu, japonštinu nebo korejštinu písma Noto Serif CJK
  (`fonts-noto-cjk` v Debianu a Ubuntu, nebo z
  <https://github.com/notofonts/noto-cjk>).

Zkopírujte soubory třídy k práci a spusťte:

```sh
make DOC=prace           # LuaLaTeX, literatura, počet znaků, LuaLaTeX
```

Samotné `make` sestaví všechny tři ukázky.

**Bez `make`.** Ve složce s prací (zde `prace.tex`) spusťte tyto příkazy:

```sh
lualatex prace
biber prace               # při bib=apa; při bib=acl `bibtex prace`
lualatex prace
./upol-count.sh prace     # počet znaků (nepovinné, viz níže)
lualatex prace
```

Nebo nechte `latexmk`, ať spustí LuaLaTeX a nástroj pro literaturu tolikrát,
kolikrát je třeba:

```sh
latexmk -lualatex prace
./upol-count.sh prace
latexmk -lualatex -g prace
```

V editoru:

- **TeXstudio:** *Options → Configure TeXstudio → Build* (v české verzi
  obdobně). Jako *Default Compiler* zvolte **LuaLaTeX** a jako *Default
  Bibliography Tool* **Biber** (bib=apa) nebo **BibTeX** (bib=acl).
- **VS Code s LaTeX Workshop:** zvolte recept *latexmk (lualatex)*.

Počet znaků potřebuje `bash` a `pdftotext`. Na Linuxu a macOS bývají
k dispozici; na Windows použijte Git Bash nebo WSL. Pokud skript spustit
nemůžete, vynechte ho a zadejte počet ručně příkazem `\charcount{85432}`.
Do té doby strana s abstraktem ukazuje **???**.

**Na Overleafu.** Nahrajte všechny soubory z kořenového adresáře
repozitáře. V *Menu → Compiler* pak zvolte **LuaLaTeX**. Overleaf sám spustí
biber nebo bibtex. Skript `upol-count.sh` ale spustit neumí, takže počet
znaků zadejte ručně příkazem `\charcount{85432}`.

Třída odmítne pdfLaTeX. XeLaTeX funguje také.

## Nejmenší možná práce

```latex
\documentclass[department=kol, type=ba, language=czech, gender=f, bib=apa]{upolthesis}
\thesisbibfile{literatura.bib}

\title{Název v jazyce práce}
\titleen{English title}
\author{Jana Nováková}
\supervisor{prof. Francis Bond, PhD}
\abstractcs{...}  \keywordscs{...}
\abstracten{...}  \keywordsen{...}

\begin{document}
\makefrontmatter[lof,lot]   % titulní strana až obsah, seznamy obrázků a tabulek
\chapter{Úvod}
...
\thesisbibliography
\appendix
\chapter{Data}
\end{document}
```

## Volby třídy

| Volba | Hodnoty (výchozí první) | Poznámka |
|---|---|---|
| `department` | `kol`, `kas` | další budou: `kaa`, `kb` |
| `type` | `ba`, `ma`, `phd` | |
| `autoreferat` | | autoreferát disertační práce (nastaví `type=phd`) |
| `language` | `czech`, `slovak`, `english` | jazyk práce |
| `gender` | `x`, `f`, `m` | tvary sloves v prohlášení; `x` vysází *vypracoval/a* |
| `bib` | `apa`, `acl`, `none` | `apa`: biblatex-apa s biberem; `acl`: natbib s `acl_natbib.bst` a bibtexem |
| `font` | podle katedry (KOL: `pagella`, KAS: `tnr`); `charis`, `termes`, `none` | `tnr` je Times New Roman, nebo TeX Gyre Termes, pokud Times New Roman chybí; `charis` (Charis SIL) pokrývá celou IPA |
| `logo` | podle katedry (KOL: `shield`, KAS: `none`); `faculty` | štít UP, nebo celé logo FF |
| `cjk` | podle katedry (KAS: `{zh,ja,ko}`) | čínština (`zh`, `zhtw`), japonština (`ja`), korejština (`ko`); jen LuaLaTeX |
| `spacing` | podle katedry (KOL: 1,3, KAS: 1,241) | řádkování |
| `twoside` | | pro tištěné výtisky |

Pro lingvistiku doporučujeme APA nebo ACL. Oba styly znají `\citet`,
`\citep`, `\citealt`, `\citeauthor` a `\citeyear`, takže mezi nimi lze
přepnout beze změny textu.

## Údaje o práci

Povinné: `\title` (v jazyce práce), `\titleen`, `\author`, `\supervisor`,
`\abstractcs` a `\keywordscs` (u slovenské práce `\abstractsk`
a `\keywordssk`), `\abstracten` a `\keywordsen`.

Nepovinné:

- `\titlecs`, `\titlesk`: název v dalším jazyce, např. český název
  anglické práce
- `\consultant`
- `\thesisyear`: výchozí je letošní rok
- `\submissiondate`: jinak zůstane datum v prohlášení prázdné
- `\acknowledgements`
- `\aiuse`: jak byly použity nástroje umělé inteligence; vysází se pod
  prohlášení. Studijní a zkušební řád UP (čl. 26 odst. 3) považuje
  nepřiznaný text vytvořený umělou inteligencí za plagiát.
- `\abbreviations`, `\editorialnote`: seznam zkratek a ediční poznámka
  (o transkripci, znacích apod.); vysázejí se za obsah
- `\charcount`, `\numappendices`, `\numbibitems`: ručně zadaný počet
  znaků, příloh a titulů literatury
- jen u disertačních prací:
  - `\programme`: výchozí je studijní program katedry
  - `\ipstatement`: prohlášení o duševním vlastnictví podle SZŘ UP čl. 44
    odst. 4 písm. h. Pokud chybí, třída varuje.
  - `\contribution`: vyjádření o podílu studenta na týmovém projektu
    (čl. 44 odst. 6); vysází se na samostatnou stranu

## Počty na straně s abstraktem

- **Strany:** celkový počet stran.
- **Přílohy:** počet kapitol za `\appendix`.
- **Tituly použité literatury** (KAS): počet položek v seznamu literatury.
- **Znaky:** včetně mezer, od první kapitoly po úvodních stranách až po
  seznam literatury nebo přílohy. `upol-count.sh` je bere z PDF, takže
  započítá i poznámky pod čarou, popisky a čísla stran.

Pokud je text kratší než minimum katedry, třída varuje. Kde něco chybí,
vysází **???**.

## Obrázky, tabulky a příklady

`example-kol.tex` ukazuje:

- tabulku s `booktabs` a `siunitx` (čísla zarovnaná podle desetinné čárky);
- graf vykreslený z dat balíkem `pgfplots`;
- schéma v TikZ;
- glosované příklady s `langsci-gb4e`, který není součástí každé instalace
  TeXu;
- dvě přílohy.

Popisky obrázků i tabulek jsou pod nimi. Obrázek ze souboru vložíte
příkazem `\includegraphics[width=.8\textwidth]{obrazek.pdf}`.

Nejvyšší hodnota ve sloupci (nebo řádku) je tučně: ve sloupci `S` napište
před číslo `\bfseries` a zarovnání zůstane zachováno. Písma třídy (TeX Gyre
Pagella, TeX Gyre Termes, Times New Roman) mají tučné číslice přesně stejně
široké jako obyčejné, takže tučná čísla lícují. Tučné číslice písma Charis
SIL jsou o něco širší.

## Čínština, japonština a korejština

S volbou `cjk={zh,ja,ko}` (výchozí pro KAS) můžete znaky psát přímo do
textu. Třída sama přepne na písmo Noto CJK a CJK text láme do řádků. Kana
a hangul jsou jednoznačné. Znaky han bez kany se sázejí jako první jazyk
v seznamu, u KAS tedy jako čínština. Samostatná japonská kandži zapište
jako `\textja{茶道}`; stejně fungují `\textzh`, `\textzhtw` a `\textko`.
Funguje jen s LuaLaTeXem.

## Z čeho nastavení KAS vychází

Podle dokumentu *Jak napsat závěrečnou práci na katedře asijských studií*
(2023):

- **Rozsah:** bakalářská práce 30–40 normostran, diplomová 60–80. Třída
  varuje pod minimem i nad maximem.
- **Sazba:** Times New Roman 12 bodů, okraje 25 mm, řádkování 1,5, zarovnání
  do bloku, odsazení odstavců 1 cm.
- **Pořadí:**
  1. titulní strana;
  2. prohlášení (bez podpisu);
  3. anotace: počet stran, znaků, titulů použité literatury a příloh,
     klíčová slova a text z `\abstractcs`;
  4. poděkování;
  5. obsah a seznamy;
  6. seznam zkratek a ediční poznámka;
  7. text práce;
  8. `\makeresume` za závěrem: anglické resumé o 100–200 slovech
     z `\abstracten`;
  9. literatura a přílohy.

  Titulní strana, prohlášení, anotace a poděkování se započítávají do
  číslování, ale číslo strany na nich není.
- **Anglická práce:** souběžný název a resumé jsou místo toho české,
  z `\titlecs` a `\abstractcs`.
- Citační normu KAS nepředepisuje. Doporučujeme APA nebo ACL.
- Pravidla pro disertační práce KAS nezveřejňuje; `type=phd` použije
  výchozí nastavení fakulty s titulní stranou KAS.

## Z čeho nastavení KOL vychází

Poznámky se zdroji jsou v adresáři [`docs/`](docs/).

- **Fakulta** (FF-B-23/08):
  - minimální rozsah: bakalářská práce 30 normostran, diplomová 60;
  - povinné části: titulní strana, prohlášení, anotace;
  - odevzdání: elektronicky přes STAG.
  - Typografická pravidla nestanoví a PDF/A nevyžaduje.
- **Bakalářské a diplomové práce na KOL**, podle
  [stránky katedry](https://kol.upol.cz/studium/diplomove-prace/) a její
  šablony pro Word:
  - jazyk: čeština, slovenština nebo angličtina;
  - minimální rozsah: bakalářská práce 72 000 znaků, diplomová 108 000;
  - český a anglický abstrakt, každý alespoň 900 znaků (třída to
    nekontroluje);
  - jakákoli standardní citační norma.
  - Okraje, písmo ani řádkování KOL nepředepisuje. Výchozí jsou okraje
    25 mm (vnitřní 30 mm), písmo TeX Gyre Pagella 12 bodů a řádkování 1,3.
- **Disertační práce na KOL** (program *Obecná jazykověda a teorie
  komunikace*). Fakulta ani oborová rada formální pravidla nezveřejňují,
  takže třída vychází z SZŘ UP čl. 44 a z nedávných disertací KOL.
  - **Titulní strana:** přidává anglický souběžný název a studijní program.
  - **Prohlášení:** má znění nedávných disertací KOL; za ním následuje
    prohlášení o duševním vlastnictví.
  - **Jazyk:** program je akreditován jen v češtině, takže anglická
    disertace potřebuje předchozí souhlas oborové rady (čl. 44 odst. 3).
  - **Autoreferát:** použijte volbu `autoreferat`. Třída přidá
    jednostránkový anglický abstrakt, a pokud disertace není česky ani
    slovensky, také český souhrn.
  - **Tisk:** FF chce jeden tištěný výtisk; použijte `twoside`.
  - S oborovou radou je ještě třeba ověřit znění prohlášení o duševním
    vlastnictví (ukázka obsahuje návrh), rozsah cizojazyčného resumé,
    orientační rozsah práce a to, zda lze předložit soubor publikací.

## Přidání katedry

Zkopírujte `upolthesis-kol.def` jako `upolthesis-<katedra>.def` a upravte
názvy, označení typu práce, titulní stranu, okraje a minimální rozsah. Pak
ho použijte volbou `department=<katedra>`.

Plánujeme: KAA a KB.

Slovenské texty by měl ještě zkontrolovat rodilý mluvčí.

## Licence

Třída, nastavení katedry a skripty jsou © 2026 Francis Bond, pod licencí
[LaTeX Project Public License 1.3c](https://www.latex-project.org/lppl/).

- `acl_natbib.bst` pochází ze stylů ACL a je také pod LPPL.
- Loga jsou majetkem Univerzity Palackého v Olomouci a jsou použita podle
  jejích [pravidel vizuální identity](https://vizual.upol.cz/).

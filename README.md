# upol-thesis-latex

*[Česká verze](README.cs.md)*

A LaTeX class for bachelor's, master's and doctoral theses at the Faculty of
Arts, Palacký University Olomouc (FF UP). It produces the title page,
declaration, Czech and English abstract pages and table of contents. It also
counts the pages, characters and appendices for the abstract page. Two
departments are supported so far: General Linguistics (KOL) and Asian
Studies (KAS).

| Example | Source | PDF |
|---|---|---|
| Bachelor's thesis in Czech: figures, tables, glosses, two appendices | [`example-kol.tex`](example-kol.tex) | [`example-kol.pdf`](example-kol.pdf) |
| Dissertation in English | [`example-kol-phd.tex`](example-kol-phd.tex) | [`example-kol-phd.pdf`](example-kol-phd.pdf) |
| Its autoreferát | [`example-kol-phd-autoreferat.tex`](example-kol-phd-autoreferat.tex) | [`example-kol-phd-autoreferat.pdf`](example-kol-phd-autoreferat.pdf) |
| KAS bachelor's thesis in Czech, with Chinese and Japanese | [`example-kas.tex`](example-kas.tex) | [`example-kas.pdf`](example-kas.pdf) |

## Files

| File | Contents |
|---|---|
| `upolthesis.cls` | the class: faculty-wide parts and the Czech, Slovak and English wording |
| `upolthesis-kol.def` | the KOL preset: names, thesis-type wording, title page, minimum length |
| `upolthesis-kas.def` | the KAS preset: layout, page order, annotation page, résumé |
| `UP_logo_FF_stred_cerna_*.pdf` | official FF logos, from <https://vizual.upol.cz/> |
| `acl_natbib.bst` | ACL bibliography style, for `bib=acl` |
| `upol-count.sh` | counts the characters of the text |
| `Makefile` | builds a thesis, including the character count |
| `docs/` | the research notes on the faculty and department rules, with sources |

The class is a thin layer over the standard `report` class, rather than a
package loaded on top of `article` or `book`. A thesis has a fixed page order,
so the class must control the page layout, the front matter and the page
numbering. Departments then differ only in a small `.def` file. Czech
practice counts the title page as page 1 and prints numbers only from the
table of contents on, which `report` allows and `book`'s roman-numbered front
matter does not.

## Getting started

**On your own computer.** You need:

- TeX Live 2022 or later, with LuaLaTeX, biber and bibtex;
- `pdftotext` (from poppler) for the character count;
- the Czech and Slovak hyphenation patterns (`texlive-lang-czechslovak` on
  Debian and Ubuntu);
- for Chinese, Japanese or Korean: the Noto Serif CJK fonts
  (`fonts-noto-cjk` on Debian and Ubuntu, or from
  <https://github.com/notofonts/noto-cjk>).

Copy the class files next to your thesis and run:

```sh
make DOC=thesis          # LuaLaTeX, bibliography, character count, LuaLaTeX
```

`make` on its own builds the three examples.

**Without `make`.** Run these commands in the folder with your thesis
(here `thesis.tex`):

```sh
lualatex thesis
biber thesis              # with bib=apa; use `bibtex thesis` with bib=acl
lualatex thesis
./upol-count.sh thesis    # character count (optional, see below)
lualatex thesis
```

Or let `latexmk` run LuaLaTeX and the bibliography tool as often as needed:

```sh
latexmk -lualatex thesis
./upol-count.sh thesis
latexmk -lualatex -g thesis
```

In an editor:

- **TeXstudio:** *Options → Configure TeXstudio → Build*. Set *Default
  Compiler* to **LuaLaTeX** and *Default Bibliography Tool* to **Biber**
  (bib=apa) or **BibTeX** (bib=acl).
- **VS Code with LaTeX Workshop:** choose the *latexmk (lualatex)* recipe.

The character count needs `bash` and `pdftotext`. They are standard on Linux
and macOS; on Windows, use Git Bash or WSL. If you can't run the script,
leave it out and set the count by hand with `\charcount{85432}`. Until
then, the abstract page shows **???**.

**On Overleaf.** Upload all the files from the repository root. Then set
*Menu → Compiler* to **LuaLaTeX**. Overleaf runs biber or bibtex by itself.
It cannot run `upol-count.sh`, so give the character count by hand with
`\charcount{85432}`.

The class refuses pdfLaTeX. XeLaTeX also works.

## A minimal thesis

```latex
\documentclass[department=kol, type=ba, language=czech, gender=f, bib=apa]{upolthesis}
\thesisbibfile{refs.bib}

\title{Název v jazyce práce}
\titleen{English title}
\author{Jana Nováková}
\supervisor{prof. Francis Bond, PhD}
\abstractcs{...}  \keywordscs{...}
\abstracten{...}  \keywordsen{...}

\begin{document}
\makefrontmatter[lof,lot]   % title page ... contents, lists of figures and tables
\chapter{Úvod}
...
\thesisbibliography
\appendix
\chapter{Data}
\end{document}
```

## Class options

| Option | Values (default first) | Notes |
|---|---|---|
| `department` | `kol`, `kas` | more to come: `kaa`, `kb` |
| `type` | `ba`, `ma`, `phd` | |
| `autoreferat` | | the autoreferát of a dissertation (implies `type=phd`) |
| `language` | `czech`, `slovak`, `english` | language of the thesis |
| `gender` | `x`, `f`, `m` | Czech and Slovak verb forms in the declaration; `x` prints *vypracoval/a* |
| `bib` | `apa`, `acl`, `none` | `apa`: biblatex-apa with biber; `acl`: natbib with `acl_natbib.bst` and bibtex |
| `font` | department default (KOL: `pagella`, KAS: `tnr`); `charis`, `termes`, `none` | `tnr` is Times New Roman, or TeX Gyre Termes if it isn't installed; `charis` (Charis SIL) covers the full IPA |
| `logo` | department default (KOL: `shield`, KAS: `none`); `faculty` | the UP shield, or the full FF logo |
| `cjk` | department default (KAS: `{zh,ja,ko}`) | Chinese (`zh`, `zhtw`), Japanese (`ja`), Korean (`ko`); LuaLaTeX only |
| `spacing` | department default (KOL: 1.3, KAS: 1.241) | line spacing |
| `twoside` | | for printed copies |

We recommend APA or ACL for linguistics. Both accept `\citet`, `\citep`,
`\citealt`, `\citeauthor` and `\citeyear`, so you can switch between them
without changing the text.

## Metadata

Required: `\title` (in the language of the thesis), `\titleen`, `\author`,
`\supervisor`, `\abstractcs` and `\keywordscs` (`\abstractsk` and
`\keywordssk` for a Slovak thesis), `\abstracten` and `\keywordsen`.

Optional:

- `\titlecs`, `\titlesk`: the title in another language, e.g. the Czech
  title of an English thesis
- `\consultant`
- `\thesisyear`: default, the current year
- `\submissiondate`: otherwise the date in the declaration is left blank
- `\acknowledgements`
- `\aiuse`: how AI tools were used, printed under the declaration. The
  university's study rules (SZŘ UP čl. 26 odst. 3) count undisclosed
  AI-generated text as plagiarism.
- `\abbreviations`, `\editorialnote`: a list of abbreviations and an
  editorial note (on transcription, characters, ...), printed after the
  table of contents
- `\charcount`, `\numappendices`, `\numbibitems`: override the automatic
  counts
- for dissertations only:
  - `\programme`: default, the department's programme
  - `\ipstatement`: the statement on intellectual property required by
    SZŘ UP čl. 44 odst. 4h. The class warns if it is missing.
  - `\contribution`: the student's share in a team project (čl. 44 odst. 6),
    printed on its own page

## Counts on the abstract page

- **Pages:** the total number of pages.
- **Appendices:** the number of chapters after `\appendix`.
- **Works cited** (KAS): the number of entries in the bibliography.
- **Characters:** including spaces, from the first chapter after the front
  matter up to the bibliography or appendices. `upol-count.sh` takes them
  from the PDF, so footnotes, captions and page numbers are counted too.

The class warns if the text is shorter than the department's minimum. It
prints **???** for anything missing.

## Figures, tables and examples

`example-kol.tex` shows:

- a table with `booktabs` and `siunitx` (numbers aligned on the decimal
  comma);
- a chart drawn from data with `pgfplots`;
- a diagram in TikZ;
- interlinear glosses with `langsci-gb4e`, which is not part of every TeX
  installation;
- two appendices.

Captions go below figures and tables. To include an image file, use
`\includegraphics[width=.8\textwidth]{image.pdf}`.

The highest value in each column (or row) is in bold: put `\bfseries`
before the number in an `S` column, and it stays aligned. The class's
fonts (TeX Gyre Pagella, TeX Gyre Termes, Times New Roman) have bold digits
exactly as wide as regular ones, so bold numbers line up. Charis SIL's bold
digits are slightly wider.

## Chinese, Japanese and Korean

With `cjk={zh,ja,ko}` (the KAS default), you can type characters straight
into the text. The class switches to the Noto CJK font by itself and breaks
lines in CJK text. Kana and hangul are unambiguous. Han characters without
kana are set as the first language listed: Chinese for KAS. For Japanese
kanji on their own, use `\textja{茶道}`; `\textzh`, `\textzhtw` and
`\textko` work the same way. This needs LuaLaTeX.

## What the KAS preset follows

From *Jak napsat závěrečnou práci na katedře asijských studií* (2023):

- **Length:** BA 30–40, MA 60–80 standard pages. The class warns below the
  minimum and above the maximum.
- **Layout:** Times New Roman 12 pt, 25 mm margins, 1.5 line spacing,
  justified, 1 cm paragraph indent.
- **Order:**
  1. title page;
  2. declaration (no signature);
  3. annotation: the counts of pages, characters, works cited and
     appendices, keywords, and the text from `\abstractcs`;
  4. acknowledgements;
  5. contents and lists;
  6. abbreviations and editorial note;
  7. the text;
  8. `\makeresume` after the conclusion: the English résumé of 100–200
     words from `\abstracten`;
  9. bibliography and appendices.

  The title page, declaration, annotation and acknowledgements count as
  pages but carry no page number.
- **English thesis:** the parallel title and the résumé are in Czech
  instead, from `\titlecs` and `\abstractcs`.
- KAS prescribes no citation style. We recommend APA or ACL.
- KAS publishes no rules for dissertations; `type=phd` uses the faculty
  defaults with the KAS title page.

## What the KOL preset follows

The notes, with sources, are in [`docs/`](docs/).

- **Faculty** (FF-B-23/08):
  - minimum length: BA 30, MA 60 standard pages (normostrany);
  - required parts: title page, declaration, abstract;
  - submission: electronic, through STAG.
  - It sets no typographic rules and does not require PDF/A.
- **KOL bachelor's and master's theses**, from the
  [department page](https://kol.upol.cz/studium/diplomove-prace/) and its Word
  template:
  - language: Czech, Slovak or English;
  - minimum length: BA 72,000 characters, MA 108,000;
  - Czech and English abstracts of at least 900 characters each (not checked
    by the class);
  - any standard citation style.
  - KOL sets no margins, fonts or spacing. The defaults are 25 mm margins
    (30 mm inner), 12 pt TeX Gyre Pagella and 1.3 line spacing.
- **KOL dissertations** (programme *Obecná jazykověda a teorie komunikace*).
  Neither the faculty nor the oborová rada publishes formal rules, so the
  class follows SZŘ UP čl. 44 and recent KOL dissertations.
  - **Title page:** adds the English parallel title and the study programme.
  - **Declaration:** uses the wording of recent KOL dissertations; the
    statement on intellectual property follows it.
  - **Language:** the programme is accredited in Czech only, so an English
    dissertation needs the oborová rada's prior consent (čl. 44 odst. 3).
  - **Autoreferát:** use the `autoreferat` option. The class adds a one-page
    English abstract, and a Czech summary if the dissertation is in another
    language.
  - **Printing:** FF asks for one printed copy; use `twoside`.
  - Still to confirm with the oborová rada: the wording of the IP statement
    (the example gives a suggestion), the extent of the foreign-language
    résumé, the indicative length, and whether a collection of papers is
    allowed.

## Adding a department

Copy `upolthesis-kol.def` to `upolthesis-<dept>.def` and change the names,
thesis-type wording, title page, margins and minimum length. Then use it with
`department=<dept>`.

Planned: KAA and KB.

A Slovak speaker should also check the Slovak wording.

## Licence

The class, the preset and the scripts are © 2026 Francis Bond, under the
[LaTeX Project Public License 1.3c](https://www.latex-project.org/lppl/).

- `acl_natbib.bst` comes from the ACL style files and is also under the LPPL.
- The logos belong to Palacký University Olomouc and are used under its
  [visual identity rules](https://vizual.upol.cz/).
